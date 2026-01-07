diff --git a/backend/demo_seed.sql b/backend/demo_seed.sql
new file mode 100644
index 0000000000000000000000000000000000000000..c7eeee82173a7a5b042a936ae6f93557ad458f85
--- /dev/null
 b/backend/demo_seed.sql
@@ -0,0 1,383 @@
BEGIN;

-- Roles
INSERT INTO roles (name, description, created_at, updated_at) VALUES
('ADMIN', 'Administrador', NOW(), NOW()),
('WAREHOUSE', 'Operador de depósito', NOW(), NOW()),
('PRODUCTION', 'Operador de producción', NOW(), NOW()),
('SALES', 'Operador comercial / remitos', NOW(), NOW()),
('AUDIT', 'Lectura / auditoría', NOW(), NOW())
ON CONFLICT (name) DO NOTHING;

-- Depósitos
INSERT INTO deposits (name, location, controls_lot, is_store, created_at, updated_at) VALUES
('Depósito Principal', 'Fábrica', TRUE, FALSE, NOW(), NOW()),
('Depósito MP', 'Fábrica', TRUE, FALSE, NOW(), NOW()),
('Depósito Empaque', 'Fábrica', FALSE, FALSE, NOW(), NOW()),
('Local Centro', 'Centro', FALSE, TRUE, NOW(), NOW()),
('Local Norte', 'Zona Norte', FALSE, TRUE, NOW(), NOW())
ON CONFLICT (name) DO NOTHING;

-- Tipos de SKU
INSERT INTO sku_types (code, label, is_active, created_at, updated_at) VALUES
('MP', 'Materia Prima', TRUE, NOW(), NOW()),
('SEMI', 'Semielaborado', TRUE, NOW(), NOW()),
('PT', 'Producto Terminado', TRUE, NOW(), NOW()),
('CON', 'Consumible', TRUE, NOW(), NOW()),
('PAP', 'Papelería', TRUE, NOW(), NOW()),
('LIM', 'Limpieza', TRUE, NOW(), NOW()),
('PACK', 'Pack / Packaging', TRUE, NOW(), NOW()),
('OTRO', 'Otro', TRUE, NOW(), NOW())
ON CONFLICT (code) DO NOTHING;

-- Tipos de movimiento
INSERT INTO stock_movement_types (code, label, is_active, created_at, updated_at) VALUES
('PRODUCTION', 'Producción', TRUE, NOW(), NOW()),
('CONSUMPTION', 'Consumo / Receta', TRUE, NOW(), NOW()),
('ADJUSTMENT', 'Ajuste', TRUE, NOW(), NOW()),
('TRANSFER', 'Transferencia', TRUE, NOW(), NOW()),
('REMITO', 'Remito', TRUE, NOW(), NOW()),
('MERMA', 'Merma', TRUE, NOW(), NOW()),
('PURCHASE', 'Ingreso desde Proveedor', TRUE, NOW(), NOW())
ON CONFLICT (code) DO NOTHING;

-- Líneas de producción
INSERT INTO production_lines (name, is_active, created_at, updated_at) VALUES
('Línea 1', TRUE, NOW(), NOW()),
('Línea 2', TRUE, NOW(), NOW()),
('Línea 3', TRUE, NOW(), NOW())
ON CONFLICT (name) DO NOTHING;

-- Tipos de merma
INSERT INTO merma_types (stage, code, label, is_active, created_at, updated_at) VALUES
('production', 'roturas', 'Roturas en producción', TRUE, NOW(), NOW()),
('production', 'defectos', 'Defectos de forma/calidad', TRUE, NOW(), NOW()),
('production', 'masa_descartada', 'Masa descartada', TRUE, NOW(), NOW()),
('empaque', 'roturas_manipulacion', 'Roturas en manipulación', TRUE, NOW(), NOW()),
('empaque', 'faltante_conteo', 'Faltante al contar/armar', TRUE, NOW(), NOW()),
('stock', 'deterioro', 'Deterioro en depósito', TRUE, NOW(), NOW()),
('stock', 'roturas', 'Roturas en depósito', TRUE, NOW(), NOW()),
('stock', 'vencimiento', 'Producto vencido', TRUE, NOW(), NOW()),
('stock', 'ajuste_conteo', 'Ajuste por diferencia de conteo', TRUE, NOW(), NOW()),
('transito_post_remito', 'rotura_entrega', 'Rotura en entrega', TRUE, NOW(), NOW()),
('transito_post_remito', 'faltante_entrega', 'Faltante al entregar', TRUE, NOW(), NOW()),
('administrativa', 'ajuste_carga', 'Ajuste por error de carga', TRUE, NOW(), NOW()),
('administrativa', 'ajuste_remito', 'Ajuste por remito', TRUE, NOW(), NOW()),
('administrativa', 'ajuste_inventario', 'Ajuste por inventario', TRUE, NOW(), NOW()),
('administrativa', 'correccion_contable', 'Corrección contable', TRUE, NOW(), NOW())
ON CONFLICT (stage, code) DO NOTHING;

-- Causas de merma
INSERT INTO merma_causes (stage, code, label, is_active, created_at, updated_at) VALUES
('production', 'temperatura_incorrecta', 'Temperatura incorrecta de máquina', TRUE, NOW(), NOW()),
('production', 'maquina_desajustada', 'Máquina desajustada / mantenimiento', TRUE, NOW(), NOW()),
('production', 'masa_defectuosa', 'Masa defectuosa', TRUE, NOW(), NOW()),
('production', 'error_manipulacion', 'Error de manipulación', TRUE, NOW(), NOW()),
('production', 'golpe_extraccion', 'Golpe en extracción', TRUE, NOW(), NOW()),
('empaque', 'rotura_manipulacion', 'Rotura por manipulación', TRUE, NOW(), NOW()),
('empaque', 'error_pack', 'Error al armar packs', TRUE, NOW(), NOW()),
('empaque', 'caja_danada', 'Caja dañada', TRUE, NOW(), NOW()),
('empaque', 'defecto_prev_no_detectado', 'Defecto previo no detectado', TRUE, NOW(), NOW()),
('empaque', 'error_conteo', 'Error al contar unidades', TRUE, NOW(), NOW()),
('stock', 'humedad', 'Humedad / ambiente', TRUE, NOW(), NOW()),
('stock', 'vencido', 'Producto vencido', TRUE, NOW(), NOW()),
('stock', 'apilado', 'Cajón mal apilado', TRUE, NOW(), NOW()),
('stock', 'golpe_interno', 'Golpe en traslado interno', TRUE, NOW(), NOW()),
('stock', 'diferencia_conteo', 'Diferencia por conteo físico', TRUE, NOW(), NOW()),
('stock', 'remito_faltante', 'Remito no cargado en sistema', TRUE, NOW(), NOW()),
('transito_post_remito', 'golpe_transito', 'Golpe durante el traslado', TRUE, NOW(), NOW()),
('transito_post_remito', 'apilado_transito', 'Aplastamiento por mal apilado', TRUE, NOW(), NOW()),
('transito_post_remito', 'caja_rota_destino', 'Caja rota al descargar', TRUE, NOW(), NOW()),
('transito_post_remito', 'error_carga_camioneta', 'Error al cargar la camioneta', TRUE, NOW(), NOW()),
('transito_post_remito', 'manipulacion_local', 'Manipulación en local al recibir', TRUE, NOW(), NOW()),
('administrativa', 'produccion_mal_cargada', 'Producción mal cargada', TRUE, NOW(), NOW()),
('administrativa', 'empaque_mal_registrado', 'Empaque mal registrado', TRUE, NOW(), NOW()),
('administrativa', 'remito_duplicado', 'Remito duplicado', TRUE, NOW(), NOW()),
('administrativa', 'remito_corregido', 'Remito corregido', TRUE, NOW(), NOW()),
('administrativa', 'carga_deposito_equivocada', 'Carga en depósito equivocado', TRUE, NOW(), NOW()),
('administrativa', 'ajuste_inventario', 'Ajuste inventario semanal/mensual', TRUE, NOW(), NOW()),
('administrativa', 'error_pedido_local', 'Error de pedido local', TRUE, NOW(), NOW())
ON CONFLICT (stage, code) DO NOTHING;

-- SKUs
INSERT INTO skus (code, name, sku_type_id, unit, family, is_active, created_at, updated_at) VALUES
('CUC-PT-24', 'Cucuruchos x24', (SELECT id FROM sku_types WHERE code='PT'), 'box', NULL, TRUE, NOW(), NOW()),
('CUC-GRANEL', 'Cucurucho granel', (SELECT id FROM sku_types WHERE code='SEMI'), 'unit', NULL, TRUE, NOW(), NOW()),
('MP-HARINA', 'Harina 0000', (SELECT id FROM sku_types WHERE code='MP'), 'kg', NULL, TRUE, NOW(), NOW()),
('MP-AZUCAR', 'Azúcar', (SELECT id FROM sku_types WHERE code='MP'), 'kg', NULL, TRUE, NOW(), NOW()),
('MP-ACEITE', 'Aceite vegetal', (SELECT id FROM sku_types WHERE code='MP'), 'l', NULL, TRUE, NOW(), NOW()),
('MP-ESENCIA-V', 'Esencia de vainilla', (SELECT id FROM sku_types WHERE code='MP'), 'l', NULL, TRUE, NOW(), NOW()),
('MP-CACAO', 'Cacao en polvo', (SELECT id FROM sku_types WHERE code='MP'), 'kg', NULL, TRUE, NOW(), NOW()),
('SEMI-CUC-MASA', 'Masa cucurucho', (SELECT id FROM sku_types WHERE code='SEMI'), 'kg', NULL, TRUE, NOW(), NOW()),
('SEMI-CAN-MASA', 'Masa canastita', (SELECT id FROM sku_types WHERE code='SEMI'), 'kg', NULL, TRUE, NOW(), NOW()),
('SEMI-BAR-MASA', 'Masa barquillo', (SELECT id FROM sku_types WHERE code='SEMI'), 'kg', NULL, TRUE, NOW(), NOW()),
('CAN-PT-12', 'Canastitas x12', (SELECT id FROM sku_types WHERE code='PT'), 'box', NULL, TRUE, NOW(), NOW()),
('BAR-PT-20', 'Barquillos x20', (SELECT id FROM sku_types WHERE code='PT'), 'box', NULL, TRUE, NOW(), NOW()),
('CONO-PT-12', 'Conos bañados x12', (SELECT id FROM sku_types WHERE code='PT'), 'box', NULL, TRUE, NOW(), NOW()),
('CUC-PT-12', 'Cucuruchos x12', (SELECT id FROM sku_types WHERE code='PT'), 'box', NULL, TRUE, NOW(), NOW()),
('PACK-CAJA-24', 'Caja master x24', (SELECT id FROM sku_types WHERE code='PACK'), 'unit', NULL, TRUE, NOW(), NOW()),
('PACK-BOLSA-12', 'Bolsa polipropileno x12', (SELECT id FROM sku_types WHERE code='PACK'), 'pack', NULL, TRUE, NOW(), NOW()),
('CON-SEPARADOR', 'Separadores de cartón', (SELECT id FROM sku_types WHERE code='CON'), 'unit', 'consumible', TRUE, NOW(), NOW()),
('CON-FILM', 'Film stretch', (SELECT id FROM sku_types WHERE code='CON'), 'pack', 'consumible', TRUE, NOW(), NOW()),
('CON-ETIQUETA', 'Etiquetas de lote', (SELECT id FROM sku_types WHERE code='CON'), 'unit', 'papeleria', TRUE, NOW(), NOW()),
('CON-REM-01', 'Talonario remitos', (SELECT id FROM sku_types WHERE code='CON'), 'unit', 'papeleria', TRUE, NOW(), NOW()),
('CON-DETERGENTE', 'Detergente industrial', (SELECT id FROM sku_types WHERE code='CON'), 'l', 'limpieza', TRUE, NOW(), NOW()),
('CON-ALCOHOL', 'Alcohol sanitario', (SELECT id FROM sku_types WHERE code='CON'), 'l', 'limpieza', TRUE, NOW(), NOW())
ON CONFLICT (code) DO NOTHING;

-- Recetas
INSERT INTO recipes (product_id, name, created_at, updated_at)
SELECT (SELECT id FROM skus WHERE code='CUC-PT-24'), 'Receta cucuruchos x24', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE product_id=(SELECT id FROM skus WHERE code='CUC-PT-24'));

INSERT INTO recipe_items (recipe_id, component_id, quantity, created_at, updated_at)
SELECT (SELECT id FROM recipes WHERE name='Receta cucuruchos x24'), (SELECT id FROM skus WHERE code='CUC-GRANEL'), 24, NOW(), NOW()
WHERE NOT EXISTS (
  SELECT 1 FROM recipe_items
  WHERE recipe_id=(SELECT id FROM recipes WHERE name='Receta cucuruchos x24')
    AND component_id=(SELECT id FROM skus WHERE code='CUC-GRANEL')
);
INSERT INTO recipe_items (recipe_id, component_id, quantity, created_at, updated_at)
SELECT (SELECT id FROM recipes WHERE name='Receta cucuruchos x24'), (SELECT id FROM skus WHERE code='MP-HARINA'), 0.5, NOW(), NOW()
WHERE NOT EXISTS (
  SELECT 1 FROM recipe_items
  WHERE recipe_id=(SELECT id FROM recipes WHERE name='Receta cucuruchos x24')
    AND component_id=(SELECT id FROM skus WHERE code='MP-HARINA')
);
INSERT INTO recipe_items (recipe_id, component_id, quantity, created_at, updated_at)
SELECT (SELECT id FROM recipes WHERE name='Receta cucuruchos x24'), (SELECT id FROM skus WHERE code='MP-AZUCAR'), 0.15, NOW(), NOW()
WHERE NOT EXISTS (
  SELECT 1 FROM recipe_items
  WHERE recipe_id=(SELECT id FROM recipes WHERE name='Receta cucuruchos x24')
    AND component_id=(SELECT id FROM skus WHERE code='MP-AZUCAR')
);
INSERT INTO recipe_items (recipe_id, component_id, quantity, created_at, updated_at)
SELECT (SELECT id FROM recipes WHERE name='Receta cucuruchos x24'), (SELECT id FROM skus WHERE code='MP-ACEITE'), 0.05, NOW(), NOW()
WHERE NOT EXISTS (
  SELECT 1 FROM recipe_items
  WHERE recipe_id=(SELECT id FROM recipes WHERE name='Receta cucuruchos x24')
    AND component_id=(SELECT id FROM skus WHERE code='MP-ACEITE')
);

INSERT INTO recipes (product_id, name, created_at, updated_at)
SELECT (SELECT id FROM skus WHERE code='CUC-PT-12'), 'Receta cucuruchos x12', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE product_id=(SELECT id FROM skus WHERE code='CUC-PT-12'));

INSERT INTO recipe_items (recipe_id, component_id, quantity, created_at, updated_at)
SELECT (SELECT id FROM recipes WHERE name='Receta cucuruchos x12'), (SELECT id FROM skus WHERE code='SEMI-CUC-MASA'), 0.45, NOW(), NOW()
WHERE NOT EXISTS (
  SELECT 1 FROM recipe_items
  WHERE recipe_id=(SELECT id FROM recipes WHERE name='Receta cucuruchos x12')
    AND component_id=(SELECT id FROM skus WHERE code='SEMI-CUC-MASA')
);
INSERT INTO recipe_items (recipe_id, component_id, quantity, created_at, updated_at)
SELECT (SELECT id FROM recipes WHERE name='Receta cucuruchos x12'), (SELECT id FROM skus WHERE code='MP-ESENCIA-V'), 0.01, NOW(), NOW()
WHERE NOT EXISTS (
  SELECT 1 FROM recipe_items
  WHERE recipe_id=(SELECT id FROM recipes WHERE name='Receta cucuruchos x12')
    AND component_id=(SELECT id FROM skus WHERE code='MP-ESENCIA-V')
);

INSERT INTO recipes (product_id, name, created_at, updated_at)
SELECT (SELECT id FROM skus WHERE code='CAN-PT-12'), 'Receta canastitas x12', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE product_id=(SELECT id FROM skus WHERE code='CAN-PT-12'));

INSERT INTO recipe_items (recipe_id, component_id, quantity, created_at, updated_at)
SELECT (SELECT id FROM recipes WHERE name='Receta canastitas x12'), (SELECT id FROM skus WHERE code='SEMI-CAN-MASA'), 0.55, NOW(), NOW()
WHERE NOT EXISTS (
  SELECT 1 FROM recipe_items
  WHERE recipe_id=(SELECT id FROM recipes WHERE name='Receta canastitas x12')
    AND component_id=(SELECT id FROM skus WHERE code='SEMI-CAN-MASA')
);
INSERT INTO recipe_items (recipe_id, component_id, quantity, created_at, updated_at)
SELECT (SELECT id FROM recipes WHERE name='Receta canastitas x12'), (SELECT id FROM skus WHERE code='MP-ACEITE'), 0.04, NOW(), NOW()
WHERE NOT EXISTS (
  SELECT 1 FROM recipe_items
  WHERE recipe_id=(SELECT id FROM recipes WHERE name='Receta canastitas x12')
    AND component_id=(SELECT id FROM skus WHERE code='MP-ACEITE')
);

INSERT INTO recipes (product_id, name, created_at, updated_at)
SELECT (SELECT id FROM skus WHERE code='BAR-PT-20'), 'Receta barquillos x20', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE product_id=(SELECT id FROM skus WHERE code='BAR-PT-20'));

INSERT INTO recipe_items (recipe_id, component_id, quantity, created_at, updated_at)
SELECT (SELECT id FROM recipes WHERE name='Receta barquillos x20'), (SELECT id FROM skus WHERE code='SEMI-BAR-MASA'), 0.6, NOW(), NOW()
WHERE NOT EXISTS (
  SELECT 1 FROM recipe_items
  WHERE recipe_id=(SELECT id FROM recipes WHERE name='Receta barquillos x20')
    AND component_id=(SELECT id FROM skus WHERE code='SEMI-BAR-MASA')
);
INSERT INTO recipe_items (recipe_id, component_id, quantity, created_at, updated_at)
SELECT (SELECT id FROM recipes WHERE name='Receta barquillos x20'), (SELECT id FROM skus WHERE code='MP-CACAO'), 0.08, NOW(), NOW()
WHERE NOT EXISTS (
  SELECT 1 FROM recipe_items
  WHERE recipe_id=(SELECT id FROM recipes WHERE name='Receta barquillos x20')
    AND component_id=(SELECT id FROM skus WHERE code='MP-CACAO')
);

INSERT INTO recipes (product_id, name, created_at, updated_at)
SELECT (SELECT id FROM skus WHERE code='CONO-PT-12'), 'Receta conos bañados x12', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM recipes WHERE product_id=(SELECT id FROM skus WHERE code='CONO-PT-12'));

INSERT INTO recipe_items (recipe_id, component_id, quantity, created_at, updated_at)
SELECT (SELECT id FROM recipes WHERE name='Receta conos bañados x12'), (SELECT id FROM skus WHERE code='SEMI-CUC-MASA'), 0.5, NOW(), NOW()
WHERE NOT EXISTS (
  SELECT 1 FROM recipe_items
  WHERE recipe_id=(SELECT id FROM recipes WHERE name='Receta conos bañados x12')
    AND component_id=(SELECT id FROM skus WHERE code='SEMI-CUC-MASA')
);
INSERT INTO recipe_items (recipe_id, component_id, quantity, created_at, updated_at)
SELECT (SELECT id FROM recipes WHERE name='Receta conos bañados x12'), (SELECT id FROM skus WHERE code='MP-CACAO'), 0.1, NOW(), NOW()
WHERE NOT EXISTS (
  SELECT 1 FROM recipe_items
  WHERE recipe_id=(SELECT id FROM recipes WHERE name='Receta conos bañados x12')
    AND component_id=(SELECT id FROM skus WHERE code='MP-CACAO')
);

-- Usuarios demo (hash SHA256 de "demo1234")
INSERT INTO users (email, full_name, hashed_password, is_active, role_id, created_at, updated_at) VALUES
('admin@fnc.local', 'Admin Demo', '0ead2060b65992dca4769af601a1b3a35ef38cfad2c2c465bb160ea764157c5d', TRUE, (SELECT id FROM roles WHERE name='ADMIN'), NOW(), NOW()),
('deposito@fnc.local', 'Operador Depósito', '0ead2060b65992dca4769af601a1b3a35ef38cfad2c2c465bb160ea764157c5d', TRUE, (SELECT id FROM roles WHERE name='WAREHOUSE'), NOW(), NOW()),
('produccion@fnc.local', 'Operador Producción', '0ead2060b65992dca4769af601a1b3a35ef38cfad2c2c465bb160ea764157c5d', TRUE, (SELECT id FROM roles WHERE name='PRODUCTION'), NOW(), NOW()),
('ventas@fnc.local', 'Operador Ventas', '0ead2060b65992dca4769af601a1b3a35ef38cfad2c2c465bb160ea764157c5d', TRUE, (SELECT id FROM roles WHERE name='SALES'), NOW(), NOW())
ON CONFLICT (email) DO NOTHING;

-- Conversiones SEMI
INSERT INTO semi_conversion_rules (sku_id, units_per_kg, created_at, updated_at) VALUES
((SELECT id FROM skus WHERE code='SEMI-CUC-MASA'), 40, NOW(), NOW()),
((SELECT id FROM skus WHERE code='SEMI-CAN-MASA'), 32, NOW(), NOW()),
((SELECT id FROM skus WHERE code='SEMI-BAR-MASA'), 28, NOW(), NOW())
ON CONFLICT (sku_id) DO NOTHING;

-- Stock inicial
INSERT INTO stock_levels (sku_id, deposit_id, quantity, created_at, updated_at)
SELECT s.id, d.id, v.quantity, NOW(), NOW()
FROM (
  VALUES
    ('CUC-PT-24', 'Depósito Principal', 120),
    ('CUC-PT-12', 'Depósito Principal', 80),
    ('CAN-PT-12', 'Depósito Principal', 60),
    ('BAR-PT-20', 'Depósito Principal', 45),
    ('CONO-PT-12', 'Depósito Principal', 30),
    ('MP-HARINA', 'Depósito MP', 500),
    ('MP-AZUCAR', 'Depósito MP', 350),
    ('MP-ACEITE', 'Depósito MP', 120),
    ('MP-ESENCIA-V', 'Depósito MP', 45),
    ('MP-CACAO', 'Depósito MP', 80),
    ('CON-SEPARADOR', 'Depósito Empaque', 400),
    ('CON-FILM', 'Depósito Empaque', 180),
    ('CON-ETIQUETA', 'Depósito Empaque', 300),
    ('CON-REM-01', 'Depósito Empaque', 50),
    ('CON-DETERGENTE', 'Depósito Empaque', 25),
    ('CON-ALCOHOL', 'Depósito Empaque', 18)
) AS v(sku_code, deposit_name, quantity)
JOIN skus s ON s.code = v.sku_code
JOIN deposits d ON d.name = v.deposit_name
WHERE NOT EXISTS (
  SELECT 1 FROM stock_levels sl WHERE sl.sku_id = s.id AND sl.deposit_id = d.id
);

-- Lotes de producción
INSERT INTO production_lots (lot_code, sku_id, deposit_id, production_line_id, produced_quantity, remaining_quantity, produced_at, is_blocked, created_at, updated_at) VALUES
('240501-L1-CUC-PT-24-001', (SELECT id FROM skus WHERE code='CUC-PT-24'), (SELECT id FROM deposits WHERE name='Depósito Principal'), (SELECT id FROM production_lines WHERE name='Línea 1'), 120, 120, '2024-05-01', FALSE, NOW(), NOW()),
('240502-L2-CUC-PT-12-001', (SELECT id FROM skus WHERE code='CUC-PT-12'), (SELECT id FROM deposits WHERE name='Depósito Principal'), (SELECT id FROM production_lines WHERE name='Línea 2'), 80, 80, '2024-05-02', FALSE, NOW(), NOW()),
('240503-L1-CAN-PT-12-001', (SELECT id FROM skus WHERE code='CAN-PT-12'), (SELECT id FROM deposits WHERE name='Depósito Principal'), (SELECT id FROM production_lines WHERE name='Línea 1'), 60, 60, '2024-05-03', FALSE, NOW(), NOW()),
('240504-L3-BAR-PT-20-001', (SELECT id FROM skus WHERE code='BAR-PT-20'), (SELECT id FROM deposits WHERE name='Depósito Principal'), (SELECT id FROM production_lines WHERE name='Línea 3'), 45, 45, '2024-05-04', FALSE, NOW(), NOW()),
('240504-L2-CONO-PT-12-001', (SELECT id FROM skus WHERE code='CONO-PT-12'), (SELECT id FROM deposits WHERE name='Depósito Principal'), (SELECT id FROM production_lines WHERE name='Línea 2'), 30, 30, '2024-05-04', FALSE, NOW(), NOW())
ON CONFLICT (lot_code) DO NOTHING;

-- Movimientos de stock
INSERT INTO stock_movements (sku_id, deposit_id, movement_type_id, quantity, reference, movement_date, created_at, updated_at)
SELECT s.id, d.id, mt.id, v.quantity, v.reference, v.movement_date, NOW(), NOW()
FROM (
  VALUES
    ('CUC-PT-24', 'Depósito Principal', 'PRODUCTION', 120, 'DEMO-INIT-PROD-1', CURRENT_DATE - INTERVAL '3 days'),
    ('CAN-PT-12', 'Depósito Principal', 'PRODUCTION', 60, 'DEMO-INIT-PROD-2', CURRENT_DATE - INTERVAL '2 days'),
    ('CUC-PT-24', 'Depósito Principal', 'REMITO', -24, 'DEMO-INIT-REM-1', CURRENT_DATE - INTERVAL '1 days'),
    ('CON-SEPARADOR', 'Depósito Empaque', 'ADJUSTMENT', 40, 'DEMO-INIT-AJ-1', CURRENT_DATE - INTERVAL '4 days'),
    ('MP-HARINA', 'Depósito MP', 'PURCHASE', 200, 'DEMO-INIT-COMPRA-1', CURRENT_DATE - INTERVAL '6 days')
) AS v(sku_code, deposit_name, movement_code, quantity, reference, movement_date)
JOIN skus s ON s.code = v.sku_code
JOIN deposits d ON d.name = v.deposit_name
JOIN stock_movement_types mt ON mt.code = v.movement_code
WHERE NOT EXISTS (
  SELECT 1 FROM stock_movements sm WHERE sm.reference = v.reference
);

-- Pedido demo
INSERT INTO orders (destination, destination_deposit_id, status, requested_for, notes, created_at, updated_at)
SELECT 'Local Centro', (SELECT id FROM deposits WHERE name='Local Centro'), 'submitted', CURRENT_DATE, 'DEMO-ORDER-1', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM orders WHERE notes='DEMO-ORDER-1');

INSERT INTO order_items (order_id, sku_id, quantity, created_at, updated_at)
SELECT o.id, s.id, v.quantity, NOW(), NOW()
FROM (VALUES ('CUC-PT-24', 24), ('CAN-PT-12', 12), ('CON-SEPARADOR', 40)) AS v(sku_code, quantity)
JOIN orders o ON o.notes = 'DEMO-ORDER-1'
JOIN skus s ON s.code = v.sku_code
WHERE NOT EXISTS (
  SELECT 1 FROM order_items oi WHERE oi.order_id = o.id AND oi.sku_id = s.id
);

-- Remito demo
INSERT INTO remitos (order_id, status, destination, source_deposit_id, destination_deposit_id, issue_date, created_at, updated_at)
SELECT o.id, 'pending', 'Local Centro',
       (SELECT id FROM deposits WHERE name='Depósito Principal'),
       (SELECT id FROM deposits WHERE name='Local Centro'),
       CURRENT_DATE, NOW(), NOW()
FROM orders o
WHERE o.notes = 'DEMO-ORDER-1'
  AND NOT EXISTS (SELECT 1 FROM remitos r WHERE r.order_id = o.id);

INSERT INTO remito_items (remito_id, sku_id, quantity, created_at, updated_at)
SELECT r.id, s.id, v.quantity, NOW(), NOW()
FROM (VALUES ('CUC-PT-24', 24), ('CAN-PT-12', 12), ('CON-SEPARADOR', 40)) AS v(sku_code, quantity)
JOIN remitos r ON r.order_id = (SELECT id FROM orders WHERE notes='DEMO-ORDER-1')
JOIN skus s ON s.code = v.sku_code
WHERE NOT EXISTS (
  SELECT 1 FROM remito_items ri WHERE ri.remito_id = r.id AND ri.sku_id = s.id
);

-- Mermas demo
INSERT INTO merma_events (
  stage, type_id, type_code, type_label,
  cause_id, cause_code, cause_label,
  sku_id, quantity, unit, deposit_id,
  production_line_id, detected_at,
  affects_stock, notes, created_at, updated_at
)
SELECT
  'production',
  mt.id, mt.code, mt.label,
  mc.id, mc.code, mc.label,
  s.id, 6, 'box', d.id,
  pl.id, NOW() - INTERVAL '2 days',
  TRUE, 'DEMO-MERMA-1', NOW(), NOW()
FROM merma_types mt
JOIN merma_causes mc ON mc.stage='production' AND mc.code='maquina_desajustada'
JOIN skus s ON s.code='CUC-PT-24'
JOIN deposits d ON d.name='Depósito Principal'
JOIN production_lines pl ON pl.name='Línea 1'
WHERE mt.stage='production' AND mt.code='roturas'
  AND NOT EXISTS (SELECT 1 FROM merma_events me WHERE me.notes='DEMO-MERMA-1');

INSERT INTO merma_events (
  stage, type_id, type_code, type_label,
  cause_id, cause_code, cause_label,
  sku_id, quantity, unit, deposit_id,
  detected_at, affects_stock, notes, created_at, updated_at
)
SELECT
  'stock',
  mt.id, mt.code, mt.label,
  mc.id, mc.code, mc.label,
  s.id, 12, 'unit', d.id,
  NOW() - INTERVAL '1 days', FALSE, 'DEMO-MERMA-2', NOW(), NOW()
FROM merma_types mt
JOIN merma_causes mc ON mc.stage='stock' AND mc.code='humedad'
JOIN skus s ON s.code='CON-SEPARADOR'
JOIN deposits d ON d.name='Depósito Empaque'
WHERE mt.stage='stock' AND mt.code='deterioro'
  AND NOT EXISTS (SELECT 1 FROM merma_events me WHERE me.notes='DEMO-MERMA-2');

COMMIT;

