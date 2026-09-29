// orders.service.ts
// Alta y cancelación de pedidos iniciadas por el usuario.

@Injectable()
export class OrderService {
  constructor(
    private readonly orderRepo: OrderRepository,
    private readonly inventoryService: InventoryService,
    private readonly stockMovementLogger: StockMovementLogger,
    private readonly logger: Logger,
  ) {}

  async create(dto: CreateOrderDto, idempotencyKey: string): Promise<Order> {
    const existing = await this.orderRepo.findByIdempotencyKey(idempotencyKey);
    if (existing) {
      this.logger.log(
        `Pedido ${existing.orderNumber} ya existente para idempotency-key=${idempotencyKey}, se devuelve el existente`,
      );
      return existing;
    }

    const order = await this.orderRepo.insert({ ...dto, status: 'PENDING', idempotencyKey });
    this.logger.log(`Pedido ${order.orderNumber} creado para producto ${order.sku}, cantidad=${order.quantity}`);
    return order;
  }

  async cancelByUser(orderId: number): Promise<Order> {
    const order = await this.orderRepo.findById(orderId);
    if (order.status !== 'PENDING') {
      throw new ConflictException(`El pedido ${order.orderNumber} no se puede cancelar (estado ${order.status})`);
    }

    this.logger.log(`Cancelacion solicitada por el usuario para pedido ${order.orderNumber}`);

    await this.inventoryService.restoreStock(order.productId, order.quantity, order.sku);
    await this.stockMovementLogger.log({
      productId: order.productId,
      orderId: order.id,
      orderNumber: order.orderNumber,
      sku: order.sku,
      type: 'LIBERACION',
      quantity: order.quantity,
    });
    await this.orderRepo.updateStatus(order.id, 'CANCELLED', 'USER_REQUEST');

    return { ...order, status: 'CANCELLED', cancelReason: 'USER_REQUEST' };
  }
}
