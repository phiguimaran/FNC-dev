--
-- PostgreSQL database dump
--

\restrict npeKBywRbtK8GLcOF6jbR7xXhgS5gg8qDEqiHbINudjqHB5XNgaBfrOOrkvNqMd

-- Dumped from database version 16.11 (Ubuntu 16.11-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 16.11 (Ubuntu 16.11-0ubuntu0.24.04.1)

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
-- Name: mermaaction; Type: TYPE; Schema: public; Owner: fnc
--

CREATE TYPE public.mermaaction AS ENUM (
    'discarded',
    'reprocessed',
    'admin_adjustment',
    'none'
);


ALTER TYPE public.mermaaction OWNER TO fnc;

--
-- Name: mermastage; Type: TYPE; Schema: public; Owner: fnc
--

CREATE TYPE public.mermastage AS ENUM (
    'production',
    'empaque',
    'stock',
    'transito_post_remito',
    'administrativa'
);


ALTER TYPE public.mermastage OWNER TO fnc;

--
-- Name: movementtype; Type: TYPE; Schema: public; Owner: fnc
--

CREATE TYPE public.movementtype AS ENUM (
    'production',
    'consumption',
    'adjustment',
    'transfer',
    'remito',
    'merma'
);


ALTER TYPE public.movementtype OWNER TO fnc;

--
-- Name: orderstatus; Type: TYPE; Schema: public; Owner: fnc
--

CREATE TYPE public.orderstatus AS ENUM (
    'draft',
    'submitted',
    'approved',
    'prepared',
    'closed'
);


ALTER TYPE public.orderstatus OWNER TO fnc;

--
-- Name: remitostatus; Type: TYPE; Schema: public; Owner: fnc
--

CREATE TYPE public.remitostatus AS ENUM (
    'pending',
    'sent',
    'delivered'
);


ALTER TYPE public.remitostatus OWNER TO fnc;

--
-- Name: skufamily; Type: TYPE; Schema: public; Owner: fnc
--

CREATE TYPE public.skufamily AS ENUM (
    'consumible',
    'papeleria',
    'limpieza'
);


ALTER TYPE public.skufamily OWNER TO fnc;

--
-- Name: skutag; Type: TYPE; Schema: public; Owner: fnc
--

CREATE TYPE public.skutag AS ENUM (
    'PT',
    'SEMI',
    'MP',
    'CON',
    'PAP',
    'LIM',
    'PACK',
    'OTRO'
);


ALTER TYPE public.skutag OWNER TO fnc;

--
-- Name: unitofmeasure; Type: TYPE; Schema: public; Owner: fnc
--

CREATE TYPE public.unitofmeasure AS ENUM (
    'UNIT',
    'KG',
    'G',
    'L',
    'ML',
    'PACK',
    'BOX',
    'M',
    'CM'
);


ALTER TYPE public.unitofmeasure OWNER TO fnc;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: fnc
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO fnc;

--
-- Name: deposits; Type: TABLE; Schema: public; Owner: fnc
--

CREATE TABLE public.deposits (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    location character varying(255),
    controls_lot boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    is_store boolean DEFAULT false NOT NULL
);


ALTER TABLE public.deposits OWNER TO fnc;

--
-- Name: deposits_id_seq; Type: SEQUENCE; Schema: public; Owner: fnc
--

CREATE SEQUENCE public.deposits_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.deposits_id_seq OWNER TO fnc;

--
-- Name: deposits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fnc
--

ALTER SEQUENCE public.deposits_id_seq OWNED BY public.deposits.id;


--
-- Name: merma_causes; Type: TABLE; Schema: public; Owner: fnc
--

CREATE TABLE public.merma_causes (
    id integer NOT NULL,
    stage public.mermastage NOT NULL,
    code character varying(64) NOT NULL,
    label character varying(255) NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.merma_causes OWNER TO fnc;

--
-- Name: merma_causes_id_seq; Type: SEQUENCE; Schema: public; Owner: fnc
--

CREATE SEQUENCE public.merma_causes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.merma_causes_id_seq OWNER TO fnc;

--
-- Name: merma_causes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fnc
--

ALTER SEQUENCE public.merma_causes_id_seq OWNED BY public.merma_causes.id;


--
-- Name: merma_events; Type: TABLE; Schema: public; Owner: fnc
--

CREATE TABLE public.merma_events (
    id integer NOT NULL,
    stage public.mermastage NOT NULL,
    type_id integer NOT NULL,
    type_code character varying(64) NOT NULL,
    type_label character varying(255) NOT NULL,
    cause_id integer NOT NULL,
    cause_code character varying(64) NOT NULL,
    cause_label character varying(255) NOT NULL,
    sku_id integer NOT NULL,
    quantity double precision NOT NULL,
    unit character varying(255) NOT NULL,
    lot_code character varying(64),
    deposit_id integer,
    remito_id integer,
    order_id integer,
    production_line_id integer,
    reported_by_user_id integer,
    reported_by_role character varying(100),
    notes character varying(500),
    detected_at timestamp without time zone NOT NULL,
    affects_stock boolean DEFAULT true NOT NULL,
    action public.mermaaction DEFAULT 'none'::public.mermaaction NOT NULL,
    stock_movement_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    remito_item_id integer
);


ALTER TABLE public.merma_events OWNER TO fnc;

--
-- Name: merma_events_id_seq; Type: SEQUENCE; Schema: public; Owner: fnc
--

CREATE SEQUENCE public.merma_events_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.merma_events_id_seq OWNER TO fnc;

--
-- Name: merma_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fnc
--

ALTER SEQUENCE public.merma_events_id_seq OWNED BY public.merma_events.id;


--
-- Name: merma_types; Type: TABLE; Schema: public; Owner: fnc
--

CREATE TABLE public.merma_types (
    id integer NOT NULL,
    stage public.mermastage NOT NULL,
    code character varying(64) NOT NULL,
    label character varying(255) NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.merma_types OWNER TO fnc;

--
-- Name: merma_types_id_seq; Type: SEQUENCE; Schema: public; Owner: fnc
--

CREATE SEQUENCE public.merma_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.merma_types_id_seq OWNER TO fnc;

--
-- Name: merma_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fnc
--

ALTER SEQUENCE public.merma_types_id_seq OWNED BY public.merma_types.id;


--
-- Name: order_items; Type: TABLE; Schema: public; Owner: fnc
--

CREATE TABLE public.order_items (
    id integer NOT NULL,
    order_id integer NOT NULL,
    sku_id integer NOT NULL,
    quantity double precision NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    current_stock double precision
);


ALTER TABLE public.order_items OWNER TO fnc;

--
-- Name: order_items_id_seq; Type: SEQUENCE; Schema: public; Owner: fnc
--

CREATE SEQUENCE public.order_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_items_id_seq OWNER TO fnc;

--
-- Name: order_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fnc
--

ALTER SEQUENCE public.order_items_id_seq OWNED BY public.order_items.id;


--
-- Name: orders; Type: TABLE; Schema: public; Owner: fnc
--

CREATE TABLE public.orders (
    id integer NOT NULL,
    destination character varying(255) NOT NULL,
    status public.orderstatus DEFAULT 'draft'::public.orderstatus NOT NULL,
    requested_for date,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    notes character varying(255),
    destination_deposit_id integer
);


ALTER TABLE public.orders OWNER TO fnc;

--
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: fnc
--

CREATE SEQUENCE public.orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.orders_id_seq OWNER TO fnc;

--
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fnc
--

ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;


--
-- Name: production_lines; Type: TABLE; Schema: public; Owner: fnc
--

CREATE TABLE public.production_lines (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.production_lines OWNER TO fnc;

--
-- Name: production_lines_id_seq; Type: SEQUENCE; Schema: public; Owner: fnc
--

CREATE SEQUENCE public.production_lines_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.production_lines_id_seq OWNER TO fnc;

--
-- Name: production_lines_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fnc
--

ALTER SEQUENCE public.production_lines_id_seq OWNED BY public.production_lines.id;


--
-- Name: production_lots; Type: TABLE; Schema: public; Owner: fnc
--

CREATE TABLE public.production_lots (
    id integer NOT NULL,
    lot_code character varying(64) NOT NULL,
    sku_id integer NOT NULL,
    deposit_id integer NOT NULL,
    production_line_id integer,
    produced_quantity numeric(14,4) NOT NULL,
    remaining_quantity numeric(14,4) NOT NULL,
    produced_at date DEFAULT CURRENT_DATE NOT NULL,
    is_blocked boolean DEFAULT false NOT NULL,
    notes character varying(255),
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.production_lots OWNER TO fnc;

--
-- Name: production_lots_id_seq; Type: SEQUENCE; Schema: public; Owner: fnc
--

CREATE SEQUENCE public.production_lots_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.production_lots_id_seq OWNER TO fnc;

--
-- Name: production_lots_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fnc
--

ALTER SEQUENCE public.production_lots_id_seq OWNED BY public.production_lots.id;


--
-- Name: recipe_items; Type: TABLE; Schema: public; Owner: fnc
--

CREATE TABLE public.recipe_items (
    id integer NOT NULL,
    recipe_id integer NOT NULL,
    component_id integer NOT NULL,
    quantity double precision NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.recipe_items OWNER TO fnc;

--
-- Name: recipe_items_id_seq; Type: SEQUENCE; Schema: public; Owner: fnc
--

CREATE SEQUENCE public.recipe_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.recipe_items_id_seq OWNER TO fnc;

--
-- Name: recipe_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fnc
--

ALTER SEQUENCE public.recipe_items_id_seq OWNED BY public.recipe_items.id;


--
-- Name: recipes; Type: TABLE; Schema: public; Owner: fnc
--

CREATE TABLE public.recipes (
    id integer NOT NULL,
    product_id integer NOT NULL,
    name character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.recipes OWNER TO fnc;

--
-- Name: recipes_id_seq; Type: SEQUENCE; Schema: public; Owner: fnc
--

CREATE SEQUENCE public.recipes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.recipes_id_seq OWNER TO fnc;

--
-- Name: recipes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fnc
--

ALTER SEQUENCE public.recipes_id_seq OWNED BY public.recipes.id;


--
-- Name: remito_items; Type: TABLE; Schema: public; Owner: fnc
--

CREATE TABLE public.remito_items (
    id integer NOT NULL,
    remito_id integer NOT NULL,
    sku_id integer NOT NULL,
    quantity double precision NOT NULL,
    lot_code character varying(64),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.remito_items OWNER TO fnc;

--
-- Name: remito_items_id_seq; Type: SEQUENCE; Schema: public; Owner: fnc
--

CREATE SEQUENCE public.remito_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.remito_items_id_seq OWNER TO fnc;

--
-- Name: remito_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fnc
--

ALTER SEQUENCE public.remito_items_id_seq OWNED BY public.remito_items.id;


--
-- Name: remitos; Type: TABLE; Schema: public; Owner: fnc
--

CREATE TABLE public.remitos (
    id integer NOT NULL,
    order_id integer NOT NULL,
    status public.remitostatus DEFAULT 'pending'::public.remitostatus NOT NULL,
    destination character varying(255) NOT NULL,
    issue_date date NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    source_deposit_id integer,
    destination_deposit_id integer,
    dispatched_at timestamp without time zone,
    received_at timestamp without time zone,
    cancelled_at timestamp without time zone
);


ALTER TABLE public.remitos OWNER TO fnc;

--
-- Name: remitos_id_seq; Type: SEQUENCE; Schema: public; Owner: fnc
--

CREATE SEQUENCE public.remitos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.remitos_id_seq OWNER TO fnc;

--
-- Name: remitos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fnc
--

ALTER SEQUENCE public.remitos_id_seq OWNED BY public.remitos.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: fnc
--

CREATE TABLE public.roles (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    description character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.roles OWNER TO fnc;

--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: fnc
--

CREATE SEQUENCE public.roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.roles_id_seq OWNER TO fnc;

--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fnc
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- Name: semi_conversion_rules; Type: TABLE; Schema: public; Owner: fnc
--

CREATE TABLE public.semi_conversion_rules (
    id integer NOT NULL,
    sku_id integer NOT NULL,
    units_per_kg numeric(12,4) DEFAULT '1'::numeric NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.semi_conversion_rules OWNER TO fnc;

--
-- Name: semi_conversion_rules_id_seq; Type: SEQUENCE; Schema: public; Owner: fnc
--

CREATE SEQUENCE public.semi_conversion_rules_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.semi_conversion_rules_id_seq OWNER TO fnc;

--
-- Name: semi_conversion_rules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fnc
--

ALTER SEQUENCE public.semi_conversion_rules_id_seq OWNED BY public.semi_conversion_rules.id;


--
-- Name: sku_types; Type: TABLE; Schema: public; Owner: fnc
--

CREATE TABLE public.sku_types (
    id integer NOT NULL,
    code character varying(16) NOT NULL,
    label character varying(255) NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.sku_types OWNER TO fnc;

--
-- Name: sku_types_id_seq; Type: SEQUENCE; Schema: public; Owner: fnc
--

CREATE SEQUENCE public.sku_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sku_types_id_seq OWNER TO fnc;

--
-- Name: sku_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fnc
--

ALTER SEQUENCE public.sku_types_id_seq OWNED BY public.sku_types.id;


--
-- Name: skus; Type: TABLE; Schema: public; Owner: fnc
--

CREATE TABLE public.skus (
    id integer NOT NULL,
    code character varying(64) NOT NULL,
    name character varying(255) NOT NULL,
    tag public.skutag NOT NULL,
    unit character varying(255) DEFAULT 'unit'::character varying NOT NULL,
    notes character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    family public.skufamily,
    is_active boolean DEFAULT true NOT NULL,
    sku_type_id integer
);


ALTER TABLE public.skus OWNER TO fnc;

--
-- Name: skus_id_seq; Type: SEQUENCE; Schema: public; Owner: fnc
--

CREATE SEQUENCE public.skus_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.skus_id_seq OWNER TO fnc;

--
-- Name: skus_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fnc
--

ALTER SEQUENCE public.skus_id_seq OWNED BY public.skus.id;


--
-- Name: stock_levels; Type: TABLE; Schema: public; Owner: fnc
--

CREATE TABLE public.stock_levels (
    id integer NOT NULL,
    sku_id integer NOT NULL,
    deposit_id integer NOT NULL,
    quantity double precision DEFAULT '0'::double precision NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.stock_levels OWNER TO fnc;

--
-- Name: stock_levels_id_seq; Type: SEQUENCE; Schema: public; Owner: fnc
--

CREATE SEQUENCE public.stock_levels_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.stock_levels_id_seq OWNER TO fnc;

--
-- Name: stock_levels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fnc
--

ALTER SEQUENCE public.stock_levels_id_seq OWNED BY public.stock_levels.id;


--
-- Name: stock_movement_types; Type: TABLE; Schema: public; Owner: fnc
--

CREATE TABLE public.stock_movement_types (
    id integer NOT NULL,
    code character varying(50) NOT NULL,
    label character varying(255) NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.stock_movement_types OWNER TO fnc;

--
-- Name: stock_movement_types_id_seq; Type: SEQUENCE; Schema: public; Owner: fnc
--

CREATE SEQUENCE public.stock_movement_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.stock_movement_types_id_seq OWNER TO fnc;

--
-- Name: stock_movement_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fnc
--

ALTER SEQUENCE public.stock_movement_types_id_seq OWNED BY public.stock_movement_types.id;


--
-- Name: stock_movements; Type: TABLE; Schema: public; Owner: fnc
--

CREATE TABLE public.stock_movements (
    id integer NOT NULL,
    sku_id integer NOT NULL,
    deposit_id integer NOT NULL,
    movement_type public.movementtype NOT NULL,
    quantity double precision NOT NULL,
    reference character varying(100),
    lot_code character varying(64),
    movement_date date NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    reference_type character varying(50),
    reference_id integer,
    reference_item_id integer,
    production_lot_id integer
);


ALTER TABLE public.stock_movements OWNER TO fnc;

--
-- Name: stock_movements_id_seq; Type: SEQUENCE; Schema: public; Owner: fnc
--

CREATE SEQUENCE public.stock_movements_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.stock_movements_id_seq OWNER TO fnc;

--
-- Name: stock_movements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fnc
--

ALTER SEQUENCE public.stock_movements_id_seq OWNED BY public.stock_movements.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: fnc
--

CREATE TABLE public.users (
    id integer NOT NULL,
    email character varying(255) NOT NULL,
    full_name character varying(255) NOT NULL,
    hashed_password character varying(255) NOT NULL,
    is_active boolean NOT NULL,
    role_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.users OWNER TO fnc;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: fnc
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO fnc;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fnc
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: deposits id; Type: DEFAULT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.deposits ALTER COLUMN id SET DEFAULT nextval('public.deposits_id_seq'::regclass);


--
-- Name: merma_causes id; Type: DEFAULT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.merma_causes ALTER COLUMN id SET DEFAULT nextval('public.merma_causes_id_seq'::regclass);


--
-- Name: merma_events id; Type: DEFAULT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.merma_events ALTER COLUMN id SET DEFAULT nextval('public.merma_events_id_seq'::regclass);


--
-- Name: merma_types id; Type: DEFAULT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.merma_types ALTER COLUMN id SET DEFAULT nextval('public.merma_types_id_seq'::regclass);


--
-- Name: order_items id; Type: DEFAULT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.order_items ALTER COLUMN id SET DEFAULT nextval('public.order_items_id_seq'::regclass);


--
-- Name: orders id; Type: DEFAULT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);


--
-- Name: production_lines id; Type: DEFAULT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.production_lines ALTER COLUMN id SET DEFAULT nextval('public.production_lines_id_seq'::regclass);


--
-- Name: production_lots id; Type: DEFAULT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.production_lots ALTER COLUMN id SET DEFAULT nextval('public.production_lots_id_seq'::regclass);


--
-- Name: recipe_items id; Type: DEFAULT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.recipe_items ALTER COLUMN id SET DEFAULT nextval('public.recipe_items_id_seq'::regclass);


--
-- Name: recipes id; Type: DEFAULT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.recipes ALTER COLUMN id SET DEFAULT nextval('public.recipes_id_seq'::regclass);


--
-- Name: remito_items id; Type: DEFAULT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.remito_items ALTER COLUMN id SET DEFAULT nextval('public.remito_items_id_seq'::regclass);


--
-- Name: remitos id; Type: DEFAULT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.remitos ALTER COLUMN id SET DEFAULT nextval('public.remitos_id_seq'::regclass);


--
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- Name: semi_conversion_rules id; Type: DEFAULT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.semi_conversion_rules ALTER COLUMN id SET DEFAULT nextval('public.semi_conversion_rules_id_seq'::regclass);


--
-- Name: sku_types id; Type: DEFAULT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.sku_types ALTER COLUMN id SET DEFAULT nextval('public.sku_types_id_seq'::regclass);


--
-- Name: skus id; Type: DEFAULT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.skus ALTER COLUMN id SET DEFAULT nextval('public.skus_id_seq'::regclass);


--
-- Name: stock_levels id; Type: DEFAULT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.stock_levels ALTER COLUMN id SET DEFAULT nextval('public.stock_levels_id_seq'::regclass);


--
-- Name: stock_movement_types id; Type: DEFAULT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.stock_movement_types ALTER COLUMN id SET DEFAULT nextval('public.stock_movement_types_id_seq'::regclass);


--
-- Name: stock_movements id; Type: DEFAULT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.stock_movements ALTER COLUMN id SET DEFAULT nextval('public.stock_movements_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- Name: deposits deposits_name_key; Type: CONSTRAINT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.deposits
    ADD CONSTRAINT deposits_name_key UNIQUE (name);


--
-- Name: deposits deposits_pkey; Type: CONSTRAINT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.deposits
    ADD CONSTRAINT deposits_pkey PRIMARY KEY (id);


--
-- Name: merma_causes merma_causes_pkey; Type: CONSTRAINT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.merma_causes
    ADD CONSTRAINT merma_causes_pkey PRIMARY KEY (id);


--
-- Name: merma_events merma_events_pkey; Type: CONSTRAINT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.merma_events
    ADD CONSTRAINT merma_events_pkey PRIMARY KEY (id);


--
-- Name: merma_types merma_types_pkey; Type: CONSTRAINT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.merma_types
    ADD CONSTRAINT merma_types_pkey PRIMARY KEY (id);


--
-- Name: order_items order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: production_lines production_lines_name_key; Type: CONSTRAINT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.production_lines
    ADD CONSTRAINT production_lines_name_key UNIQUE (name);


--
-- Name: production_lines production_lines_pkey; Type: CONSTRAINT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.production_lines
    ADD CONSTRAINT production_lines_pkey PRIMARY KEY (id);


--
-- Name: production_lots production_lots_lot_code_key; Type: CONSTRAINT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.production_lots
    ADD CONSTRAINT production_lots_lot_code_key UNIQUE (lot_code);


--
-- Name: production_lots production_lots_pkey; Type: CONSTRAINT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.production_lots
    ADD CONSTRAINT production_lots_pkey PRIMARY KEY (id);


--
-- Name: recipe_items recipe_items_pkey; Type: CONSTRAINT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.recipe_items
    ADD CONSTRAINT recipe_items_pkey PRIMARY KEY (id);


--
-- Name: recipes recipes_pkey; Type: CONSTRAINT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.recipes
    ADD CONSTRAINT recipes_pkey PRIMARY KEY (id);


--
-- Name: remito_items remito_items_pkey; Type: CONSTRAINT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.remito_items
    ADD CONSTRAINT remito_items_pkey PRIMARY KEY (id);


--
-- Name: remitos remitos_pkey; Type: CONSTRAINT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.remitos
    ADD CONSTRAINT remitos_pkey PRIMARY KEY (id);


--
-- Name: roles roles_name_key; Type: CONSTRAINT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_name_key UNIQUE (name);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: semi_conversion_rules semi_conversion_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.semi_conversion_rules
    ADD CONSTRAINT semi_conversion_rules_pkey PRIMARY KEY (id);


--
-- Name: semi_conversion_rules semi_conversion_rules_sku_id_key; Type: CONSTRAINT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.semi_conversion_rules
    ADD CONSTRAINT semi_conversion_rules_sku_id_key UNIQUE (sku_id);


--
-- Name: sku_types sku_types_pkey; Type: CONSTRAINT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.sku_types
    ADD CONSTRAINT sku_types_pkey PRIMARY KEY (id);


--
-- Name: skus skus_code_key; Type: CONSTRAINT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.skus
    ADD CONSTRAINT skus_code_key UNIQUE (code);


--
-- Name: skus skus_pkey; Type: CONSTRAINT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.skus
    ADD CONSTRAINT skus_pkey PRIMARY KEY (id);


--
-- Name: stock_levels stock_levels_pkey; Type: CONSTRAINT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.stock_levels
    ADD CONSTRAINT stock_levels_pkey PRIMARY KEY (id);


--
-- Name: stock_movement_types stock_movement_types_pkey; Type: CONSTRAINT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.stock_movement_types
    ADD CONSTRAINT stock_movement_types_pkey PRIMARY KEY (id);


--
-- Name: stock_movements stock_movements_pkey; Type: CONSTRAINT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.stock_movements
    ADD CONSTRAINT stock_movements_pkey PRIMARY KEY (id);


--
-- Name: merma_causes uq_merma_causes_stage_code; Type: CONSTRAINT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.merma_causes
    ADD CONSTRAINT uq_merma_causes_stage_code UNIQUE (stage, code);


--
-- Name: merma_types uq_merma_types_stage_code; Type: CONSTRAINT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.merma_types
    ADD CONSTRAINT uq_merma_types_stage_code UNIQUE (stage, code);


--
-- Name: sku_types uq_sku_types_code; Type: CONSTRAINT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.sku_types
    ADD CONSTRAINT uq_sku_types_code UNIQUE (code);


--
-- Name: stock_movement_types uq_stock_movement_types_code; Type: CONSTRAINT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.stock_movement_types
    ADD CONSTRAINT uq_stock_movement_types_code UNIQUE (code);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: skus fk_skus_sku_type_id; Type: FK CONSTRAINT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.skus
    ADD CONSTRAINT fk_skus_sku_type_id FOREIGN KEY (sku_type_id) REFERENCES public.sku_types(id);


--
-- Name: stock_movements fk_stock_movements_production_lot; Type: FK CONSTRAINT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.stock_movements
    ADD CONSTRAINT fk_stock_movements_production_lot FOREIGN KEY (production_lot_id) REFERENCES public.production_lots(id);


--
-- Name: merma_events merma_events_cause_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.merma_events
    ADD CONSTRAINT merma_events_cause_id_fkey FOREIGN KEY (cause_id) REFERENCES public.merma_causes(id);


--
-- Name: merma_events merma_events_deposit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.merma_events
    ADD CONSTRAINT merma_events_deposit_id_fkey FOREIGN KEY (deposit_id) REFERENCES public.deposits(id);


--
-- Name: merma_events merma_events_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.merma_events
    ADD CONSTRAINT merma_events_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id);


--
-- Name: merma_events merma_events_production_line_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.merma_events
    ADD CONSTRAINT merma_events_production_line_id_fkey FOREIGN KEY (production_line_id) REFERENCES public.production_lines(id);


--
-- Name: merma_events merma_events_remito_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.merma_events
    ADD CONSTRAINT merma_events_remito_id_fkey FOREIGN KEY (remito_id) REFERENCES public.remitos(id);


--
-- Name: merma_events merma_events_remito_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.merma_events
    ADD CONSTRAINT merma_events_remito_item_id_fkey FOREIGN KEY (remito_item_id) REFERENCES public.remito_items(id);


--
-- Name: merma_events merma_events_reported_by_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.merma_events
    ADD CONSTRAINT merma_events_reported_by_user_id_fkey FOREIGN KEY (reported_by_user_id) REFERENCES public.users(id);


--
-- Name: merma_events merma_events_sku_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.merma_events
    ADD CONSTRAINT merma_events_sku_id_fkey FOREIGN KEY (sku_id) REFERENCES public.skus(id);


--
-- Name: merma_events merma_events_stock_movement_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.merma_events
    ADD CONSTRAINT merma_events_stock_movement_id_fkey FOREIGN KEY (stock_movement_id) REFERENCES public.stock_movements(id);


--
-- Name: merma_events merma_events_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.merma_events
    ADD CONSTRAINT merma_events_type_id_fkey FOREIGN KEY (type_id) REFERENCES public.merma_types(id);


--
-- Name: order_items order_items_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id);


--
-- Name: order_items order_items_sku_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_sku_id_fkey FOREIGN KEY (sku_id) REFERENCES public.skus(id);


--
-- Name: orders orders_destination_deposit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_destination_deposit_id_fkey FOREIGN KEY (destination_deposit_id) REFERENCES public.deposits(id);


--
-- Name: production_lots production_lots_deposit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.production_lots
    ADD CONSTRAINT production_lots_deposit_id_fkey FOREIGN KEY (deposit_id) REFERENCES public.deposits(id);


--
-- Name: production_lots production_lots_production_line_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.production_lots
    ADD CONSTRAINT production_lots_production_line_id_fkey FOREIGN KEY (production_line_id) REFERENCES public.production_lines(id);


--
-- Name: production_lots production_lots_sku_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.production_lots
    ADD CONSTRAINT production_lots_sku_id_fkey FOREIGN KEY (sku_id) REFERENCES public.skus(id);


--
-- Name: recipe_items recipe_items_component_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.recipe_items
    ADD CONSTRAINT recipe_items_component_id_fkey FOREIGN KEY (component_id) REFERENCES public.skus(id);


--
-- Name: recipe_items recipe_items_recipe_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.recipe_items
    ADD CONSTRAINT recipe_items_recipe_id_fkey FOREIGN KEY (recipe_id) REFERENCES public.recipes(id);


--
-- Name: recipes recipes_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.recipes
    ADD CONSTRAINT recipes_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.skus(id);


--
-- Name: remito_items remito_items_remito_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.remito_items
    ADD CONSTRAINT remito_items_remito_id_fkey FOREIGN KEY (remito_id) REFERENCES public.remitos(id);


--
-- Name: remito_items remito_items_sku_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.remito_items
    ADD CONSTRAINT remito_items_sku_id_fkey FOREIGN KEY (sku_id) REFERENCES public.skus(id);


--
-- Name: remitos remitos_destination_deposit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.remitos
    ADD CONSTRAINT remitos_destination_deposit_id_fkey FOREIGN KEY (destination_deposit_id) REFERENCES public.deposits(id);


--
-- Name: remitos remitos_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.remitos
    ADD CONSTRAINT remitos_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id);


--
-- Name: remitos remitos_source_deposit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.remitos
    ADD CONSTRAINT remitos_source_deposit_id_fkey FOREIGN KEY (source_deposit_id) REFERENCES public.deposits(id);


--
-- Name: semi_conversion_rules semi_conversion_rules_sku_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.semi_conversion_rules
    ADD CONSTRAINT semi_conversion_rules_sku_id_fkey FOREIGN KEY (sku_id) REFERENCES public.skus(id);


--
-- Name: stock_levels stock_levels_deposit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.stock_levels
    ADD CONSTRAINT stock_levels_deposit_id_fkey FOREIGN KEY (deposit_id) REFERENCES public.deposits(id);


--
-- Name: stock_levels stock_levels_sku_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.stock_levels
    ADD CONSTRAINT stock_levels_sku_id_fkey FOREIGN KEY (sku_id) REFERENCES public.skus(id);


--
-- Name: stock_movements stock_movements_deposit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.stock_movements
    ADD CONSTRAINT stock_movements_deposit_id_fkey FOREIGN KEY (deposit_id) REFERENCES public.deposits(id);


--
-- Name: stock_movements stock_movements_sku_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.stock_movements
    ADD CONSTRAINT stock_movements_sku_id_fkey FOREIGN KEY (sku_id) REFERENCES public.skus(id);


--
-- Name: users users_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fnc
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id);


--
-- PostgreSQL database dump complete
--

\unrestrict npeKBywRbtK8GLcOF6jbR7xXhgS5gg8qDEqiHbINudjqHB5XNgaBfrOOrkvNqMd

