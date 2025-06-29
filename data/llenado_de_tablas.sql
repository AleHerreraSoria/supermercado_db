-- ====================================================================
-- 1. INSERTAR REGISTROS (CREATE)
-- ====================================================================
-- Insertamos 10 registros en cada tabla para tener datos con los que trabajar.

-- Insertar en 'sucursales'
-- Usamos los ejemplos y añadimos más para llegar a 10.
INSERT INTO sucursales (id, nombre, ubicacion) VALUES
(1, 'Sucursal Central', 'Av. Siempreviva 123, Capital'),
(2, 'Sucursal Norte', 'Calle Falsa 456, Capital'),
(3, 'Sucursal Sur', 'Boulevard Mitre 789, Capital'),
(4, 'Sucursal Oeste', 'Ruta 38, Km 5'),
(5, 'Sucursal Este', 'Av. Angelelli 210'),
(6, 'Sucursal Chilecito', 'Joaquín V. González 150, Chilecito'),
(7, 'Sucursal Aimogasta', 'Castro Barros 300, Aimogasta'),
(8, 'Sucursal Céntrica 2', 'Peatonal 9 de Julio 550, Capital'),
(9, 'Punto de Entrega Online', 'Depósito Central, Parque Industrial'),
(10, 'Sucursal Chamical', 'Av. Perón 120, Chamical')
ON CONFLICT (id) DO NOTHING; -- Evita errores si los IDs ya existen

-- Insertar en 'clientes'
INSERT INTO clientes (id, nombre, email) VALUES
(1, 'Ana Torres', 'ana.torres@email.com'),
(2, 'Carlos Ruiz', 'carlos.ruiz@email.com'),
(3, 'Luisa Paz', 'luisa.paz@email.com'),
(4, 'Marcos Vega', 'marcos.vega@email.com'),
(5, 'Sofia Castro', 'sofia.castro@email.com'),
(6, 'Javier Soto', 'javier.soto@email.com'),
(7, 'Valentina Luna', 'valentina.luna@email.com'),
(8, 'Mateo Campos', 'mateo.campos@email.com'),
(9, 'Julieta Rios', 'julieta.rios@email.com'),
(10, 'Diego Ponce', 'diego.ponce@email.com')
ON CONFLICT (id) DO NOTHING; -- Evita errores si los IDs ya existen

-- Insertar en 'productos'
-- Usamos los ejemplos y expandimos la lista.
INSERT INTO productos (id, nombre, categoria, precio, stock, sucursal_id) VALUES
(1, 'Yerba Mate CBSé', 'Alimentos', 850.00, 200, 1),
(2, 'Lavandina Ayudín', 'Limpieza', 350.50, 100, 2),
(3, 'Aceite de Girasol Cocinero', 'Alimentos', 1200.00, 150, 1),
(4, 'Shampoo Head & Shoulders', 'Higiene', 950.75, 80, 3),
(5, 'Galletitas Oreo', 'Alimentos', 550.00, 300, 1),
(6, 'Jabón en Polvo Ala', 'Limpieza', 1500.00, 90, 2),
(7, 'Desodorante Axe', 'Higiene', 780.25, 120, 3),
(8, 'Queso Cremoso La Serenísima', 'Lácteos', 2100.00, 50, 4),
(9, 'Pan Lactal Bimbo', 'Panadería', 650.00, 70, 4),
(10, 'Gaseosa Coca-Cola 2.25L', 'Bebidas', 1100.00, 250, 1)
ON CONFLICT (id) DO NOTHING; -- Evita errores si los IDs ya existen

-- Insertar en 'ventas'
-- Simulamos algunas ventas de los productos y clientes anteriores.
INSERT INTO ventas (id, cliente_id, producto_id, cantidad, total) VALUES
(1, 1, 1, 2, 1700.00),   -- Ana Torres compra 2 Yerba Mate
(2, 2, 5, 3, 1650.00),   -- Carlos Ruiz compra 3 Galletitas Oreo
(3, 1, 3, 1, 1200.00),   -- Ana Torres compra 1 Aceite
(4, 3, 2, 1, 350.50),    -- Luisa Paz compra 1 Lavandina
(5, 4, 10, 4, 4400.00),  -- Marcos Vega compra 4 Gaseosas
(6, 5, 8, 1, 2100.00),   -- Sofia Castro compra 1 Queso
(7, 6, 9, 2, 1300.00),   -- Javier Soto compra 2 Pan Lactal
(8, 7, 4, 1, 950.75),    -- Valentina Luna compra 1 Shampoo
(9, 8, 6, 1, 1500.00),   -- Mateo Campos compra 1 Jabón en Polvo
(10, 2, 7, 2, 1560.50)   -- Carlos Ruiz compra 2 Desodorantes
ON CONFLICT (id) DO NOTHING; -- Evita errores si los IDs ya existen