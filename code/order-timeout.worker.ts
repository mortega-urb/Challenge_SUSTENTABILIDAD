// order-timeout.worker.ts
// Job que corre cada minuto y cancela los pedidos PENDING cuya reserva venció (24hs sin confirmar).

@Injectable()
export class OrderTimeoutWorker {
  constructor(
    private readonly orderRepo: OrderRepository,
    private readonly inventoryService: InventoryService,
    private readonly stockMovementLogger: StockMovementLogger,
    private readonly logger: Logger,
  ) {}

  @Cron('* * * * *')
  async run() {
    const expired = await this.orderRepo.findPendingCreatedBefore(subHours(new Date(), 24));
    for (const order of expired) {
      await this.cancelExpiredOrder(order);
    }
  }

  async cancelExpiredOrder(order: Order) {
    this.logger.log(
      `Pedido ${order.orderNumber} supero el tiempo de reserva (24hs), cancelando automaticamente`,
    );

    await this.inventoryService.restoreStock(order.productId, order.quantity, order.sku);

    try {
      await this.stockMovementLogger.log({
        productId: order.productId,
        orderId: order.id,
        orderNumber: order.orderNumber,
        sku: order.sku,
        type: 'LIBERACION',
        quantity: order.quantity,
      });
    } catch (err) {
      this.logger.warn(
        `No se pudo registrar el movimiento de stock para ${order.orderNumber}, continuando (non-blocking)`,
        err,
      );
    }

    await this.orderRepo.updateStatus(order.id, 'CANCELLED', 'TIMEOUT');
  }
}


// stock-movement-logger.ts
// Servicio compartido para registrar movimientos de stock en la tabla de auditoría (kardex).
// Se usa tanto desde requests HTTP como desde workers/cron jobs.

@Injectable()
export class StockMovementLogger {
  constructor(
    private readonly repo: StockMovementRepository,
    // Contexto del request en curso (AsyncLocalStorage). Lo inicializa RequestContextMiddleware.
    private readonly requestContext: RequestContextService,
    private readonly logger: Logger,
  ) {}

  async log(movement: MovementInput) {
    try {
      const correlationId = this.requestContext.get('request').correlationId;

      await this.repo.insert({
        productId: movement.productId,
        orderId: movement.orderId,
        type: movement.type,
        quantity: movement.quantity,
        correlationId,
        createdAt: new Date(),
      });

      const sign = movement.type === 'RESERVA' ? '-' : '+';
      this.logger.log(
        `Movimiento ${movement.type} registrado para pedido ${movement.orderNumber} (producto=${movement.sku}, qty=${sign}${movement.quantity})`,
      );
    } catch (err) {
      this.logger.error(
        `Fallo al registrar movimiento ${movement.type} para pedido ${movement.orderNumber}: ${err}`,
      );
      throw err;
    }
  }
}
