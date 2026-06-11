--
-- PostgreSQL database dump
--

\restrict K50TuLC5fUiAihpqJZfU8i5L2b8WYMsQX9ADG49SSvO10xvnJQ4z7yBspEfBoiH

-- Dumped from database version 18.2 (Ubuntu 18.2-1.pgdg24.04+1)
-- Dumped by pg_dump version 18.2 (Ubuntu 18.2-1.pgdg24.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: artists; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.artists (
    id integer NOT NULL,
    last_name character varying(150) NOT NULL,
    first_name character varying(150) NOT NULL,
    middle_name character varying(150),
    birth_year integer NOT NULL,
    death_year integer,
    country_id smallint,
    culture_id smallint,
    biography text,
    CONSTRAINT artists_birth_year_check CHECK ((birth_year > '-5000'::integer)),
    CONSTRAINT artists_death_year_check CHECK ((death_year > '-5000'::integer))
);


ALTER TABLE public.artists OWNER TO postgres;

--
-- Name: artists_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.artists_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.artists_id_seq OWNER TO postgres;

--
-- Name: artists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.artists_id_seq OWNED BY public.artists.id;


--
-- Name: buildings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.buildings (
    id smallint NOT NULL,
    code character varying(20) NOT NULL,
    name_ru character varying(100) NOT NULL,
    name_en character varying(100) NOT NULL,
    address character varying(255) NOT NULL,
    year_built integer NOT NULL,
    CONSTRAINT buildings_year_built_check CHECK ((year_built > 0))
);


ALTER TABLE public.buildings OWNER TO postgres;

--
-- Name: buildings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.buildings_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.buildings_id_seq OWNER TO postgres;

--
-- Name: buildings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.buildings_id_seq OWNED BY public.buildings.id;


--
-- Name: conservation_records; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.conservation_records (
    id integer NOT NULL,
    exhibit_id uuid NOT NULL,
    record_type character varying(50) NOT NULL,
    start_date date NOT NULL,
    end_date date,
    conservator_id uuid NOT NULL,
    cost numeric(15,2),
    CONSTRAINT conservation_records_cost_check CHECK ((cost >= (0)::numeric)),
    CONSTRAINT conservation_records_record_type_check CHECK (((record_type)::text = ANY ((ARRAY['examination'::character varying, 'conservation'::character varying, 'restoration'::character varying])::text[])))
);


ALTER TABLE public.conservation_records OWNER TO postgres;

--
-- Name: conservation_records_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.conservation_records_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.conservation_records_id_seq OWNER TO postgres;

--
-- Name: conservation_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.conservation_records_id_seq OWNED BY public.conservation_records.id;


--
-- Name: countries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.countries (
    id smallint NOT NULL,
    code character varying(2) NOT NULL,
    name_ru character varying(100) NOT NULL,
    name_en character varying(100) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.countries OWNER TO postgres;

--
-- Name: countries_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.countries_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.countries_id_seq OWNER TO postgres;

--
-- Name: countries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.countries_id_seq OWNED BY public.countries.id;


--
-- Name: cultures; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cultures (
    id smallint NOT NULL,
    name_ru character varying(100) NOT NULL,
    name_en character varying(100) NOT NULL,
    time_period character varying(100),
    geographic_region character varying(200)
);


ALTER TABLE public.cultures OWNER TO postgres;

--
-- Name: cultures_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cultures_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cultures_id_seq OWNER TO postgres;

--
-- Name: cultures_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cultures_id_seq OWNED BY public.cultures.id;


--
-- Name: departments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.departments (
    id smallint NOT NULL,
    code character varying(50) NOT NULL,
    name_ru character varying(150) NOT NULL,
    name_en character varying(150) NOT NULL,
    building_id smallint NOT NULL,
    head_curator_id uuid
);


ALTER TABLE public.departments OWNER TO postgres;

--
-- Name: departments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.departments_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.departments_id_seq OWNER TO postgres;

--
-- Name: departments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.departments_id_seq OWNED BY public.departments.id;


--
-- Name: exhibit_artists; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.exhibit_artists (
    exhibit_id uuid NOT NULL,
    artist_id integer NOT NULL,
    is_primary boolean DEFAULT false NOT NULL
);


ALTER TABLE public.exhibit_artists OWNER TO postgres;

--
-- Name: exhibit_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.exhibit_categories (
    id integer NOT NULL,
    parent_id integer,
    code character varying(50) NOT NULL,
    name_ru character varying(100) NOT NULL,
    name_en character varying(100) NOT NULL
);


ALTER TABLE public.exhibit_categories OWNER TO postgres;

--
-- Name: exhibit_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.exhibit_categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.exhibit_categories_id_seq OWNER TO postgres;

--
-- Name: exhibit_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.exhibit_categories_id_seq OWNED BY public.exhibit_categories.id;


--
-- Name: exhibit_descriptions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.exhibit_descriptions (
    id integer NOT NULL,
    exhibit_id uuid NOT NULL,
    language_code character varying(5) NOT NULL,
    description text NOT NULL,
    historical_context text,
    created_by uuid NOT NULL,
    CONSTRAINT exhibit_descriptions_language_code_check CHECK (((language_code)::text = ANY ((ARRAY['ru'::character varying, 'en'::character varying, 'de'::character varying, 'fr'::character varying])::text[])))
);


ALTER TABLE public.exhibit_descriptions OWNER TO postgres;

--
-- Name: exhibit_descriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.exhibit_descriptions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.exhibit_descriptions_id_seq OWNER TO postgres;

--
-- Name: exhibit_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.exhibit_descriptions_id_seq OWNED BY public.exhibit_descriptions.id;


--
-- Name: exhibit_materials; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.exhibit_materials (
    exhibit_id uuid NOT NULL,
    material_id smallint NOT NULL,
    is_primary boolean DEFAULT false NOT NULL
);


ALTER TABLE public.exhibit_materials OWNER TO postgres;

--
-- Name: exhibition_exhibits; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.exhibition_exhibits (
    exhibition_id integer NOT NULL,
    exhibit_id uuid NOT NULL,
    section_name character varying(150)
);


ALTER TABLE public.exhibition_exhibits OWNER TO postgres;

--
-- Name: exhibitions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.exhibitions (
    id integer NOT NULL,
    code character varying(50) NOT NULL,
    title_ru character varying(300) NOT NULL,
    title_en character varying(300) NOT NULL,
    exhibition_type character varying(50) NOT NULL,
    start_date date NOT NULL,
    end_date date,
    location_id integer,
    curator_id uuid NOT NULL,
    CONSTRAINT exhibitions_exhibition_type_check CHECK (((exhibition_type)::text = ANY ((ARRAY['permanent'::character varying, 'temporary'::character varying, 'traveling'::character varying])::text[])))
);


ALTER TABLE public.exhibitions OWNER TO postgres;

--
-- Name: exhibitions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.exhibitions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.exhibitions_id_seq OWNER TO postgres;

--
-- Name: exhibitions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.exhibitions_id_seq OWNED BY public.exhibitions.id;


--
-- Name: exhibits; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.exhibits (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    inventory_number character varying(50) NOT NULL,
    title_ru character varying(300) NOT NULL,
    title_en character varying(300),
    category_id smallint NOT NULL,
    department_id smallint NOT NULL,
    culture_id smallint,
    creation_century character varying(50),
    hall_id integer,
    storage_id integer,
    is_on_display boolean DEFAULT false NOT NULL,
    registered_by uuid NOT NULL,
    CONSTRAINT chk_hall_or_storage CHECK (((hall_id IS NOT NULL) OR (storage_id IS NOT NULL)))
);


ALTER TABLE public.exhibits OWNER TO postgres;

--
-- Name: trg_update_display_status; Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE OR REPLACE FUNCTION public.trg_update_display_status()
RETURNS TRIGGER AS $$
BEGIN
    -- Если назначили зал — экспонат выставлен
    IF NEW.hall_id IS NOT NULL THEN
        NEW.is_on_display := TRUE;
    -- Если убрали в хранилище — не выставлен
    ELSE
        NEW.is_on_display := FALSE;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


ALTER FUNCTION public.trg_update_display_status() OWNER TO postgres;

--
-- Name: set_display_status; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_display_status
BEFORE INSERT OR UPDATE ON public.exhibits
FOR EACH ROW
EXECUTE FUNCTION public.trg_update_display_status();


--
-- Name: add_new_staff; Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE OR REPLACE FUNCTION public.add_new_staff(
    p_username      character varying,
    p_email         character varying,
    p_password_hash character varying,
    p_role          character varying,
    p_last_name     character varying,
    p_first_name    character varying,
    p_middle_name   character varying,
    p_department_id smallint,
    p_position      character varying
)
RETURNS uuid AS $$
DECLARE
    v_user_id uuid;
BEGIN
    -- Проверяем допустимость роли (дублируем CHECK для явного сообщения)
    IF p_role NOT IN ('admin', 'curator', 'conservator', 'registrar', 'viewer') THEN
        RAISE EXCEPTION 'Недопустимая роль: %. Допустимые значения: admin, curator, conservator, registrar, viewer', p_role;
    END IF;

    INSERT INTO public.users (
        username, email, password_hash, role,
        last_name, first_name, middle_name,
        department_id, position, is_active
    )
    VALUES (
        p_username, p_email, p_password_hash, p_role,
        p_last_name, p_first_name, p_middle_name,
        p_department_id, p_position, TRUE
    )
    RETURNING id INTO v_user_id;

    RETURN v_user_id;
END;
$$ LANGUAGE plpgsql;


ALTER FUNCTION public.add_new_staff(
    character varying, character varying, character varying, character varying,
    character varying, character varying, character varying, smallint, character varying
) OWNER TO postgres;


--
-- Name: trg_prevent_exhibit_delete; Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE OR REPLACE FUNCTION public.trg_prevent_exhibit_delete()
RETURNS TRIGGER AS $$
DECLARE
    v_exhibition_title character varying;
BEGIN
    -- Ищем хотя бы одну активную выставку (без end_date или end_date в будущем)
    SELECT e.title_ru INTO v_exhibition_title
    FROM public.exhibition_exhibits ee
    JOIN public.exhibitions e ON e.id = ee.exhibition_id
    WHERE ee.exhibit_id = OLD.id
      AND (e.end_date IS NULL OR e.end_date >= CURRENT_DATE)
    LIMIT 1;

    IF FOUND THEN
        RAISE EXCEPTION
            'Нельзя удалить экспонат "%": он участвует в активной выставке "%"',
            OLD.title_ru, v_exhibition_title;
    END IF;

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;


ALTER FUNCTION public.trg_prevent_exhibit_delete() OWNER TO postgres;

--
-- Name: prevent_exhibit_delete; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER prevent_exhibit_delete
BEFORE DELETE ON public.exhibits
FOR EACH ROW
EXECUTE FUNCTION public.trg_prevent_exhibit_delete();


--
-- Name: locations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.locations (
    id integer NOT NULL,
    building_id smallint NOT NULL,
    department_id smallint,
    code character varying(50) NOT NULL,
    name_ru character varying(150) NOT NULL,
    name_en character varying(150) NOT NULL,
    location_type character varying(20) NOT NULL,
    floor smallint NOT NULL,
    climate_zone character varying(50) NOT NULL,
    is_accessible boolean DEFAULT true NOT NULL,
    CONSTRAINT locations_climate_zone_check CHECK (((climate_zone)::text = ANY ((ARRAY['standard'::character varying, 'sensitive'::character varying, 'special'::character varying])::text[]))),
    CONSTRAINT locations_location_type_check CHECK (((location_type)::text = ANY ((ARRAY['hall'::character varying, 'storage'::character varying])::text[])))
);


ALTER TABLE public.locations OWNER TO postgres;

--
-- Name: locations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.locations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.locations_id_seq OWNER TO postgres;

--
-- Name: locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.locations_id_seq OWNED BY public.locations.id;


--
-- Name: materials; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.materials (
    id smallint NOT NULL,
    code character varying(50) NOT NULL,
    name_ru character varying(100) NOT NULL,
    name_en character varying(100) NOT NULL,
    is_precious boolean DEFAULT false NOT NULL
);


ALTER TABLE public.materials OWNER TO postgres;

--
-- Name: materials_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.materials_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.materials_id_seq OWNER TO postgres;

--
-- Name: materials_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.materials_id_seq OWNED BY public.materials.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    username character varying(50) NOT NULL,
    email character varying(255) NOT NULL,
    password_hash character varying(255) NOT NULL,
    role character varying(50) NOT NULL,
    last_name character varying(100) NOT NULL,
    first_name character varying(100) NOT NULL,
    middle_name character varying(100),
    department_id smallint NOT NULL,
    "position" character varying(150) NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    CONSTRAINT users_role_check CHECK (((role)::text = ANY ((ARRAY['admin'::character varying, 'curator'::character varying, 'conservator'::character varying, 'registrar'::character varying, 'viewer'::character varying])::text[])))
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: artists id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artists ALTER COLUMN id SET DEFAULT nextval('public.artists_id_seq'::regclass);


--
-- Name: buildings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.buildings ALTER COLUMN id SET DEFAULT nextval('public.buildings_id_seq'::regclass);


--
-- Name: conservation_records id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conservation_records ALTER COLUMN id SET DEFAULT nextval('public.conservation_records_id_seq'::regclass);


--
-- Name: countries id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.countries ALTER COLUMN id SET DEFAULT nextval('public.countries_id_seq'::regclass);


--
-- Name: cultures id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cultures ALTER COLUMN id SET DEFAULT nextval('public.cultures_id_seq'::regclass);


--
-- Name: departments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments ALTER COLUMN id SET DEFAULT nextval('public.departments_id_seq'::regclass);


--
-- Name: exhibit_categories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exhibit_categories ALTER COLUMN id SET DEFAULT nextval('public.exhibit_categories_id_seq'::regclass);


--
-- Name: exhibit_descriptions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exhibit_descriptions ALTER COLUMN id SET DEFAULT nextval('public.exhibit_descriptions_id_seq'::regclass);


--
-- Name: exhibitions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exhibitions ALTER COLUMN id SET DEFAULT nextval('public.exhibitions_id_seq'::regclass);


--
-- Name: locations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.locations ALTER COLUMN id SET DEFAULT nextval('public.locations_id_seq'::regclass);


--
-- Name: materials id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.materials ALTER COLUMN id SET DEFAULT nextval('public.materials_id_seq'::regclass);


--
-- Data for Name: artists; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.artists (id, last_name, first_name, middle_name, birth_year, death_year, country_id, culture_id, biography) FROM stdin;
\.


--
-- Data for Name: buildings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.buildings (id, code, name_ru, name_en, address, year_built) FROM stdin;
\.


--
-- Data for Name: conservation_records; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.conservation_records (id, exhibit_id, record_type, start_date, end_date, conservator_id, cost) FROM stdin;
\.


--
-- Data for Name: countries; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.countries (id, code, name_ru, name_en, created_at) FROM stdin;
\.


--
-- Data for Name: cultures; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cultures (id, name_ru, name_en, time_period, geographic_region) FROM stdin;
\.


--
-- Data for Name: departments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.departments (id, code, name_ru, name_en, building_id, head_curator_id) FROM stdin;
\.


--
-- Data for Name: exhibit_artists; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.exhibit_artists (exhibit_id, artist_id, is_primary) FROM stdin;
\.


--
-- Data for Name: exhibit_categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.exhibit_categories (id, parent_id, code, name_ru, name_en) FROM stdin;
\.


--
-- Data for Name: exhibit_descriptions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.exhibit_descriptions (id, exhibit_id, language_code, description, historical_context, created_by) FROM stdin;
\.


--
-- Data for Name: exhibit_materials; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.exhibit_materials (exhibit_id, material_id, is_primary) FROM stdin;
\.


--
-- Data for Name: exhibition_exhibits; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.exhibition_exhibits (exhibition_id, exhibit_id, section_name) FROM stdin;
\.


--
-- Data for Name: exhibitions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.exhibitions (id, code, title_ru, title_en, exhibition_type, start_date, end_date, location_id, curator_id) FROM stdin;
\.


--
-- Data for Name: exhibits; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.exhibits (id, inventory_number, title_ru, title_en, category_id, department_id, culture_id, creation_century, hall_id, storage_id, is_on_display, registered_by) FROM stdin;
\.


--
-- Data for Name: locations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.locations (id, building_id, department_id, code, name_ru, name_en, location_type, floor, climate_zone, is_accessible) FROM stdin;
\.


--
-- Data for Name: materials; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.materials (id, code, name_ru, name_en, is_precious) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, username, email, password_hash, role, last_name, first_name, middle_name, department_id, "position", is_active) FROM stdin;
\.


--
-- Name: artists_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.artists_id_seq', 1, false);


--
-- Name: buildings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.buildings_id_seq', 1, false);


--
-- Name: conservation_records_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.conservation_records_id_seq', 1, false);


--
-- Name: countries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.countries_id_seq', 1, false);


--
-- Name: cultures_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cultures_id_seq', 1, false);


--
-- Name: departments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.departments_id_seq', 1, false);


--
-- Name: exhibit_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.exhibit_categories_id_seq', 1, false);


--
-- Name: exhibit_descriptions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.exhibit_descriptions_id_seq', 1, false);


--
-- Name: exhibitions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.exhibitions_id_seq', 1, false);


--
-- Name: locations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.locations_id_seq', 1, false);


--
-- Name: materials_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.materials_id_seq', 1, false);


--
-- Name: artists artists_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artists
    ADD CONSTRAINT artists_pkey PRIMARY KEY (id);


--
-- Name: buildings buildings_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.buildings
    ADD CONSTRAINT buildings_code_key UNIQUE (code);


--
-- Name: buildings buildings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.buildings
    ADD CONSTRAINT buildings_pkey PRIMARY KEY (id);


--
-- Name: conservation_records conservation_records_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conservation_records
    ADD CONSTRAINT conservation_records_pkey PRIMARY KEY (id);


--
-- Name: countries countries_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_code_key UNIQUE (code);


--
-- Name: countries countries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (id);


--
-- Name: cultures cultures_name_en_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cultures
    ADD CONSTRAINT cultures_name_en_key UNIQUE (name_en);


--
-- Name: cultures cultures_name_ru_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cultures
    ADD CONSTRAINT cultures_name_ru_key UNIQUE (name_ru);


--
-- Name: cultures cultures_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cultures
    ADD CONSTRAINT cultures_pkey PRIMARY KEY (id);


--
-- Name: departments departments_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_code_key UNIQUE (code);


--
-- Name: departments departments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY (id);


--
-- Name: exhibit_artists exhibit_artists_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exhibit_artists
    ADD CONSTRAINT exhibit_artists_pkey PRIMARY KEY (exhibit_id, artist_id);


--
-- Name: exhibit_categories exhibit_categories_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exhibit_categories
    ADD CONSTRAINT exhibit_categories_code_key UNIQUE (code);


--
-- Name: exhibit_categories exhibit_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exhibit_categories
    ADD CONSTRAINT exhibit_categories_pkey PRIMARY KEY (id);


--
-- Name: exhibit_descriptions exhibit_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exhibit_descriptions
    ADD CONSTRAINT exhibit_descriptions_pkey PRIMARY KEY (id);


--
-- Name: exhibit_materials exhibit_materials_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exhibit_materials
    ADD CONSTRAINT exhibit_materials_pkey PRIMARY KEY (exhibit_id, material_id);


--
-- Name: exhibition_exhibits exhibition_exhibits_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exhibition_exhibits
    ADD CONSTRAINT exhibition_exhibits_pkey PRIMARY KEY (exhibition_id, exhibit_id);


--
-- Name: exhibitions exhibitions_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exhibitions
    ADD CONSTRAINT exhibitions_code_key UNIQUE (code);


--
-- Name: exhibitions exhibitions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exhibitions
    ADD CONSTRAINT exhibitions_pkey PRIMARY KEY (id);


--
-- Name: exhibits exhibits_inventory_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exhibits
    ADD CONSTRAINT exhibits_inventory_number_key UNIQUE (inventory_number);


--
-- Name: exhibits exhibits_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exhibits
    ADD CONSTRAINT exhibits_pkey PRIMARY KEY (id);


--
-- Name: locations locations_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_code_key UNIQUE (code);


--
-- Name: locations locations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: materials materials_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.materials
    ADD CONSTRAINT materials_code_key UNIQUE (code);


--
-- Name: materials materials_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.materials
    ADD CONSTRAINT materials_pkey PRIMARY KEY (id);


--
-- Name: exhibit_descriptions uq_exhibit_language; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exhibit_descriptions
    ADD CONSTRAINT uq_exhibit_language UNIQUE (exhibit_id, language_code);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: exhibit_artists fk_artists_exhibit_artists; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exhibit_artists
    ADD CONSTRAINT fk_artists_exhibit_artists FOREIGN KEY (artist_id) REFERENCES public.artists(id);


--
-- Name: departments fk_buildings_departments; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT fk_buildings_departments FOREIGN KEY (building_id) REFERENCES public.buildings(id);


--
-- Name: locations fk_buildings_locations; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT fk_buildings_locations FOREIGN KEY (building_id) REFERENCES public.buildings(id);


--
-- Name: exhibits fk_categories_exhibits; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exhibits
    ADD CONSTRAINT fk_categories_exhibits FOREIGN KEY (category_id) REFERENCES public.exhibit_categories(id);


--
-- Name: exhibit_categories fk_categories_self; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exhibit_categories
    ADD CONSTRAINT fk_categories_self FOREIGN KEY (parent_id) REFERENCES public.exhibit_categories(id);


--
-- Name: artists fk_countries_artists; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artists
    ADD CONSTRAINT fk_countries_artists FOREIGN KEY (country_id) REFERENCES public.countries(id);


--
-- Name: artists fk_cultures_artists; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artists
    ADD CONSTRAINT fk_cultures_artists FOREIGN KEY (culture_id) REFERENCES public.cultures(id);


--
-- Name: exhibits fk_cultures_exhibits; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exhibits
    ADD CONSTRAINT fk_cultures_exhibits FOREIGN KEY (culture_id) REFERENCES public.cultures(id);


--
-- Name: locations fk_departments_locations; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT fk_departments_locations FOREIGN KEY (department_id) REFERENCES public.departments(id);


--
-- Name: users fk_departments_users_dept; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_departments_users_dept FOREIGN KEY (department_id) REFERENCES public.departments(id);


--
-- Name: departments fk_departments_users_head; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT fk_departments_users_head FOREIGN KEY (head_curator_id) REFERENCES public.users(id);


--
-- Name: exhibition_exhibits fk_exhibitions_exhibits; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exhibition_exhibits
    ADD CONSTRAINT fk_exhibitions_exhibits FOREIGN KEY (exhibition_id) REFERENCES public.exhibitions(id);


--
-- Name: exhibit_artists fk_exhibits_artists; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exhibit_artists
    ADD CONSTRAINT fk_exhibits_artists FOREIGN KEY (exhibit_id) REFERENCES public.exhibits(id);


--
-- Name: conservation_records fk_exhibits_conservation; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conservation_records
    ADD CONSTRAINT fk_exhibits_conservation FOREIGN KEY (exhibit_id) REFERENCES public.exhibits(id);


--
-- Name: exhibit_descriptions fk_exhibits_descriptions; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exhibit_descriptions
    ADD CONSTRAINT fk_exhibits_descriptions FOREIGN KEY (exhibit_id) REFERENCES public.exhibits(id);


--
-- Name: exhibition_exhibits fk_exhibits_exhibition_exhibits; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exhibition_exhibits
    ADD CONSTRAINT fk_exhibits_exhibition_exhibits FOREIGN KEY (exhibit_id) REFERENCES public.exhibits(id);


--
-- Name: exhibit_materials fk_exhibits_materials; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exhibit_materials
    ADD CONSTRAINT fk_exhibits_materials FOREIGN KEY (exhibit_id) REFERENCES public.exhibits(id);


--
-- Name: exhibitions fk_locations_exhibitions; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exhibitions
    ADD CONSTRAINT fk_locations_exhibitions FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: exhibits fk_locations_halls; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exhibits
    ADD CONSTRAINT fk_locations_halls FOREIGN KEY (hall_id) REFERENCES public.locations(id);


--
-- Name: exhibits fk_locations_storage; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exhibits
    ADD CONSTRAINT fk_locations_storage FOREIGN KEY (storage_id) REFERENCES public.locations(id);


--
-- Name: exhibit_materials fk_materials_exhibit_materials; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exhibit_materials
    ADD CONSTRAINT fk_materials_exhibit_materials FOREIGN KEY (material_id) REFERENCES public.materials(id);


--
-- Name: conservation_records fk_users_conservation; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conservation_records
    ADD CONSTRAINT fk_users_conservation FOREIGN KEY (conservator_id) REFERENCES public.users(id);


--
-- Name: exhibit_descriptions fk_users_descriptions; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exhibit_descriptions
    ADD CONSTRAINT fk_users_descriptions FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: exhibitions fk_users_exhibitions; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exhibitions
    ADD CONSTRAINT fk_users_exhibitions FOREIGN KEY (curator_id) REFERENCES public.users(id);


--
-- Name: exhibits fk_users_exhibits_reg; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exhibits
    ADD CONSTRAINT fk_users_exhibits_reg FOREIGN KEY (registered_by) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

\unrestrict K50TuLC5fUiAihpqJZfU8i5L2b8WYMsQX9ADG49SSvO10xvnJQ4z7yBspEfBoiH
