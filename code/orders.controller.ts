// orders.controller.ts
// Endpoints de pedidos.

@Controller()
export class OrdersController {
  constructor(
    private readonly orderService: OrderService,
    private readonly stockService: StockService,
  ) {}

  @Post('orders')
  async createOrder(
    @Body() dto: CreateOrderDto,
    @Headers('Idempotency-Key') idempotencyKey: string,
  ) {
    const order = await this.orderService.create(dto, idempotencyKey);
    await this.stockService.reserve(order.productId, order.quantity, order.id, order.orderNumber, order.sku);
    return order;
  }

  @Post('orders/:id/cancel')
  async cancelOrder(@Param('id', ParseIntPipe) id: number) {
    return this.orderService.cancelByUser(id);
  }
}
