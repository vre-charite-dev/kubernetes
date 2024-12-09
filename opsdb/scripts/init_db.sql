
   --- Keycloak DB , user creation
    CREATE extension IF NOT EXISTS dblink;

   
CREATE OR REPLACE FUNCTION pg_temp.f_create_db(db text)
      RETURNS void AS
    $func$
    DECLARE
       _db text := db;
    BEGIN
     
      IF EXISTS (SELECT 1 FROM pg_database WHERE datname = _db) THEN
         RAISE NOTICE 'Database already exists';
       ELSE
 
          PERFORM dblink_exec('dbname=' || current_database(), 'CREATE DATABASE ' || _db);
       END IF;

    END
    $func$ LANGUAGE plpgsql;

SELECT pg_temp.f_create_db(:'KEYCLOAK_DB');	
SELECT pg_temp.f_create_db(:'INDOC_DB');		

CREATE OR REPLACE FUNCTION pg_temp.f_try_create_user(u text, pass text)
	 RETURNS void AS
   $func$
   DECLARE
     _user text := u;
	 _pass text := pass;
   BEGIN
      IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = _user) THEN
          --CREATE USER _user WITH PASSWORD '_pass';
          EXECUTE format('CREATE USER %I WITH PASSWORD %L', _user, _pass);
      END IF;
   END
   $func$ LANGUAGE plpgsql;

SELECT pg_temp.f_try_create_user(:'KEYCLOAK_USER',:'KEYCLOAK_PASSWORD');
SELECT pg_temp.f_try_create_user(:'INDOC_USER',:'INDOC_PASSWORD');
   
    
GRANT ALL PRIVILEGES ON DATABASE :KEYCLOAK_DB TO :KEYCLOAK_USER;
GRANT ALL ON SCHEMA public TO :KEYCLOAK_USER;
   
GRANT ALL PRIVILEGES ON DATABASE :INDOC_DB TO :INDOC_USER;
GRANT ALL ON SCHEMA public TO :INDOC_USER;
    

--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.23
-- Dumped by pg_dump version 9.5.23



SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: indoc_vre; Type: SCHEMA; Schema: -; Owner: indoc_vre
--

CREATE SCHEMA IF NOT EXISTS indoc_vre ;

\c :INDOC_DB


ALTER SCHEMA indoc_vre OWNER TO indoc_vre;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: typeenum; Type: TYPE; Schema: indoc_vre; Owner: indoc_vre
--


-- https://stackoverflow.com/questions/7624919/check-if-a-user-defined-type-already-exists-in-postgresql

DO $$ BEGIN
    CREATE TYPE indoc_vre.typeenum AS ENUM 
    (
        'text',
        'multiple_choice'
    );
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;


ALTER TYPE indoc_vre.typeenum OWNER TO indoc_vre;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: announcement; Type: TABLE; Schema: indoc_vre; Owner: indoc_vre
--

CREATE TABLE IF NOT EXISTS indoc_vre.announcement (
    id integer NOT NULL,
    project_code character varying,
    content character varying,
    version character varying,
    publisher character varying,
    date timestamp without time zone
);


ALTER TABLE indoc_vre.announcement OWNER TO indoc_vre;

--
-- Name: announcement_id_seq; Type: SEQUENCE; Schema: indoc_vre; Owner: indoc_vre
--

CREATE SEQUENCE IF NOT EXISTS  indoc_vre.announcement_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE indoc_vre.announcement_id_seq OWNER TO indoc_vre;

--
-- Name: announcement_id_seq; Type: SEQUENCE OWNED BY; Schema: indoc_vre; Owner: indoc_vre
--

ALTER SEQUENCE indoc_vre.announcement_id_seq OWNED BY indoc_vre.announcement.id;


--
-- Name: approval_entity; Type: TABLE; Schema: indoc_vre; Owner: indoc_vre
--

CREATE TABLE IF NOT EXISTS  indoc_vre.approval_entity (
    id uuid NOT NULL,
    request_id uuid,
    entity_geid character varying,
    entity_type character varying,
    review_status character varying,
    reviewed_by character varying,
    reviewed_at character varying,
    parent_geid character varying,
    copy_status character varying,
    name character varying,
    uploaded_by character varying,
    dcm_id character varying,
    uploaded_at timestamp without time zone,
    file_size bigint
);


ALTER TABLE indoc_vre.approval_entity OWNER TO indoc_vre;

--
-- Name: approval_request; Type: TABLE; Schema: indoc_vre; Owner: indoc_vre
--

CREATE TABLE IF NOT EXISTS indoc_vre.approval_request (
    id uuid NOT NULL,
    status character varying,
    submitted_by character varying,
    submitted_at timestamp without time zone,
    destination_geid character varying,
    source_geid character varying,
    note character varying,
    project_geid character varying,
    destination_path character varying,
    source_path character varying,
    review_notes character varying,
    completed_by character varying,
    completed_at timestamp without time zone
);


ALTER TABLE indoc_vre.approval_request OWNER TO indoc_vre;

--
-- Name: archive_preview; Type: TABLE; Schema: indoc_vre; Owner: indoc_vre
--

CREATE TABLE IF NOT EXISTS indoc_vre.archive_preview (
    id integer NOT NULL,
    file_geid character varying,
    archive_preview character varying
);


ALTER TABLE indoc_vre.archive_preview OWNER TO indoc_vre;

--
-- Name: archive_preview_id_seq; Type: SEQUENCE; Schema: indoc_vre; Owner: indoc_vre
--

CREATE SEQUENCE IF NOT EXISTS indoc_vre.archive_preview_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE indoc_vre.archive_preview_id_seq OWNER TO indoc_vre;

--
-- Name: archive_preview_id_seq; Type: SEQUENCE OWNED BY; Schema: indoc_vre; Owner: indoc_vre
--

ALTER SEQUENCE indoc_vre.archive_preview_id_seq OWNED BY indoc_vre.archive_preview.id;


--
-- Name: bids_results; Type: TABLE; Schema: indoc_vre; Owner: indoc_vre
--

CREATE TABLE IF NOT EXISTS indoc_vre.bids_results (
    id integer NOT NULL,
    dataset_geid character varying(50) NOT NULL,
    created_time timestamp without time zone NOT NULL,
    updated_time timestamp without time zone NOT NULL,
    validate_output json
);


ALTER TABLE indoc_vre.bids_results OWNER TO indoc_vre;

--
-- Name: bids_results_id_seq; Type: SEQUENCE; Schema: indoc_vre; Owner: indoc_vre
--

CREATE SEQUENCE IF NOT EXISTS  indoc_vre.bids_results_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE indoc_vre.bids_results_id_seq OWNER TO indoc_vre;

--
-- Name: bids_results_id_seq; Type: SEQUENCE OWNED BY; Schema: indoc_vre; Owner: indoc_vre
--

ALTER SEQUENCE indoc_vre.bids_results_id_seq OWNED BY indoc_vre.bids_results.id;


--
-- Name: casbin_rule; Type: TABLE; Schema: indoc_vre; Owner: indoc_vre
--

CREATE TABLE IF NOT EXISTS  indoc_vre.casbin_rule (
    id integer NOT NULL,
    ptype character varying(255),
    v0 character varying(255),
    v1 character varying(255),
    v2 character varying(255),
    v3 character varying(255),
    v4 character varying(255),
    v5 character varying(255)
);


ALTER TABLE indoc_vre.casbin_rule OWNER TO indoc_vre;

--
-- Name: casbin_rule_id_seq; Type: SEQUENCE; Schema: indoc_vre; Owner: indoc_vre
--

CREATE SEQUENCE IF NOT EXISTS  indoc_vre.casbin_rule_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE indoc_vre.casbin_rule_id_seq OWNER TO indoc_vre;

--
-- Name: casbin_rule_id_seq; Type: SEQUENCE OWNED BY; Schema: indoc_vre; Owner: indoc_vre
--

ALTER SEQUENCE indoc_vre.casbin_rule_id_seq OWNED BY indoc_vre.casbin_rule.id;


--
-- Name: data_attribute; Type: TABLE; Schema: indoc_vre; Owner: indoc_vre
--

CREATE TABLE IF NOT EXISTS  indoc_vre.data_attribute (
    id integer NOT NULL,
    manifest_id integer,
    name character varying,
    type indoc_vre.typeenum NOT NULL,
    value character varying,
    project_code character varying,
    optional boolean
);


ALTER TABLE indoc_vre.data_attribute OWNER TO indoc_vre;

--
-- Name: data_attribute_id_seq; Type: SEQUENCE; Schema: indoc_vre; Owner: indoc_vre
--

CREATE SEQUENCE IF NOT EXISTS indoc_vre.data_attribute_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE indoc_vre.data_attribute_id_seq OWNER TO indoc_vre;

--
-- Name: data_attribute_id_seq; Type: SEQUENCE OWNED BY; Schema: indoc_vre; Owner: indoc_vre
--

ALTER SEQUENCE indoc_vre.data_attribute_id_seq OWNED BY indoc_vre.data_attribute.id;


--
-- Name: data_manifest; Type: TABLE; Schema: indoc_vre; Owner: indoc_vre
--

CREATE TABLE IF NOT EXISTS indoc_vre.data_manifest (
    id integer NOT NULL,
    name character varying,
    project_code character varying
);


ALTER TABLE indoc_vre.data_manifest OWNER TO indoc_vre;

--
-- Name: data_manifest_id_seq; Type: SEQUENCE; Schema: indoc_vre; Owner: indoc_vre
--

CREATE SEQUENCE IF NOT EXISTS  indoc_vre.data_manifest_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE indoc_vre.data_manifest_id_seq OWNER TO indoc_vre;

--
-- Name: data_manifest_id_seq; Type: SEQUENCE OWNED BY; Schema: indoc_vre; Owner: indoc_vre
--

ALTER SEQUENCE indoc_vre.data_manifest_id_seq OWNED BY indoc_vre.data_manifest.id;


--
-- Name: dataset_schema; Type: TABLE; Schema: indoc_vre; Owner: indoc_vre
--

CREATE TABLE IF NOT EXISTS indoc_vre.dataset_schema (
    geid character varying NOT NULL,
    name character varying,
    dataset_geid character varying,
    tpl_geid character varying,
    standard character varying,
    system_defined boolean,
    is_draft boolean,
    content jsonb,
    create_timestamp timestamp without time zone,
    update_timestamp timestamp without time zone,
    creator character varying
);


ALTER TABLE indoc_vre.dataset_schema OWNER TO indoc_vre;

--
-- Name: dataset_schema_template; Type: TABLE; Schema: indoc_vre; Owner: indoc_vre
--

CREATE TABLE IF NOT EXISTS  indoc_vre.dataset_schema_template (
    geid character varying NOT NULL,
    name character varying,
    dataset_geid character varying,
    standard character varying,
    system_defined boolean,
    is_draft boolean,
    content jsonb,
    create_timestamp timestamp without time zone,
    update_timestamp timestamp without time zone,
    creator character varying
);


ALTER TABLE indoc_vre.dataset_schema_template OWNER TO indoc_vre;

--
-- Name: dataset_version; Type: TABLE; Schema: indoc_vre; Owner: indoc_vre
--

CREATE TABLE IF NOT EXISTS indoc_vre.dataset_version (
    id integer NOT NULL,
    dataset_code character varying,
    dataset_geid character varying,
    version character varying,
    created_by character varying,
    created_at timestamp without time zone,
    location character varying,
    notes character varying
);


ALTER TABLE indoc_vre.dataset_version OWNER TO indoc_vre;

--
-- Name: dataset_version_id_seq; Type: SEQUENCE; Schema: indoc_vre; Owner: indoc_vre
--

CREATE SEQUENCE  IF NOT EXISTS indoc_vre.dataset_version_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE indoc_vre.dataset_version_id_seq OWNER TO indoc_vre;

--
-- Name: dataset_version_id_seq; Type: SEQUENCE OWNED BY; Schema: indoc_vre; Owner: indoc_vre
--

ALTER SEQUENCE indoc_vre.dataset_version_id_seq OWNED BY indoc_vre.dataset_version.id;


--
-- Name: resource_request; Type: TABLE; Schema: indoc_vre; Owner: indoc_vre
--

CREATE TABLE IF NOT EXISTS indoc_vre.resource_request (
    id integer NOT NULL,
    user_geid character varying,
    username character varying,
    email character varying,
    project_geid character varying,
    project_name character varying,
    request_date timestamp without time zone,
    request_for character varying,
    active boolean,
    complete_date timestamp without time zone
);


ALTER TABLE indoc_vre.resource_request OWNER TO indoc_vre;

--
-- Name: resource_request_id_seq; Type: SEQUENCE; Schema: indoc_vre; Owner: indoc_vre
--

CREATE SEQUENCE IF NOT EXISTS indoc_vre.resource_request_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE indoc_vre.resource_request_id_seq OWNER TO indoc_vre;

--
-- Name: resource_request_id_seq; Type: SEQUENCE OWNED BY; Schema: indoc_vre; Owner: indoc_vre
--

ALTER SEQUENCE indoc_vre.resource_request_id_seq OWNED BY indoc_vre.resource_request.id;


--
-- Name: system_metrics; Type: TABLE; Schema: indoc_vre; Owner: indoc_vre
--

CREATE TABLE IF NOT EXISTS indoc_vre.system_metrics (
    id integer NOT NULL,
    active_user integer,
    project integer,
    storage integer,
    vm integer,
    cores integer,
    ram integer,
    date timestamp with time zone
);


ALTER TABLE indoc_vre.system_metrics OWNER TO indoc_vre;

--
-- Name: system_metrics_id_seq; Type: SEQUENCE; Schema: indoc_vre; Owner: indoc_vre
--

CREATE SEQUENCE IF NOT EXISTS indoc_vre.system_metrics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE indoc_vre.system_metrics_id_seq OWNER TO indoc_vre;

--
-- Name: system_metrics_id_seq; Type: SEQUENCE OWNED BY; Schema: indoc_vre; Owner: indoc_vre
--

ALTER SEQUENCE indoc_vre.system_metrics_id_seq OWNED BY indoc_vre.system_metrics.id;


--
-- Name: user_invitation; Type: TABLE; Schema: indoc_vre; Owner: indoc_vre
--

CREATE TABLE IF NOT EXISTS indoc_vre.user_invitation (
    invitation_code text,
    invitation_detail text,
    expiry_timestamp timestamp without time zone NOT NULL,
    create_timestamp timestamp without time zone NOT NULL,
    invited_by text,
    email text,
    role text,
    project text,
    id integer NOT NULL,
    status text
);


ALTER TABLE indoc_vre.user_invitation OWNER TO indoc_vre;

--
-- Name: user_invitation_id_seq; Type: SEQUENCE; Schema: indoc_vre; Owner: indoc_vre
--

CREATE SEQUENCE IF NOT EXISTS indoc_vre.user_invitation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE indoc_vre.user_invitation_id_seq OWNER TO indoc_vre;

--
-- Name: user_invitation_id_seq; Type: SEQUENCE OWNED BY; Schema: indoc_vre; Owner: indoc_vre
--

ALTER SEQUENCE indoc_vre.user_invitation_id_seq OWNED BY indoc_vre.user_invitation.id;


--
-- Name: user_key; Type: TABLE; Schema: indoc_vre; Owner: indoc_vre
--

CREATE TABLE IF NOT EXISTS indoc_vre.user_key (
    id integer NOT NULL,
    user_geid character varying,
    public_key character varying,
    key_name character varying,
    is_sandboxed boolean,
    created_at timestamp without time zone
);


ALTER TABLE indoc_vre.user_key OWNER TO indoc_vre;

--
-- Name: user_key_id_seq; Type: SEQUENCE; Schema: indoc_vre; Owner: indoc_vre
--

CREATE SEQUENCE IF NOT EXISTS indoc_vre.user_key_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE indoc_vre.user_key_id_seq OWNER TO indoc_vre;

--
-- Name: user_key_id_seq; Type: SEQUENCE OWNED BY; Schema: indoc_vre; Owner: indoc_vre
--

ALTER SEQUENCE indoc_vre.user_key_id_seq OWNED BY indoc_vre.user_key.id;


--
-- Name: user_password_reset; Type: TABLE; Schema: indoc_vre; Owner: indoc_vre
--

CREATE TABLE IF NOT EXISTS indoc_vre.user_password_reset (
    reset_token text,
    email text,
    expiry_timestamp timestamp without time zone NOT NULL
);


ALTER TABLE indoc_vre.user_password_reset OWNER TO indoc_vre;

--
-- Name: workbench_resource; Type: TABLE; Schema: indoc_vre; Owner: indoc_vre
--

CREATE TABLE IF NOT EXISTS indoc_vre.workbench_resource (
    id integer NOT NULL,
    geid character varying,
    project_code character varying,
    workbench_resource character varying,
    deployed boolean,
    deployed_date timestamp without time zone,
    deployed_by character varying
);


ALTER TABLE indoc_vre.workbench_resource OWNER TO indoc_vre;

--
-- Name: workbench_resource_id_seq; Type: SEQUENCE; Schema: indoc_vre; Owner: indoc_vre
--

CREATE SEQUENCE IF NOT EXISTS indoc_vre.workbench_resource_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE indoc_vre.workbench_resource_id_seq OWNER TO indoc_vre;

--
-- Name: workbench_resource_id_seq; Type: SEQUENCE OWNED BY; Schema: indoc_vre; Owner: indoc_vre
--

ALTER SEQUENCE indoc_vre.workbench_resource_id_seq OWNED BY indoc_vre.workbench_resource.id;


--
-- Name: id; Type: DEFAULT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.announcement ALTER COLUMN id SET DEFAULT nextval('indoc_vre.announcement_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.archive_preview ALTER COLUMN id SET DEFAULT nextval('indoc_vre.archive_preview_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.bids_results ALTER COLUMN id SET DEFAULT nextval('indoc_vre.bids_results_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.casbin_rule ALTER COLUMN id SET DEFAULT nextval('indoc_vre.casbin_rule_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.data_attribute ALTER COLUMN id SET DEFAULT nextval('indoc_vre.data_attribute_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.data_manifest ALTER COLUMN id SET DEFAULT nextval('indoc_vre.data_manifest_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.dataset_version ALTER COLUMN id SET DEFAULT nextval('indoc_vre.dataset_version_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.resource_request ALTER COLUMN id SET DEFAULT nextval('indoc_vre.resource_request_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.system_metrics ALTER COLUMN id SET DEFAULT nextval('indoc_vre.system_metrics_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.user_invitation ALTER COLUMN id SET DEFAULT nextval('indoc_vre.user_invitation_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.user_key ALTER COLUMN id SET DEFAULT nextval('indoc_vre.user_key_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.workbench_resource ALTER COLUMN id SET DEFAULT nextval('indoc_vre.workbench_resource_id_seq'::regclass);


--
-- Name: announcement_pkey; Type: CONSTRAINT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.announcement
    ADD CONSTRAINT announcement_pkey PRIMARY KEY (id);


--
-- Name: approval_entity_pkey; Type: CONSTRAINT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.approval_entity
    ADD CONSTRAINT approval_entity_pkey PRIMARY KEY (id);


--
-- Name: approval_request_pkey; Type: CONSTRAINT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.approval_request
    ADD CONSTRAINT approval_request_pkey PRIMARY KEY (id);


--
-- Name: archive_preview_pkey; Type: CONSTRAINT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.archive_preview
    ADD CONSTRAINT archive_preview_pkey PRIMARY KEY (id);


--
-- Name: bids_results_pkey; Type: CONSTRAINT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.bids_results
    ADD CONSTRAINT bids_results_pkey PRIMARY KEY (id);


--
-- Name: casbin_rule_pkey; Type: CONSTRAINT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.casbin_rule
    ADD CONSTRAINT casbin_rule_pkey PRIMARY KEY (id);


--
-- Name: data_attribute_pkey; Type: CONSTRAINT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.data_attribute
    ADD CONSTRAINT data_attribute_pkey PRIMARY KEY (id);


--
-- Name: data_manifest_pkey; Type: CONSTRAINT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.data_manifest
    ADD CONSTRAINT data_manifest_pkey PRIMARY KEY (id);


--
-- Name: dataset_schema_pkey; Type: CONSTRAINT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.dataset_schema
    ADD CONSTRAINT dataset_schema_pkey PRIMARY KEY (geid);


--
-- Name: dataset_schema_template_pkey; Type: CONSTRAINT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.dataset_schema_template
    ADD CONSTRAINT dataset_schema_template_pkey PRIMARY KEY (geid);


--
-- Name: dataset_version_pkey; Type: CONSTRAINT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.dataset_version
    ADD CONSTRAINT dataset_version_pkey PRIMARY KEY (id);


--
-- Name: project_code_version; Type: CONSTRAINT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.announcement
    ADD CONSTRAINT project_code_version UNIQUE (project_code, version);


--
-- Name: resource_request_pkey; Type: CONSTRAINT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.resource_request
    ADD CONSTRAINT resource_request_pkey PRIMARY KEY (id);


--
-- Name: system_metrics_pkey; Type: CONSTRAINT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.system_metrics
    ADD CONSTRAINT system_metrics_pkey PRIMARY KEY (id);


--
-- Name: unique_key; Type: CONSTRAINT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.user_key
    ADD CONSTRAINT unique_key UNIQUE (key_name, user_geid, is_sandboxed);


--
-- Name: user_invitation_pkey; Type: CONSTRAINT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.user_invitation
    ADD CONSTRAINT user_invitation_pkey PRIMARY KEY (id);


--
-- Name: user_key_pkey; Type: CONSTRAINT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.user_key
    ADD CONSTRAINT user_key_pkey PRIMARY KEY (id);


--
-- Name: workbench_resource_pkey; Type: CONSTRAINT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.workbench_resource
    ADD CONSTRAINT workbench_resource_pkey PRIMARY KEY (id);


--
-- Name: approval_entity_request_id_fkey; Type: FK CONSTRAINT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.approval_entity
    ADD CONSTRAINT approval_entity_request_id_fkey FOREIGN KEY (request_id) REFERENCES indoc_vre.approval_request(id);


--
-- Name: data_attribute_manifest_id_fkey; Type: FK CONSTRAINT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.data_attribute
    ADD CONSTRAINT data_attribute_manifest_id_fkey FOREIGN KEY (manifest_id) REFERENCES indoc_vre.data_manifest(id);


--
-- Name: dataset_schema_tpl_geid_fkey; Type: FK CONSTRAINT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.dataset_schema
    ADD CONSTRAINT dataset_schema_tpl_geid_fkey FOREIGN KEY (tpl_geid) REFERENCES indoc_vre.dataset_schema_template(geid);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: indoc_vre
--

--REVOKE ALL ON SCHEMA public FROM PUBLIC;
--REVOKE ALL ON SCHEMA public FROM indoc_vre;
GRANT ALL ON SCHEMA public TO indoc_vre;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--


--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.23
-- Dumped by pg_dump version 9.5.23

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: casbin_rule; Type: TABLE; Schema: indoc_vre; Owner: indoc_vre
--

CREATE TABLE IF NOT EXISTS indoc_vre.casbin_rule (
    id integer NOT NULL,
    ptype character varying(255),
    v0 character varying(255),
    v1 character varying(255),
    v2 character varying(255),
    v3 character varying(255),
    v4 character varying(255),
    v5 character varying(255)
);


ALTER TABLE indoc_vre.casbin_rule OWNER TO indoc_vre;

--
-- Name: casbin_rule_id_seq; Type: SEQUENCE; Schema: indoc_vre; Owner: indoc_vre
--

CREATE SEQUENCE IF NOT EXISTS indoc_vre.casbin_rule_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE indoc_vre.casbin_rule_id_seq OWNER TO indoc_vre;

--
-- Name: casbin_rule_id_seq; Type: SEQUENCE OWNED BY; Schema: indoc_vre; Owner: indoc_vre
--

ALTER SEQUENCE indoc_vre.casbin_rule_id_seq OWNED BY indoc_vre.casbin_rule.id;


--
-- Name: id; Type: DEFAULT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.casbin_rule ALTER COLUMN id SET DEFAULT nextval('indoc_vre.casbin_rule_id_seq'::regclass);


--
-- Data for Name: casbin_rule; Type: TABLE DATA; Schema: indoc_vre; Owner: indoc_vre
--

COPY indoc_vre.casbin_rule (id, ptype, v0, v1, v2, v3, v4, v5) FROM stdin;
1	p	admin	*	file	view	\N	\N
2	p	admin	*	file	delete	\N	\N
3	p	admin	*	file	upload	\N	\N
4	p	admin	*	file	download	\N	\N
5	p	admin	*	file	copy	\N	\N
6	p	collaborator	*	file	view	\N	\N
7	p	collaborator	*	file	delete	\N	\N
8	p	collaborator	*	file	upload	\N	\N
9	p	collaborator	*	file	download	\N	\N
10	p	contributor	greenroom	file	view	\N	\N
11	p	contributor	greenroom	file	delete	\N	\N
12	p	contributor	greenroom	file	upload	\N	\N
13	p	contributor	greenroom	file	download	\N	\N
14	p	admin	*	announcement	view	\N	\N
15	p	admin	*	announcement	create	\N	\N
16	p	contributor	*	announcement	view	\N	\N
17	p	collaborator	*	announcement	view	\N	\N
18	p	admin	*	file_attribute_template	view	\N	\N
19	p	admin	*	file_attribute_template	create	\N	\N
20	p	admin	*	file_attribute_template	update	\N	\N
21	p	admin	*	file_attribute_template	delete	\N	\N
22	p	admin	*	file_attribute_template	import	\N	\N
23	p	admin	*	file_attribute_template	export	\N	\N
24	p	admin	*	file_attribute_template	attach	\N	\N
25	p	contributor	*	file_attribute_template	view	\N	\N
26	p	collaborator	*	file_attribute_template	create	\N	\N
27	p	collaborator	*	file_attribute_template	update	\N	\N
28	p	collaborator	*	file_attribute_template	delete	\N	\N
29	p	collaborator	*	file_attribute_template	attach	\N	\N
30	p	admin	*	file_attribute	view	\N	\N
31	p	admin	*	file_attribute	create	\N	\N
32	p	admin	*	file_attribute	update	\N	\N
33	p	admin	*	file_attribute	delete	\N	\N
34	p	collaborator	*	file_attribute	view	\N	\N
35	p	collaborator	*	file_attribute	update	\N	\N
36	p	collaborator	*	file_attribute	delete	\N	\N
37	p	admin	*	tags	view	\N	\N
38	p	admin	*	tags	create	\N	\N
39	p	admin	*	tags	update	\N	\N
40	p	admin	*	tags	delete	\N	\N
41	p	contributor	greenroom	tags	view	\N	\N
42	p	contributor	greenroom	tags	create	\N	\N
43	p	contributor	greenroom	tags	update	\N	\N
44	p	contributor	greenroom	tags	delete	\N	\N
45	p	collaborator	*	tags	view	\N	\N
46	p	collaborator	*	tags	create	\N	\N
47	p	collaborator	*	tags	update	\N	\N
48	p	collaborator	*	tags	delete	\N	\N
49	p	admin	*	resource_request	create	\N	\N
50	p	collaborator	*	resource_request	create	\N	\N
51	p	platform_admin	*	resource_request	view	\N	\N
52	p	platform_admin	*	resource_request	update	\N	\N
53	p	platform_admin	*	resource_request	delete	\N	\N
54	p	admin	*	workbench	view	\N	\N
55	p	contributor	*	workbench	view	\N	\N
56	p	collaborator	*	workbench	view	\N	\N
57	p	platform_admin	*	workbench	create	\N	\N
58	p	admin	*	file_stats	view	\N	\N
59	p	contributor	*	file_stats	view	\N	\N
60	p	collaborator	*	file_stats	view	\N	\N
61	p	admin	*	audit_logs	view	\N	\N
62	p	contributor	*	audit_logs	view	\N	\N
63	p	collaborator	*	audit_logs	view	\N	\N
64	p	admin	*	lineage	view	\N	\N
65	p	contributor	greenroom	lineage	view	\N	\N
66	p	admin	*	invite	view	\N	\N
67	p	admin	*	invite	create	\N	\N
68	p	admin	*	project	view	\N	\N
69	p	admin	*	project	update	\N	\N
70	p	contributor	*	project	view	\N	\N
71	p	collaborator	*	project	view	\N	\N
72	p	platform_admin	*	project	create	\N	\N
73	p	admin	*	tasks	view	\N	\N
74	p	admin	*	tasks	delete	\N	\N
75	p	contributor	*	tasks	view	\N	\N
76	p	contributor	*	tasks	delete	\N	\N
77	p	collaborator	*	tasks	view	\N	\N
78	p	collaborator	*	tasks	delete	\N	\N
79	p	admin	*	users	view	\N	\N
80	p	platform_admin	*	notification	create	\N	\N
85	p	collaborator	*	lineage	view	\N	\N
86	p	contributor	greenroom	file_attribute	view	\N	\N
87	p	contributor	greenroom	file_attribute_template	attach	\N	\N
92	p	contributor	greenroom	file_attribute	update	\N	\N
94	p	collaborator	*	file_attribute_template	view	\N	\N
95	p	admin	*	copyrequest	view	\N	\N
96	p	admin	*	copyrequest	update	\N	\N
97	p	collaborator	*	copyrequest	create	\N	\N
98	p	collaborator	*	copyrequest	view	\N	\N
81	p	admin	core	collections	view	\N	\N
82	p	admin	core	collections	create	\N	\N
83	p	admin	core	collections	update	\N	\N
84	p	admin	core	collections	delete	\N	\N
88	p	collaborator	core	collections	view	\N	\N
89	p	collaborator	core	collections	create	\N	\N
90	p	collaborator	core	collections	update	\N	\N
91	p	collaborator	core	collections	delete	\N	\N
93	p	contributor	core	collections	view	\N	\N
\.


--
-- Name: casbin_rule_id_seq; Type: SEQUENCE SET; Schema: indoc_vre; Owner: indoc_vre
--

SELECT pg_catalog.setval('indoc_vre.casbin_rule_id_seq', 98, true);


--
-- Name: casbin_rule_pkey; Type: CONSTRAINT; Schema: indoc_vre; Owner: indoc_vre
--

ALTER TABLE ONLY indoc_vre.casbin_rule
    ADD CONSTRAINT casbin_rule_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--