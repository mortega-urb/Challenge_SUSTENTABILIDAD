// stock.service.ts
// Servicio encargado de aplicar la reserva de stock al crear un pedido.

@Injectable()
export class StockService {
  constructor(
    private readonly inventoryRepo: InventoryRepository,
    private readonly movementRepo: StockMovementRepository,
    private readonly requestContext: RequestContextService,
    private readonly logger: Logger,
  ) {}

  async reserve(productId: number, quantity: number, orderId: number, orderNumber: string, sku: string) {
    // La resta de stock es idempotente: si ya se aplicó para esta orden, no vuelve a descontar.
    await this.inventoryRepo.decrementIfNotApplied(productId, quantity, orderId);

    await this.movementRepo.insert({
      productId,
      orderId,
      type: 'RESERVA',
      quantity,
      correlationId: this.requestContext.get('request').correlationId,
      createdAt: new Date(),
    });

    this.logger.log(
      `Movimiento RESERVA registrado para pedido ${orderNumber} (producto=${sku}, qty=-${quantity})`,
    );
  }
}
