--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: active_admin_comments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE active_admin_comments (
    id integer NOT NULL,
    namespace character varying(255),
    body text,
    resource_id character varying(255) NOT NULL,
    resource_type character varying(255) NOT NULL,
    author_id integer,
    author_type character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: active_admin_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE active_admin_comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_admin_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE active_admin_comments_id_seq OWNED BY active_admin_comments.id;


--
-- Name: admin_users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE admin_users (
    id integer NOT NULL,
    osm_id integer,
    oauth_token character varying(255),
    oauth_secret character varying(255),
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying(255) DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    osm_username character varying(255),
    changeset_id bigint,
    role_id integer,
    location geography(Point,4326)
);


--
-- Name: admin_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE admin_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admin_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE admin_users_id_seq OWNED BY admin_users.id;


--
-- Name: candidates; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE candidates (
    id integer NOT NULL,
    place_id integer,
    lat double precision,
    lon double precision,
    name character varying(255),
    housenumber character varying(255),
    street character varying(255),
    postcode character varying(255),
    city character varying(255),
    website character varying(255),
    phone character varying(255),
    wheelchair character varying(255),
    osm_id bigint,
    osm_type character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: candidates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE candidates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: candidates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE candidates_id_seq OWNED BY candidates.id;


--
-- Name: changesets; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE changesets (
    id integer NOT NULL,
    osm_id bigint NOT NULL,
    admin_user_id integer NOT NULL,
    data_set_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: changesets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE changesets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: changesets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE changesets_id_seq OWNED BY changesets.id;


--
-- Name: data_sets; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE data_sets (
    id integer NOT NULL,
    name character varying(255),
    license character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    description text
);


--
-- Name: data_sets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE data_sets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: data_sets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE data_sets_id_seq OWNED BY data_sets.id;


--
-- Name: delayed_jobs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE delayed_jobs (
    id integer NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    attempts integer DEFAULT 0 NOT NULL,
    handler text NOT NULL,
    last_error text,
    run_at timestamp without time zone,
    locked_at timestamp without time zone,
    failed_at timestamp without time zone,
    locked_by character varying(255),
    queue character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: delayed_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE delayed_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: delayed_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE delayed_jobs_id_seq OWNED BY delayed_jobs.id;


--
-- Name: mappings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE mappings (
    id integer NOT NULL,
    locale character varying(255) NOT NULL,
    localized_name character varying(255) NOT NULL,
    osm_key character varying(255),
    osm_value character varying(255),
    plural boolean,
    operator character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: mappings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mappings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mappings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mappings_id_seq OWNED BY mappings.id;


--
-- Name: places; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE places (
    id integer NOT NULL,
    data_set_id integer,
    original_id integer,
    osm_id bigint,
    osm_key character varying(255),
    osm_value character varying(255),
    name character varying(255),
    lat double precision,
    lon double precision,
    street character varying(255),
    housenumber character varying(255),
    postcode character varying(255),
    city character varying(255),
    country character varying(255),
    website character varying(255),
    phone character varying(255),
    wheelchair character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    osm_type character varying(255),
    matcher_id integer,
    location geography(Point,4326),
    skips_count integer DEFAULT 0,
    wheelchair_description character varying(255),
    wheelchair_toilet character varying(255),
    centralkey character varying(255)
);


--
-- Name: places_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE places_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: places_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE places_id_seq OWNED BY places.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE roles (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE roles_id_seq OWNED BY roles.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: skips; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE skips (
    id integer NOT NULL,
    admin_user_id integer NOT NULL,
    place_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    matched boolean DEFAULT false NOT NULL
);


--
-- Name: skips_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skips_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skips_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skips_id_seq OWNED BY skips.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY active_admin_comments ALTER COLUMN id SET DEFAULT nextval('active_admin_comments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY admin_users ALTER COLUMN id SET DEFAULT nextval('admin_users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY candidates ALTER COLUMN id SET DEFAULT nextval('candidates_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY changesets ALTER COLUMN id SET DEFAULT nextval('changesets_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY data_sets ALTER COLUMN id SET DEFAULT nextval('data_sets_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY delayed_jobs ALTER COLUMN id SET DEFAULT nextval('delayed_jobs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY mappings ALTER COLUMN id SET DEFAULT nextval('mappings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY places ALTER COLUMN id SET DEFAULT nextval('places_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY roles ALTER COLUMN id SET DEFAULT nextval('roles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skips ALTER COLUMN id SET DEFAULT nextval('skips_id_seq'::regclass);


--
-- Name: active_admin_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY active_admin_comments
    ADD CONSTRAINT active_admin_comments_pkey PRIMARY KEY (id);


--
-- Name: admin_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY admin_users
    ADD CONSTRAINT admin_users_pkey PRIMARY KEY (id);


--
-- Name: candidates_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY candidates
    ADD CONSTRAINT candidates_pkey PRIMARY KEY (id);


--
-- Name: changesets_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY changesets
    ADD CONSTRAINT changesets_pkey PRIMARY KEY (id);


--
-- Name: data_sets_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY data_sets
    ADD CONSTRAINT data_sets_pkey PRIMARY KEY (id);


--
-- Name: delayed_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY delayed_jobs
    ADD CONSTRAINT delayed_jobs_pkey PRIMARY KEY (id);


--
-- Name: mappings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY mappings
    ADD CONSTRAINT mappings_pkey PRIMARY KEY (id);


--
-- Name: places_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY places
    ADD CONSTRAINT places_pkey PRIMARY KEY (id);


--
-- Name: roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: skips_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY skips
    ADD CONSTRAINT skips_pkey PRIMARY KEY (id);


--
-- Name: delayed_jobs_priority; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX delayed_jobs_priority ON delayed_jobs USING btree (priority, run_at);


--
-- Name: index_active_admin_comments_on_author_type_and_author_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_active_admin_comments_on_author_type_and_author_id ON active_admin_comments USING btree (author_type, author_id);


--
-- Name: index_active_admin_comments_on_namespace; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_active_admin_comments_on_namespace ON active_admin_comments USING btree (namespace);


--
-- Name: index_active_admin_comments_on_resource_type_and_resource_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_active_admin_comments_on_resource_type_and_resource_id ON active_admin_comments USING btree (resource_type, resource_id);


--
-- Name: index_admin_users_on_osm_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_admin_users_on_osm_id ON admin_users USING btree (osm_id);


--
-- Name: index_admin_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_admin_users_on_reset_password_token ON admin_users USING btree (reset_password_token);


--
-- Name: index_changesets_on_admin_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_changesets_on_admin_user_id ON changesets USING btree (admin_user_id);


--
-- Name: index_changesets_on_data_set_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_changesets_on_data_set_id ON changesets USING btree (data_set_id);


--
-- Name: index_places_on_location; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_places_on_location ON places USING gist (location);


--
-- Name: index_skips_on_admin_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_skips_on_admin_user_id ON skips USING btree (admin_user_id);


--
-- Name: index_skips_on_place_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_skips_on_place_id ON skips USING btree (place_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO public,postgis;

INSERT INTO schema_migrations (version) VALUES ('20131210134326');

INSERT INTO schema_migrations (version) VALUES ('20131210134328');

INSERT INTO schema_migrations (version) VALUES ('20131210141621');

INSERT INTO schema_migrations (version) VALUES ('20131210142715');

INSERT INTO schema_migrations (version) VALUES ('20140121161949');

INSERT INTO schema_migrations (version) VALUES ('20140206151851');

INSERT INTO schema_migrations (version) VALUES ('20140211131800');

INSERT INTO schema_migrations (version) VALUES ('20140212153211');

INSERT INTO schema_migrations (version) VALUES ('20140213095658');

INSERT INTO schema_migrations (version) VALUES ('20140218135352');

INSERT INTO schema_migrations (version) VALUES ('20140219153831');

INSERT INTO schema_migrations (version) VALUES ('20140220132608');

INSERT INTO schema_migrations (version) VALUES ('20140227160838');

INSERT INTO schema_migrations (version) VALUES ('20140227160912');

INSERT INTO schema_migrations (version) VALUES ('20140305103353');

INSERT INTO schema_migrations (version) VALUES ('20140305134429');

INSERT INTO schema_migrations (version) VALUES ('20140515125803');

INSERT INTO schema_migrations (version) VALUES ('20140812141740');

INSERT INTO schema_migrations (version) VALUES ('20140821105932');

INSERT INTO schema_migrations (version) VALUES ('20140902121726');

INSERT INTO schema_migrations (version) VALUES ('20150622142101');

INSERT INTO schema_migrations (version) VALUES ('20150625130647');

