--
-- PostgreSQL database dump
--

-- Dumped from database version 15.13
-- Dumped by pg_dump version 15.13

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: actualizar_stock_trigger_func(); Type: FUNCTION; Schema: public; Owner: admin
--

CREATE FUNCTION public.actualizar_stock_trigger_func() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- La l├│gica es simple: actualizar la tabla 'productos' y restar
    -- la cantidad vendida del stock del producto correspondiente.
    
    -- 'NEW' es una variable especial en los triggers de PostgreSQL que
    -- contiene la fila que acaba de ser insertada o actualizada.
    UPDATE productos
    SET stock = stock - NEW.cantidad
    WHERE id = NEW.producto_id;
    
    -- Es una buena pr├íctica verificar si el stock se vuelve negativo.
    -- Si es as├¡, podr├¡amos revertir la transacci├│n lanzando un error.
    IF (SELECT stock FROM productos WHERE id = NEW.producto_id) < 0 THEN
        RAISE EXCEPTION 'Error: Stock insuficiente para el producto ID %', NEW.producto_id;
    END IF;
    
    -- Devolvemos la nueva fila. Para triggers 'AFTER', el valor de retorno suele ignorarse.
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.actualizar_stock_trigger_func() OWNER TO admin;

--
-- Name: registrar_venta(integer, integer, integer); Type: PROCEDURE; Schema: public; Owner: admin
--

CREATE PROCEDURE public.registrar_venta(IN p_cliente_id integer, IN p_producto_id integer, IN p_cantidad integer)
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
    -- El trigger que creamos antes se disparar├í autom├íticamente aqu├¡.
    INSERT INTO ventas (cliente_id, producto_id, cantidad, total)
    VALUES (p_cliente_id, p_producto_id, p_cantidad, v_total_venta);
    
    RAISE NOTICE 'Venta registrada exitosamente para el producto ID %', p_producto_id;
END;
$$;


ALTER PROCEDURE public.registrar_venta(IN p_cliente_id integer, IN p_producto_id integer, IN p_cantidad integer) OWNER TO admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: clientes; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.clientes (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    email character varying(100),
    fecha_registro date DEFAULT CURRENT_DATE
);


ALTER TABLE public.clientes OWNER TO admin;

--
-- Name: clientes_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.clientes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.clientes_id_seq OWNER TO admin;

--
-- Name: clientes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.clientes_id_seq OWNED BY public.clientes.id;


--
-- Name: productos; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.productos (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    categoria character varying(50),
    precio numeric(10,2) NOT NULL,
    stock integer NOT NULL,
    sucursal_id integer,
    CONSTRAINT productos_precio_check CHECK ((precio > (0)::numeric)),
    CONSTRAINT productos_stock_check CHECK ((stock >= 0))
);


ALTER TABLE public.productos OWNER TO admin;

--
-- Name: productos_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.productos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.productos_id_seq OWNER TO admin;

--
-- Name: productos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.productos_id_seq OWNED BY public.productos.id;


--
-- Name: sucursales; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.sucursales (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    ubicacion character varying(255)
);


ALTER TABLE public.sucursales OWNER TO admin;

--
-- Name: sucursales_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.sucursales_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sucursales_id_seq OWNER TO admin;

--
-- Name: sucursales_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.sucursales_id_seq OWNED BY public.sucursales.id;


--
-- Name: ventas; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.ventas (
    id integer NOT NULL,
    cliente_id integer,
    producto_id integer,
    fecha_venta timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    cantidad integer NOT NULL,
    total numeric(10,2) NOT NULL,
    CONSTRAINT ventas_cantidad_check CHECK ((cantidad > 0))
);


ALTER TABLE public.ventas OWNER TO admin;

--
-- Name: ventas_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.ventas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ventas_id_seq OWNER TO admin;

--
-- Name: ventas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.ventas_id_seq OWNED BY public.ventas.id;


--
-- Name: clientes id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.clientes ALTER COLUMN id SET DEFAULT nextval('public.clientes_id_seq'::regclass);


--
-- Name: productos id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.productos ALTER COLUMN id SET DEFAULT nextval('public.productos_id_seq'::regclass);


--
-- Name: sucursales id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.sucursales ALTER COLUMN id SET DEFAULT nextval('public.sucursales_id_seq'::regclass);


--
-- Name: ventas id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.ventas ALTER COLUMN id SET DEFAULT nextval('public.ventas_id_seq'::regclass);


--
-- Name: clientes clientes_email_key; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_email_key UNIQUE (email);


--
-- Name: clientes clientes_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_pkey PRIMARY KEY (id);


--
-- Name: productos productos_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.productos
    ADD CONSTRAINT productos_pkey PRIMARY KEY (id);


--
-- Name: sucursales sucursales_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.sucursales
    ADD CONSTRAINT sucursales_pkey PRIMARY KEY (id);


--
-- Name: ventas ventas_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.ventas
    ADD CONSTRAINT ventas_pkey PRIMARY KEY (id);


--
-- Name: idx_clientes_email; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_clientes_email ON public.clientes USING btree (email);


--
-- Name: idx_productos_nombre; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_productos_nombre ON public.productos USING btree (nombre);


--
-- Name: idx_ventas_cliente_id; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_ventas_cliente_id ON public.ventas USING btree (cliente_id);


--
-- Name: idx_ventas_producto_id; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_ventas_producto_id ON public.ventas USING btree (producto_id);


--
-- Name: ventas trg_actualizar_stock; Type: TRIGGER; Schema: public; Owner: admin
--

CREATE TRIGGER trg_actualizar_stock AFTER INSERT ON public.ventas FOR EACH ROW EXECUTE FUNCTION public.actualizar_stock_trigger_func();


--
-- Name: productos productos_sucursal_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.productos
    ADD CONSTRAINT productos_sucursal_id_fkey FOREIGN KEY (sucursal_id) REFERENCES public.sucursales(id) ON DELETE CASCADE;


--
-- Name: ventas ventas_cliente_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.ventas
    ADD CONSTRAINT ventas_cliente_id_fkey FOREIGN KEY (cliente_id) REFERENCES public.clientes(id) ON DELETE SET NULL;


--
-- Name: ventas ventas_producto_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.ventas
    ADD CONSTRAINT ventas_producto_id_fkey FOREIGN KEY (producto_id) REFERENCES public.productos(id) ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

