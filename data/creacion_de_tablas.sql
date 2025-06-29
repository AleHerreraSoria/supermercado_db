-- Script para crear el esquema de la base de datos 'supermercado_db'

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