INSERT INTO deposits (name, location, controls_lot, is_store, created_at, updated_at)
VALUES
  ('La Cigale (Av. 18 de Julio 1179)', 'Av. 18 de Julio 1179', true, true, NOW(), NOW()),
  ('La Cigale (Ejido 1337)', 'Ejido 1337 (Centro)', true, true, NOW(), NOW()),
  ('La Cigale (José Ellauri 350)', 'José Ellauri 350 (Punta Carretas, dentro de Punta Carretas Shopping)', true, true, NOW(), NOW()),
  ('La Cigale (Dr. Joaquín Requena 1550)', 'Dr. Joaquín Requena 1550 (Cordón)', true, true, NOW(), NOW()),
  ('La Cigale (Sarandí 570)', 'Sarandí 570 (Ciudad Vieja)', true, true, NOW(), NOW()),
  ('La Cigale (Roque Graseras 845)', 'Roque Graseras 845 (Pocitos)', true, true, NOW(), NOW()),
  ('La Cigale (Miguel Barreiro 3360)', 'Edificio Pocitos, Miguel Barreiro 3360', true, true, NOW(), NOW()),
  ('La Cigale (Francisco Joaquín Muñoz 3398)', 'Francisco Joaquín Muñoz 3398 (Pocitos)', true, true, NOW(), NOW()),
  ('La Cigale (Orinoco 4851)', 'Orinoco 4851 (Malvín)', true, true, NOW(), NOW()),
  ('La Cigale (Av. Italia 5775)', 'Av. Italia 5775 (Portones Shopping)', true, true, NOW(), NOW()),
  ('La Cigale (Luis Alberto de Herrera 1290)', 'Av. Luis Alberto de Herrera 1290 (Montevideo Shopping)', true, true, NOW(), NOW()),
  ('La Cigale (Luis Alberto de Herrera 3365)', 'Av. Luis Alberto de Herrera 3365 (Nuevo Centro Shopping)', true, true, NOW(), NOW()),
  ('La Cigale (Atlántida)', 'Local en Atlántida (Canelones)', true, true, NOW(), NOW())
ON CONFLICT (name) DO UPDATE
SET
  location = EXCLUDED.location,
  controls_lot = EXCLUDED.controls_lot,
  is_store = true,
  updated_at = NOW();
