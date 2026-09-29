# Incidente reportado

**Reportado por:** equipo de Atención al Cliente
**Sistema:** catálogo e inventario (e-commerce)

> "Estamos viendo que el stock de algunos productos no coincide según la pantalla que consultemos. En el panel de producto un artículo muestra una cantidad, pero en el historial de movimientos de stock (kardex) da un número distinto para el mismo producto. Notamos esto en más de un producto, no sabemos si es la misma causa en todos los casos o son cosas distintas."

## Contexto del sistema (cómo funciona hoy)

- El **panel de producto** muestra el stock de la tabla `inventory`. El **kardex** se calcula a partir de la tabla `stock_movements`.
- Cuando se crea un pedido (`POST /api/orders`), queda en estado `PENDING`, se resta la cantidad del stock disponible y se registra un movimiento de tipo `RESERVA`. El endpoint recibe un header `Idempotency-Key` para que los reintentos del cliente no dupliquen pedidos.
- Si el pedido se **confirma**, pasa a `CONFIRMED` y no hay cambios adicionales de stock (la reserva queda firme).
- Mientras está `PENDING`, el pedido se puede **cancelar**:
  - por el usuario (`POST /api/orders/:id/cancel`), o
  - automáticamente por el sistema, mediante un worker que corre cada minuto y cancela los pedidos con más de 24 hs sin confirmar.

  En ambos casos el stock debería restituirse y registrarse un movimiento de tipo `LIBERACION`.
- Todo movimiento de stock (`INGRESO`, `RESERVA`, `LIBERACION`) queda auditado en `stock_movements`.

## Material disponible

- `dump.sql`: base de datos con productos, inventario, pedidos y movimientos de stock.
- `app.log`: extracto de logs de la aplicación del período relevante.
- `code/`: fragmentos del código involucrado en el flujo de pedidos, reservas y cancelaciones.

## Lo que se pide

1. ¿A cuántos productos afecta el problema reportado?
2. Para cada uno, ¿la causa es la misma o son problemas distintos?
3. Para cada producto afectado, ¿qué valor es el correcto, el del panel o el del kardex? ¿Cuál debería ser el stock real? Justificá.
4. Para cada causa identificada, ¿qué evidencia (queries SQL, líneas de log y/o líneas de código) la sostiene?
5. En el código provisto, señalá el punto exacto donde ocurre cada bug y proponé el fix. Si además del fix inmediato hay un problema de diseño de fondo, explicalo y proponé cómo lo resolverías.
6. Escribí el script SQL para corregir los datos. Tené en cuenta que se ejecutaría sobre la base productiva y que `stock_movements` es una tabla de auditoría.
7. ¿Cómo determinarías el alcance real del problema en producción, más allá de este extracto? ¿Qué harías para prevenirlo y para detectarlo automáticamente en el futuro?
8. Si encontrás algo en los logs que llame la atención pero no esté relacionado con el problema de stock, mencionalo y explicá por qué lo descartaste.
9. Redactá el mensaje para Atención al Cliente y el resumen técnico del incidente (ver README).
