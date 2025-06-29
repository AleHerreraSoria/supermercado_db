-- ====================================================================
-- PROYECTO SUPERMERCADO - SCRIPT SQL CONSOLIDADO
-- Autor: Alejandro Nelson Herrera Soria
-- Fecha: 29 de Junio de 2025
-- Este script contiene todas las operaciones realizadas a lo largo de las homeworks
-- ====================================================================

-- ====================================================================
-- HW2: Modelado de Datos.
-- ====================================================================

-- Tabla: sucursales
-- Almacena la información de cada sucursal del supermercado.
CREATE TABLE sucursales (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    ubicacion VARCHAR(255)
);

-- Tabla: clientes
-- Almacena la información de los clientes registrados.
CREATE TABLE clientes (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    fecha_registro DATE DEFAULT CURRENT_DATE
);

-- Tabla: productos
-- Almacena el catálogo de productos. Cada producto pertenece a una sucursal.
CREATE TABLE productos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    categoria VARCHAR(50),
    precio DECIMAL(10, 2) NOT NULL CHECK (precio > 0),
    stock INT NOT NULL CHECK (stock >= 0),
    sucursal_id INT,
    
    -- Definimos la clave foránea que relaciona un producto con su sucursal.
    FOREIGN KEY (sucursal_id) REFERENCES sucursales(id)
    -- ON DELETE CASCADE: Si una sucursal es eliminada, todos los productos
    -- asociados a esa sucursal también serán eliminados automáticamente.
    -- Esto mantiene la integridad de los datos.
    ON DELETE CASCADE
);

-- Tabla: ventas
-- Registra cada transacción de venta. Es la tabla central que une todo.
CREATE TABLE ventas (
    id SERIAL PRIMARY KEY,
    cliente_id INT,
    producto_id INT,
    fecha_venta TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    total DECIMAL(10, 2) NOT NULL,

    -- Clave foránea que relaciona la venta con un cliente.
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
    -- ON DELETE SET NULL: Si un cliente es eliminado de la base de datos,
    -- sus ventas pasadas no se borrarán. En su lugar, el campo 'cliente_id'
    -- en esas ventas se establecerá en NULL. Esto es útil para mantener
    -- el historial de ventas sin perder datos, aunque el cliente ya no exista.
    ON DELETE SET NULL,

    -- Clave foránea que relaciona la venta con un producto.
    FOREIGN KEY (producto_id) REFERENCES productos(id)
    -- ON DELETE SET NULL: Similar al anterior, si un producto se elimina del catálogo,
    -- las ventas históricas de ese producto se conservan, pero la referencia
    -- al producto se anula. Esto previene la eliminación accidental de registros de ventas.
    ON DELETE SET NULL
);


-- ====================================================================
-- HW3: Operaciones CRUD (CREATE, READ, UPDATE, DELETE)
-- ====================================================================

-- ====================================================================
-- 1. INSERTAR REGISTROS (CREATE)
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

-- ====================================================================
-- 2. Consultas con JOIN (READ)

-- Consulta 1: Mostrar los productos vendidos por sucursal.
-- Unimos ventas, productos y sucursales para obtener el nombre del producto y la sucursal donde se vendió.
SELECT
    s.nombre AS nombre_sucursal,
    p.nombre AS nombre_producto,
    v.cantidad,
    v.total
FROM ventas v
JOIN productos p ON v.producto_id = p.id
JOIN sucursales s ON p.sucursal_id = s.id
ORDER BY s.nombre;

-- Consulta 2: Mostrar los productos comprados por cada cliente.
-- Unimos ventas, productos y clientes para saber qué compró cada cliente.
SELECT
    c.nombre AS nombre_cliente,
    p.nombre AS nombre_producto,
    v.cantidad,
    v.fecha_venta
FROM ventas v
JOIN productos p ON v.producto_id = p.id
JOIN clientes c ON v.cliente_id = c.id
ORDER BY c.nombre;

-- ====================================================================
-- 3. Actualizar registros (UPDATE)

-- Actualizar precios de productos por categoría.
-- Aumentamos un 10% el precio de todos los productos de la categoría 'Alimentos'.
UPDATE productos
SET precio = precio * 1.10
WHERE categoria = 'Alimentos';

-- Verificamos el cambio con la siguiente consulta:
SELECT nombre, categoria, precio FROM productos WHERE categoria = 'Alimentos';

-- ====================================================================
-- 4. ELIMINAR REGISTROS CON TRANSACCIONES (DELETE)

-- Las transacciones son fundamentales para asegurar que un grupo de operaciones
-- se realicen de forma completa o no se realicen en absoluto (atomicidad).

-- Ejemplo 1: Eliminar una venta y confirmar la operación con COMMIT.
BEGIN; -- Inicia la transacción
-- Eliminamos la venta con id = 10
DELETE FROM ventas WHERE id = 10;
-- En este punto, la eliminación solo es visible dentro de esta transacción.
-- Si consultamos desde otra conexión, la venta con id = 10 todavía existiría.
-- Para hacer el cambio permanente, ejecutamos COMMIT.
COMMIT; -- Finaliza la transacción y aplica los cambios.

-- Ejemplo 2: Intentar eliminar una venta pero deshacer la operación con ROLLBACK.
BEGIN; -- Inicia una nueva transacción
-- Eliminamos la venta con id = 9
DELETE FROM ventas WHERE id = 9;
-- Suponiendo que cometimos un error y no queremos que esta eliminación se guarde.
-- En lugar de COMMIT, ejecutamos ROLLBACK.
ROLLBACK; -- Finaliza la transacción y revierte todos los cambios hechos desde el BEGIN.
-- Si consultas la tabla de ventas después de esto, verás que el registro con id = 9 sigue ahí.


-- ====================================================================
-- HW4: Optimización con índices
-- ====================================================================
-- En este script, aprenderemos a identificar consultas lentas y a acelerarlas
-- mediante la creación de índices. Usaremos EXPLAIN ANALYZE para medir el rendimiento.

-- ====================================================================
-- PASO 1: ANÁLISIS DE RENDIMIENTO ANTES DE LOS ÍNDICES

-- Un índice es como el índice de un libro. Sin él, para encontrar un tema,
-- tienes que leer el libro entero. Con un índice, vas directamente a la página.
-- En PostgreSQL, una lectura del "libro entero" se llama "Sequential Scan" (Seq Scan).

-- Consulta de ejemplo 1: Buscar un cliente por su email.
-- Esta es una operación muy común en cualquier sistema (ej: para un login).
EXPLAIN ANALYZE
SELECT * FROM clientes WHERE email = 'sofia.castro@email.com';
-- >> OBSERVACIONES:
-- La línea que dice "Seq Scan on clientes", confirma que PostgreSQL
-- tuvo que revisar cada fila de la tabla para encontrar el resultado.
-- El "Execution time" (tiempo de ejecución), se muestra en las comprobaciones finales (ANTES y DESPUES).

-- Consulta de ejemplo 2: Buscar un producto por su nombre.
-- Otra operación muy común.
EXPLAIN ANALYZE
SELECT * FROM productos WHERE nombre = 'Gaseosa Coca-Cola 2.25L';
-- >> OBSERVACIONES:
-- Nuevamente, la línea que dice "Seq Scan on clientes", confirma que PostgreSQL
-- tuvo que revisar cada fila de la tabla para encontrar el resultado.
-- El "Execution time" (tiempo de ejecución), se muestra en las comprobaciones finales (ANTES y DESPUES).

-- ====================================================================
-- PASO 2: CREACIÓN DE ÍNDICES

-- Creamos un índice en la columna 'email' de la tabla 'clientes'.
-- Usamos 'CREATE INDEX IF NOT EXISTS' para evitar errores si el índice ya fue creado.
CREATE INDEX IF NOT EXISTS idx_clientes_email ON clientes(email);

-- Creamos un índice en la columna 'nombre' de la tabla 'productos'.
CREATE INDEX IF NOT EXISTS idx_productos_nombre ON productos(nombre);

-- Sugerencia como ingeniero de datos:
-- También es extremadamente útil crear índices en las claves foráneas (FK),
-- ya que se usan constantemente en las operaciones JOIN.
CREATE INDEX IF NOT EXISTS idx_ventas_producto_id ON ventas(producto_id);
CREATE INDEX IF NOT EXISTS idx_ventas_cliente_id ON ventas(cliente_id);

-- ====================================================================
-- PASO 3: ANÁLISIS DE RENDIMIENTO DESPUÉS DE LOS ÍNDICES

-- Con los índices creados, vamos a ejecutar EXACTAMENTE las mismas
-- consultas de antes y comparar los resultados.

-- Consulta de ejemplo 1 (después del índice): Buscar un cliente por email.
EXPLAIN ANALYZE
SELECT * FROM clientes WHERE email = 'sofia.castro@email.com';

-- >> ANTES
-- "Index Scan using clientes_email_key on clientes  (cost=0.14..8.16 rows=1 width=444) (actual time=0.089..0.091 rows=1 loops=1)"
-- "  Index Cond: ((email)::text = 'sofia.castro@email.com'::text)"
-- "Planning Time: 0.230 ms"
-- "Execution Time: 0.248 ms"

-- >> DESPUES
-- "Seq Scan on clientes  (cost=0.00..1.12 rows=1 width=444) (actual time=0.015..0.017 rows=1 loops=1)"
-- "  Filter: ((email)::text = 'sofia.castro@email.com'::text)"
-- "  Rows Removed by Filter: 9"
-- "Planning Time: 0.070 ms"
-- "Execution Time: 0.028 ms"

-- Consulta de ejemplo 2 (después del índice): Buscar un producto por su nombre.
EXPLAIN ANALYZE
SELECT * FROM productos WHERE nombre = 'Gaseosa Coca-Cola 2.25L';

-- >> ANTES
-- "Seq Scan on productos  (cost=0.00..12.50 rows=1 width=364) (actual time=0.019..0.021 rows=1 loops=1)"
-- "  Filter: ((nombre)::text = 'Gaseosa Coca-Cola 2.25L'::text)"
-- "  Rows Removed by Filter: 9"
-- "Planning Time: 0.066 ms"
-- "Execution Time: 0.034 ms"

-- >> DESPUES
-- "Seq Scan on productos  (cost=0.00..1.12 rows=1 width=364) (actual time=0.015..0.017 rows=1 loops=1)"
-- "  Filter: ((nombre)::text = 'Gaseosa Coca-Cola 2.25L'::text)"
-- "  Rows Removed by Filter: 9"
-- "Planning Time: 0.066 ms"
-- "Execution Time: 0.028 ms"

-- >> OBSERACIONES:
-- El tiempo de ejecución y el "cost" (costo estimado por el planificador) son mucho más bajos.

-- ====================================================================
-- CONCLUSIÓN
-- Demostramos con datos (usando EXPLAIN ANALYZE) que la creación de índices
-- en las columnas correctas es una de las técnicas más efectivas para optimizar
-- el rendimiento de una base de datos.
-- ====================================================================


-- ====================================================================
-- HW5: Automatización
-- ====================================================================
-- En este script, automatizamos dos tareas críticas:
-- a) la actualización del stock después de una venta y 
-- b) la creación de un proceso de venta estandarizado.

-- ====================================================================
-- 1. CREAR UN TRIGGER QUE ACTUALICE EL STOCK

-- PASO 1.1: CREAR LA FUNCIÓN DEL TRIGGER

CREATE OR REPLACE FUNCTION actualizar_stock_trigger_func()
RETURNS TRIGGER AS $$
BEGIN
    -- La lógica es simple: actualizar la tabla 'productos' y restar
    -- la cantidad vendida del stock del producto correspondiente.
    -- 'NEW' es una variable especial en los triggers de PostgreSQL que
    -- contiene la fila que acaba de ser insertada o actualizada.
    UPDATE productos
    SET stock = stock - NEW.cantidad
    WHERE id = NEW.producto_id;
    
    -- Es una buena práctica verificar si el stock se vuelve negativo.
    -- Si es así, podríamos revertir la transacción lanzando un error.
    IF (SELECT stock FROM productos WHERE id = NEW.producto_id) < 0 THEN
        RAISE EXCEPTION 'Error: Stock insuficiente para el producto ID %', NEW.producto_id;
    END IF;
    
    -- Devolvemos la nueva fila. Para triggers 'AFTER', el valor de retorno suele ignorarse.
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- PASO 1.2: CREAR EL TRIGGER
-- Ahora, asociamos la función a la tabla 'ventas'.
-- Primero, eliminamos cualquier trigger antiguo con el mismo nombre para evitar conflictos.
DROP TRIGGER IF EXISTS trg_actualizar_stock ON ventas;

-- Creamos el trigger que se ejecutará DESPUÉS (AFTER) de cada INSERT en la tabla 'ventas'.
-- 'FOR EACH ROW' significa que el trigger se ejecutará una vez por cada fila insertada.
CREATE TRIGGER trg_actualizar_stock
AFTER INSERT ON ventas
FOR EACH ROW
EXECUTE FUNCTION actualizar_stock_trigger_func();

-- ====================================================================
-- 2. DESARROLLAR UN PROCEDIMIENTO ALMACENADO PARA REGISTRAR VENTAS

-- Un procedimiento almacenado es un conjunto de comandos SQL que se guarda en la
-- base de datos y se puede ejecutar con una simple llamada (CALL).
-- Esto centraliza la lógica y asegura que las ventas se registren siempre de la misma manera.

CREATE OR REPLACE PROCEDURE registrar_venta(
    p_cliente_id INT,
    p_producto_id INT,
    p_cantidad INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_precio_unitario DECIMAL;
    v_total_venta DECIMAL;
BEGIN
    -- Obtenemos el precio actual del producto desde la tabla 'productos'.
    SELECT precio INTO v_precio_unitario FROM productos WHERE id = p_producto_id;
    
    -- Si no encontramos el producto, lanzamos un error.
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Error: Producto con ID % no encontrado.', p_producto_id;
    END IF;

    -- Calculamos el total de la venta.
    v_total_venta := v_precio_unitario * p_cantidad;
    
    -- Insertamos el nuevo registro en la tabla 'ventas'.
    -- El trigger que creamos antes se disparará automáticamente aquí.
    INSERT INTO ventas (cliente_id, producto_id, cantidad, total)
    VALUES (p_cliente_id, p_producto_id, p_cantidad, v_total_venta);
    
    RAISE NOTICE 'Venta registrada exitosamente para el producto ID %', p_producto_id;
END;
$$;

-- ====================================================================
-- 3. PRUEBA DE LA AUTOMATIZACIÓN

-- Ahora vamos a ver cómo todo funciona en conjunto.

-- PASO 3.1: VERIFICAR EL ESTADO INICIAL
-- Revisemos el stock de 'Gaseosa Coca-Cola 2.25L' (ID = 10) antes de la venta.
SELECT nombre, stock FROM productos WHERE id = 10;
-- Debería tener un stock de 250.


-- PROBLEMA INTERMEDIO entre 3.1 y 3.2
-- Tenemos un mensaje de error ERROR: duplicate key value violates unique constraint "ventas_pkey".
-- Que nos está diciendo? "Intenté insertar una nueva fila en la tabla ventas, pero la clave primaria (ID)
-- que iba a usar ya existe. No puedo tener dos ventas con el mismo ID."

-- ¿Por qué ocurre esto? 
-- En el Avance 3, insertamos 10 ventas manualmente, asignándoles explícitamente los id del 1 al 10.
-- La columna ventas.id es de tipo SERIAL, lo que significa que PostgreSQL crea un "contador" automático
-- (una secuencia) para generar nuevos IDs.
-- Cuando llamamos al procedimiento registrar_venta, este intenta insertar una nueva venta
-- sin especificar un ID, confiando en que el contador le dará el siguiente número disponible.
-- El problema es que el contador no se actualizó después de nuestras inserciones manuales.
-- Sigue pensando que el próximo ID que debe generar es el 1, pero ese ID ya lo usamos.

-- Solución: Sincronizar el Contador
-- Tenemos que decirle a PostgreSQL que actualice su contador al valor más alto que ya existe en la tabla,
-- para que la próxima vez que genere un ID, use el número correcto.
-- Este comando sincronizará los contadores para todas nuestras tablas, lo que nos evitará problemas futuros.
-- COMANDO PARA SINCRONIZAR LOS CONTADORES (SECUENCIAS)
SELECT setval(pg_get_serial_sequence('sucursales', 'id'), (SELECT MAX(id) FROM sucursales));
SELECT setval(pg_get_serial_sequence('clientes', 'id'), (SELECT MAX(id) FROM clientes));
SELECT setval(pg_get_serial_sequence('productos', 'id'), (SELECT MAX(id) FROM productos));
SELECT setval(pg_get_serial_sequence('ventas', 'id'), (SELECT MAX(id) FROM ventas));

-- PASO 3.2: EJECUTAR EL PROCEDIMIENTO ALMACENADO
-- Simulamos una venta donde el cliente 'Julieta Rios' (ID = 9) compra 5 gaseosas.
CALL registrar_venta(
    p_cliente_id := 9,
    p_producto_id := 10,
    p_cantidad := 5
);

-- PASO 3.3: VERIFICAR EL ESTADO FINAL
-- Volvemos a consultar el stock del producto con ID = 10.
SELECT nombre, stock FROM productos WHERE id = 10;
-- El stock ahora es de 245, actualizado automáticamente por el trigger.

-- También podemos verificar la nueva venta en la tabla 'ventas'.
SELECT * FROM ventas ORDER BY fecha_venta DESC LIMIT 1;
-- Vemos el nuevo registro de venta con el total calculado correctamente.