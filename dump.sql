-- Dump de esquema y datos para el challenge de analisis de logs y datos
-- Base: catalogo / inventario / pedidos de un e-commerce simplificado
-- Los timestamps se guardan en UTC (TIMESTAMP sin zona), igual que en app.log.

CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    sku VARCHAR(20) UNIQUE NOT NULL,
    name VARCHAR(120) NOT NULL
);

CREATE TABLE inventory (
    product_id INTEGER PRIMARY KEY REFERENCES products(id),
    quantity INTEGER NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    order_number VARCHAR(20) UNIQUE NOT NULL,
    product_id INTEGER NOT NULL REFERENCES products(id),
    quantity INTEGER NOT NULL,
    status VARCHAR(20) NOT NULL CHECK (status IN ('PENDING','CONFIRMED','CANCELLED')),
    cancel_reason VARCHAR(20) CHECK (cancel_reason IN ('USER_REQUEST','TIMEOUT')),
    idempotency_key VARCHAR(40) UNIQUE NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE stock_movements (
    id SERIAL PRIMARY KEY,
    product_id INTEGER NOT NULL REFERENCES products(id),
    order_id INTEGER REFERENCES orders(id),
    type VARCHAR(20) NOT NULL CHECK (type IN ('INGRESO','RESERVA','LIBERACION')),
    quantity INTEGER NOT NULL,
    correlation_id VARCHAR(40),
    created_at TIMESTAMP NOT NULL
);

-- Productos
INSERT INTO products (id, sku, name) VALUES (1, 'SKU-001', 'Auriculares Bluetooth X200');
INSERT INTO products (id, sku, name) VALUES (2, 'SKU-002', 'Mouse Inalambrico M3');
INSERT INTO products (id, sku, name) VALUES (3, 'SKU-003', 'Teclado Mecanico K7');
INSERT INTO products (id, sku, name) VALUES (4, 'SKU-004', 'Monitor 24 FullHD');
INSERT INTO products (id, sku, name) VALUES (5, 'SKU-005', 'Webcam HD 1080p');
INSERT INTO products (id, sku, name) VALUES (6, 'SKU-006', 'Hub USB-C 6 en 1');
INSERT INTO products (id, sku, name) VALUES (7, 'SKU-007', 'Cargador Rapido 65W');
INSERT INTO products (id, sku, name) VALUES (8, 'SKU-008', 'Parlante Portatil P2');

-- Pedidos
INSERT INTO orders (id, order_number, product_id, quantity, status, cancel_reason, idempotency_key, created_at, updated_at) VALUES (1, 'ORD-1001', 1, 2, 'CONFIRMED', NULL, 'ck-92d01bef', '2026-08-20T08:00:00', '2026-08-20T08:00:00');
INSERT INTO orders (id, order_number, product_id, quantity, status, cancel_reason, idempotency_key, created_at, updated_at) VALUES (2, 'ORD-1002', 1, 1, 'CONFIRMED', NULL, 'ck-20c8acb4', '2026-08-20T14:00:00', '2026-08-20T14:00:00');
INSERT INTO orders (id, order_number, product_id, quantity, status, cancel_reason, idempotency_key, created_at, updated_at) VALUES (3, 'ORD-1003', 1, 3, 'CONFIRMED', NULL, 'ck-26caf4bd', '2026-08-20T20:00:00', '2026-08-20T20:00:00');
INSERT INTO orders (id, order_number, product_id, quantity, status, cancel_reason, idempotency_key, created_at, updated_at) VALUES (4, 'ORD-1004', 1, 2, 'CANCELLED', 'USER_REQUEST', 'ck-94c35322', '2026-08-21T02:00:00', '2026-08-21T05:00:00');
INSERT INTO orders (id, order_number, product_id, quantity, status, cancel_reason, idempotency_key, created_at, updated_at) VALUES (5, 'ORD-1005', 1, 1, 'CONFIRMED', NULL, 'ck-9ac59b2b', '2026-08-21T08:00:00', '2026-08-21T08:00:00');
INSERT INTO orders (id, order_number, product_id, quantity, status, cancel_reason, idempotency_key, created_at, updated_at) VALUES (6, 'ORD-1006', 2, 5, 'CONFIRMED', NULL, 'ck-88bec310', '2026-08-21T14:00:00', '2026-08-21T14:00:00');
INSERT INTO orders (id, order_number, product_id, quantity, status, cancel_reason, idempotency_key, created_at, updated_at) VALUES (7, 'ORD-1007', 2, 3, 'CANCELLED', 'USER_REQUEST', 'ck-8ec10b19', '2026-08-21T20:00:00', '2026-08-21T23:00:00');
INSERT INTO orders (id, order_number, product_id, quantity, status, cancel_reason, idempotency_key, created_at, updated_at) VALUES (8, 'ORD-1008', 2, 2, 'CONFIRMED', NULL, 'ck-9ce174ce', '2026-08-22T02:00:00', '2026-08-22T02:00:00');
INSERT INTO orders (id, order_number, product_id, quantity, status, cancel_reason, idempotency_key, created_at, updated_at) VALUES (9, 'ORD-1009', 2, 4, 'CONFIRMED', NULL, 'ck-a2e3bcd7', '2026-08-22T08:00:00', '2026-08-22T08:00:00');
INSERT INTO orders (id, order_number, product_id, quantity, status, cancel_reason, idempotency_key, created_at, updated_at) VALUES (10, 'ORD-1010', 2, 1, 'CANCELLED', 'USER_REQUEST', 'ck-fc9be00d', '2026-08-22T14:00:00', '2026-08-22T17:00:00');
INSERT INTO orders (id, order_number, product_id, quantity, status, cancel_reason, idempotency_key, created_at, updated_at) VALUES (11, 'ORD-1011', 3, 2, 'CONFIRMED', NULL, 'ck-f6999804', '2026-08-22T20:00:00', '2026-08-22T20:00:00');
INSERT INTO orders (id, order_number, product_id, quantity, status, cancel_reason, idempotency_key, created_at, updated_at) VALUES (12, 'ORD-1012', 3, 3, 'CANCELLED', 'TIMEOUT', 'ck-68a1073f', '2026-08-23T02:00:00', '2026-08-24T02:00:00');
INSERT INTO orders (id, order_number, product_id, quantity, status, cancel_reason, idempotency_key, created_at, updated_at) VALUES (13, 'ORD-1013', 3, 1, 'CONFIRMED', NULL, 'ck-629ebf36', '2026-08-23T08:00:00', '2026-08-23T08:00:00');
INSERT INTO orders (id, order_number, product_id, quantity, status, cancel_reason, idempotency_key, created_at, updated_at) VALUES (14, 'ORD-1014', 3, 4, 'CANCELLED', 'TIMEOUT', 'ck-6491f669', '2026-08-23T14:00:00', '2026-08-24T14:00:00');
INSERT INTO orders (id, order_number, product_id, quantity, status, cancel_reason, idempotency_key, created_at, updated_at) VALUES (15, 'ORD-1015', 3, 2, 'CANCELLED', 'USER_REQUEST', 'ck-5e8fae60', '2026-08-23T20:00:00', '2026-08-23T23:00:00');
INSERT INTO orders (id, order_number, product_id, quantity, status, cancel_reason, idempotency_key, created_at, updated_at) VALUES (16, 'ORD-1016', 3, 1, 'CONFIRMED', NULL, 'ck-f0974ffb', '2026-08-24T02:00:00', '2026-08-24T02:00:00');
INSERT INTO orders (id, order_number, product_id, quantity, status, cancel_reason, idempotency_key, created_at, updated_at) VALUES (17, 'ORD-1017', 4, 2, 'CONFIRMED', NULL, 'ck-6a943e72', '2026-08-24T08:00:00', '2026-08-24T08:00:00');
INSERT INTO orders (id, order_number, product_id, quantity, status, cancel_reason, idempotency_key, created_at, updated_at) VALUES (18, 'ORD-1018', 4, 1, 'CONFIRMED', NULL, 'ck-6cb01815', '2026-08-24T14:00:00', '2026-08-24T14:00:00');
INSERT INTO orders (id, order_number, product_id, quantity, status, cancel_reason, idempotency_key, created_at, updated_at) VALUES (19, 'ORD-1019', 4, 3, 'CANCELLED', 'USER_REQUEST', 'ck-e6ad068c', '2026-08-24T20:00:00', '2026-08-24T23:00:00');
INSERT INTO orders (id, order_number, product_id, quantity, status, cancel_reason, idempotency_key, created_at, updated_at) VALUES (20, 'ORD-1020', 4, 2, 'CONFIRMED', NULL, 'ck-1fe793cc', '2026-08-25T02:00:00', '2026-08-25T02:00:00');
INSERT INTO orders (id, order_number, product_id, quantity, status, cancel_reason, idempotency_key, created_at, updated_at) VALUES (21, 'ORD-1021', 5, 4, 'CONFIRMED', NULL, 'ck-a5eaa555', '2026-08-25T08:00:00', '2026-08-25T08:00:00');
INSERT INTO orders (id, order_number, product_id, quantity, status, cancel_reason, idempotency_key, created_at, updated_at) VALUES (22, 'ORD-1022', 5, 2, 'CONFIRMED', NULL, 'ck-abeced5e', '2026-08-25T14:00:00', '2026-08-25T14:00:00');
INSERT INTO orders (id, order_number, product_id, quantity, status, cancel_reason, idempotency_key, created_at, updated_at) VALUES (23, 'ORD-1023', 5, 3, 'CONFIRMED', NULL, 'ck-b1ef3567', '2026-08-25T20:00:00', '2026-08-25T20:00:00');
INSERT INTO orders (id, order_number, product_id, quantity, status, cancel_reason, idempotency_key, created_at, updated_at) VALUES (24, 'ORD-1024', 5, 2, 'CANCELLED', 'TIMEOUT', 'ck-a7dddc88', '2026-08-26T02:00:00', '2026-08-27T02:00:01');
INSERT INTO orders (id, order_number, product_id, quantity, status, cancel_reason, idempotency_key, created_at, updated_at) VALUES (25, 'ORD-1025', 6, 3, 'CONFIRMED', NULL, 'ck-ade02491', '2026-08-26T08:00:00', '2026-08-26T08:00:00');
INSERT INTO orders (id, order_number, product_id, quantity, status, cancel_reason, idempotency_key, created_at, updated_at) VALUES (26, 'ORD-1026', 6, 5, 'CANCELLED', 'TIMEOUT', 'ck-33e3361a', '2026-08-26T14:00:00', '2026-08-27T14:00:00');
INSERT INTO orders (id, order_number, product_id, quantity, status, cancel_reason, idempotency_key, created_at, updated_at) VALUES (27, 'ORD-1027', 6, 2, 'CONFIRMED', NULL, 'ck-19e54bc3', '2026-08-26T20:00:00', '2026-08-26T20:00:00');
INSERT INTO orders (id, order_number, product_id, quantity, status, cancel_reason, idempotency_key, created_at, updated_at) VALUES (28, 'ORD-1028', 6, 1, 'CANCELLED', 'USER_REQUEST', 'ck-2fd42544', '2026-08-27T02:00:00', '2026-08-27T05:00:00');
INSERT INTO orders (id, order_number, product_id, quantity, status, cancel_reason, idempotency_key, created_at, updated_at) VALUES (29, 'ORD-1029', 6, 4, 'CONFIRMED', NULL, 'ck-35d66d4d', '2026-08-27T08:00:00', '2026-08-27T08:00:00');
INSERT INTO orders (id, order_number, product_id, quantity, status, cancel_reason, idempotency_key, created_at, updated_at) VALUES (30, 'ORD-1030', 7, 2, 'CONFIRMED', NULL, 'ck-9e7ef9f7', '2026-08-27T14:00:00', '2026-08-27T14:00:00');
INSERT INTO orders (id, order_number, product_id, quantity, status, cancel_reason, idempotency_key, created_at, updated_at) VALUES (31, 'ORD-1031', 7, 3, 'CONFIRMED', NULL, 'ck-987cb1ee', '2026-08-27T20:00:00', '2026-08-27T20:00:00');
INSERT INTO orders (id, order_number, product_id, quantity, status, cancel_reason, idempotency_key, created_at, updated_at) VALUES (32, 'ORD-1032', 7, 1, 'CONFIRMED', NULL, 'ck-927a69e5', '2026-08-28T02:00:00', '2026-08-28T02:00:00');
INSERT INTO orders (id, order_number, product_id, quantity, status, cancel_reason, idempotency_key, created_at, updated_at) VALUES (33, 'ORD-1033', 8, 2, 'CONFIRMED', NULL, 'ck-7f3a91d2', '2026-08-28T08:00:00', '2026-08-28T08:00:00');
INSERT INTO orders (id, order_number, product_id, quantity, status, cancel_reason, idempotency_key, created_at, updated_at) VALUES (34, 'ORD-1034', 8, 1, 'CANCELLED', 'USER_REQUEST', 'ck-06751053', '2026-08-28T14:00:00', '2026-08-28T17:00:00');
INSERT INTO orders (id, order_number, product_id, quantity, status, cancel_reason, idempotency_key, created_at, updated_at) VALUES (35, 'ORD-1035', 8, 3, 'CONFIRMED', NULL, 'ck-2072faaa', '2026-08-28T20:00:00', '2026-08-28T20:00:00');

-- Movimientos de stock
INSERT INTO stock_movements (id, product_id, order_id, type, quantity, correlation_id, created_at) VALUES (1, 1, NULL, 'INGRESO', 50, NULL, '2026-08-19T20:00:00');
INSERT INTO stock_movements (id, product_id, order_id, type, quantity, correlation_id, created_at) VALUES (2, 2, NULL, 'INGRESO', 80, NULL, '2026-08-19T20:00:00');
INSERT INTO stock_movements (id, product_id, order_id, type, quantity, correlation_id, created_at) VALUES (3, 3, NULL, 'INGRESO', 40, NULL, '2026-08-19T20:00:00');
INSERT INTO stock_movements (id, product_id, order_id, type, quantity, correlation_id, created_at) VALUES (4, 4, NULL, 'INGRESO', 25, NULL, '2026-08-19T20:00:00');
INSERT INTO stock_movements (id, product_id, order_id, type, quantity, correlation_id, created_at) VALUES (5, 5, NULL, 'INGRESO', 60, NULL, '2026-08-19T20:00:00');
INSERT INTO stock_movements (id, product_id, order_id, type, quantity, correlation_id, created_at) VALUES (6, 6, NULL, 'INGRESO', 70, NULL, '2026-08-19T20:00:00');
INSERT INTO stock_movements (id, product_id, order_id, type, quantity, correlation_id, created_at) VALUES (7, 7, NULL, 'INGRESO', 90, NULL, '2026-08-19T20:00:00');
INSERT INTO stock_movements (id, product_id, order_id, type, quantity, correlation_id, created_at) VALUES (8, 8, NULL, 'INGRESO', 35, NULL, '2026-08-19T20:00:00');
INSERT INTO stock_movements (id, product_id, order_id, type, quantity, correlation_id, created_at) VALUES (9, 1, 1, 'RESERVA', 2, 'req-da6aa1d0295c', '2026-08-20T08:00:00');
INSERT INTO stock_movements (id, product_id, order_id, type, quantity, correlation_id, created_at) VALUES (10, 1, 2, 'RESERVA', 1, 'req-acc2bc182e17', '2026-08-20T14:00:00');
INSERT INTO stock_movements (id, product_id, order_id, type, quantity, correlation_id, created_at) VALUES (11, 1, 3, 'RESERVA', 3, 'req-32c5cda1c343', '2026-08-20T20:00:00');
INSERT INTO stock_movements (id, product_id, order_id, type, quantity, correlation_id, created_at) VALUES (12, 1, 4, 'RESERVA', 2, 'req-38c815aaef51', '2026-08-21T02:00:00');
INSERT INTO stock_movements (id, product_id, order_id, type, quantity, correlation_id, created_at) VALUES (13, 1, 4, 'LIBERACION', 2, 'req-1eca2b53ac55', '2026-08-21T05:00:00');
INSERT INTO stock_movements (id, product_id, order_id, type, quantity, correlation_id, created_at) VALUES (14, 1, 5, 'RESERVA', 1, 'req-a4cd3cdcd9d2', '2026-08-21T08:00:00');
INSERT INTO stock_movements (id, product_id, order_id, type, quantity, correlation_id, created_at) VALUES (15, 2, 6, 'RESERVA', 5, 'req-aacf84e5f268', '2026-08-21T14:00:00');
INSERT INTO stock_movements (id, product_id, order_id, type, quantity, correlation_id, created_at) VALUES (16, 2, 7, 'RESERVA', 3, 'req-b0d1ccee5e78', '2026-08-21T20:00:00');
INSERT INTO stock_movements (id, product_id, order_id, type, quantity, correlation_id, created_at) VALUES (17, 2, 7, 'LIBERACION', 3, 'req-b6d414f73c93', '2026-08-21T23:00:00');
INSERT INTO stock_movements (id, product_id, order_id, type, quantity, correlation_id, created_at) VALUES (18, 2, 8, 'RESERVA', 2, 'req-9caf1b301b68', '2026-08-22T02:00:00');
INSERT INTO stock_movements (id, product_id, order_id, type, quantity, correlation_id, created_at) VALUES (19, 2, 9, 'RESERVA', 4, 'req-a2b16339ec9a', '2026-08-22T08:00:00');
INSERT INTO stock_movements (id, product_id, order_id, type, quantity, correlation_id, created_at) VALUES (20, 2, 10, 'RESERVA', 1, 'req-6976d5f9904c', '2026-08-22T14:00:00');
INSERT INTO stock_movements (id, product_id, order_id, type, quantity, correlation_id, created_at) VALUES (21, 2, 10, 'LIBERACION', 1, 'req-63748df058af', '2026-08-22T17:00:00');
INSERT INTO stock_movements (id, product_id, order_id, type, quantity, correlation_id, created_at) VALUES (22, 3, 11, 'RESERVA', 2, 'req-f57c2f8bebb6', '2026-08-22T20:00:00');
INSERT INTO stock_movements (id, product_id, order_id, type, quantity, correlation_id, created_at) VALUES (23, 3, 12, 'RESERVA', 3, 'req-ef79e7825cbf', '2026-08-23T02:00:00');
INSERT INTO stock_movements (id, product_id, order_id, type, quantity, correlation_id, created_at) VALUES (24, 3, 13, 'RESERVA', 1, 'req-0180bf9d9a83', '2026-08-23T08:00:00');
INSERT INTO stock_movements (id, product_id, order_id, type, quantity, correlation_id, created_at) VALUES (25, 3, 14, 'RESERVA', 4, 'req-fb7e77949131', '2026-08-23T14:00:00');
INSERT INTO stock_movements (id, product_id, order_id, type, quantity, correlation_id, created_at) VALUES (26, 3, 15, 'RESERVA', 2, 'req-6d85e6cfc610', '2026-08-23T20:00:00');
INSERT INTO stock_movements (id, product_id, order_id, type, quantity, correlation_id, created_at) VALUES (27, 3, 15, 'LIBERACION', 2, 'req-67839ec6718a', '2026-08-23T23:00:00');
INSERT INTO stock_movements (id, product_id, order_id, type, quantity, correlation_id, created_at) VALUES (28, 3, 16, 'RESERVA', 1, 'req-f98b4061e6cd', '2026-08-24T02:00:00');
INSERT INTO stock_movements (id, product_id, order_id, type, quantity, correlation_id, created_at) VALUES (29, 4, 17, 'RESERVA', 2, 'req-73882ed8f02e', '2026-08-24T08:00:00');
INSERT INTO stock_movements (id, product_id, order_id, type, quantity, correlation_id, created_at) VALUES (30, 4, 18, 'RESERVA', 1, 'req-09f21f8ec121', '2026-08-24T14:00:00');
INSERT INTO stock_movements (id, product_id, order_id, type, quantity, correlation_id, created_at) VALUES (31, 4, 19, 'RESERVA', 3, 'req-0ff46797de96', '2026-08-24T20:00:00');
INSERT INTO stock_movements (id, product_id, order_id, type, quantity, correlation_id, created_at) VALUES (32, 4, 19, 'LIBERACION', 3, 'req-7decc5fc68e6', '2026-08-24T23:00:00');
INSERT INTO stock_movements (id, product_id, order_id, type, quantity, correlation_id, created_at) VALUES (33, 4, 20, 'RESERVA', 2, 'req-83ef0e0502ac', '2026-08-25T02:00:00');
INSERT INTO stock_movements (id, product_id, order_id, type, quantity, correlation_id, created_at) VALUES (34, 5, 21, 'RESERVA', 4, 'req-11e79eca24c5', '2026-08-25T08:00:00');
INSERT INTO stock_movements (id, product_id, order_id, type, quantity, correlation_id, created_at) VALUES (35, 5, 22, 'RESERVA', 2, 'req-77ea7df35dd3', '2026-08-25T14:00:00');
INSERT INTO stock_movements (id, product_id, order_id, type, quantity, correlation_id, created_at) VALUES (36, 5, 23, 'RESERVA', 3, 'req-05e30eb8678b', '2026-08-25T20:00:00');
INSERT INTO stock_movements (id, product_id, order_id, type, quantity, correlation_id, created_at) VALUES (37, 5, 24, 'RESERVA', 2, 'req-0be556c171eb', '2026-08-26T02:00:00');
INSERT INTO stock_movements (id, product_id, order_id, type, quantity, correlation_id, created_at) VALUES (38, 5, 24, 'LIBERACION', 2, 'req-79ddb52655ef', '2026-08-27T02:00:01');
INSERT INTO stock_movements (id, product_id, order_id, type, quantity, correlation_id, created_at) VALUES (39, 6, 25, 'RESERVA', 3, 'req-ffe0c6afe808', '2026-08-26T08:00:00');
INSERT INTO stock_movements (id, product_id, order_id, type, quantity, correlation_id, created_at) VALUES (40, 6, 26, 'RESERVA', 5, 'req-c6a6396f778e', '2026-08-26T14:00:00');
INSERT INTO stock_movements (id, product_id, order_id, type, quantity, correlation_id, created_at) VALUES (41, 6, 27, 'RESERVA', 2, 'req-40a327e6dc92', '2026-08-26T20:00:00');
INSERT INTO stock_movements (id, product_id, order_id, type, quantity, correlation_id, created_at) VALUES (42, 6, 28, 'RESERVA', 1, 'req-5aa1123d7f7d', '2026-08-27T02:00:00');
INSERT INTO stock_movements (id, product_id, order_id, type, quantity, correlation_id, created_at) VALUES (43, 6, 28, 'LIBERACION', 1, 'req-549eca3491d4', '2026-08-27T05:00:00');
INSERT INTO stock_movements (id, product_id, order_id, type, quantity, correlation_id, created_at) VALUES (44, 6, 29, 'RESERVA', 4, 'req-ce9bb8abccb1', '2026-08-27T08:00:00');
INSERT INTO stock_movements (id, product_id, order_id, type, quantity, correlation_id, created_at) VALUES (45, 7, 30, 'RESERVA', 2, 'req-c89970a2826f', '2026-08-27T14:00:00');
INSERT INTO stock_movements (id, product_id, order_id, type, quantity, correlation_id, created_at) VALUES (46, 7, 31, 'RESERVA', 3, 'req-c2972899b7f3', '2026-08-27T20:00:00');
INSERT INTO stock_movements (id, product_id, order_id, type, quantity, correlation_id, created_at) VALUES (47, 7, 32, 'RESERVA', 1, 'req-bc94e090c25b', '2026-08-28T02:00:00');
INSERT INTO stock_movements (id, product_id, order_id, type, quantity, correlation_id, created_at) VALUES (48, 8, 33, 'RESERVA', 2, 'req-d6b9da57c597', '2026-08-28T08:00:00');
INSERT INTO stock_movements (id, product_id, order_id, type, quantity, correlation_id, created_at) VALUES (49, 8, 34, 'RESERVA', 1, 'req-d0b7924e42cd', '2026-08-28T14:00:00');
INSERT INTO stock_movements (id, product_id, order_id, type, quantity, correlation_id, created_at) VALUES (50, 8, 34, 'LIBERACION', 1, 'req-e80e3c24283b', '2026-08-28T17:00:00');
INSERT INTO stock_movements (id, product_id, order_id, type, quantity, correlation_id, created_at) VALUES (51, 8, 35, 'RESERVA', 3, 'req-6e114dad95c3', '2026-08-28T20:00:00');
INSERT INTO stock_movements (id, product_id, order_id, type, quantity, correlation_id, created_at) VALUES (52, 8, 33, 'RESERVA', 2, 'req-54136356b1d4', '2026-08-28T08:00:04');

-- Inventario actual (tabla 'oficial' que consulta el panel de producto)
INSERT INTO inventory (product_id, quantity, updated_at) VALUES (1, 43, '2026-08-21T08:00:00');
INSERT INTO inventory (product_id, quantity, updated_at) VALUES (2, 69, '2026-08-22T17:00:00');
INSERT INTO inventory (product_id, quantity, updated_at) VALUES (3, 36, '2026-08-24T14:00:00');
INSERT INTO inventory (product_id, quantity, updated_at) VALUES (4, 20, '2026-08-25T02:00:00');
INSERT INTO inventory (product_id, quantity, updated_at) VALUES (5, 53, '2026-08-27T02:00:00');
INSERT INTO inventory (product_id, quantity, updated_at) VALUES (6, 61, '2026-08-27T14:00:00');
INSERT INTO inventory (product_id, quantity, updated_at) VALUES (7, 84, '2026-08-28T02:00:00');
INSERT INTO inventory (product_id, quantity, updated_at) VALUES (8, 30, '2026-08-28T20:00:00');

-- Ajuste de secuencias (los inserts usan ids explicitos)
SELECT setval('products_id_seq', (SELECT MAX(id) FROM products));
SELECT setval('orders_id_seq', (SELECT MAX(id) FROM orders));
SELECT setval('stock_movements_id_seq', (SELECT MAX(id) FROM stock_movements));
