--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: assignments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE assignments (
    id integer NOT NULL,
    course_id integer,
    title character varying,
    summary text,
    published boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE assignments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE assignments_id_seq OWNED BY assignments.id;


--
-- Name: courses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE courses (
    id integer NOT NULL,
    title character varying,
    start_date date,
    end_date date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    source_repository character varying
);


--
-- Name: courses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE courses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: courses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE courses_id_seq OWNED BY courses.id;


--
-- Name: covered_materials; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE covered_materials (
    id integer NOT NULL,
    course_id integer,
    material_fullpath character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    covered_on date
);


--
-- Name: covered_materials_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE covered_materials_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: covered_materials_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE covered_materials_id_seq OWNED BY covered_materials.id;


--
-- Name: enrollments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE enrollments (
    id integer NOT NULL,
    user_id integer,
    course_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: enrollments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE enrollments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: enrollments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE enrollments_id_seq OWNED BY enrollments.id;


--
-- Name: events; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE events (
    id integer NOT NULL,
    course_id integer,
    date date,
    summary character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE events_id_seq OWNED BY events.id;


--
-- Name: milestone_submissions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE milestone_submissions (
    id integer NOT NULL,
    user_id integer,
    milestone_id integer,
    repository character varying,
    status character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: milestone_submissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE milestone_submissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: milestone_submissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE milestone_submissions_id_seq OWNED BY milestone_submissions.id;


--
-- Name: milestones; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE milestones (
    id integer NOT NULL,
    assignment_id integer,
    title character varying,
    instructions text,
    deadline date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    corequisite_fullpaths text[]
);


--
-- Name: milestones_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE milestones_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: milestones_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE milestones_id_seq OWNED BY milestones.id;


--
-- Name: notes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE notes (
    id integer NOT NULL,
    content text,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    date timestamp without time zone,
    course_id integer
);


--
-- Name: notes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE notes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE notes_id_seq OWNED BY notes.id;


--
-- Name: question_answers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE question_answers (
    id integer NOT NULL,
    quiz_submission_id integer,
    question_id integer,
    answer text,
    score integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: question_answers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE question_answers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: question_answers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE question_answers_id_seq OWNED BY question_answers.id;


--
-- Name: questions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE questions (
    id integer NOT NULL,
    quiz_id integer,
    question text,
    question_type character varying,
    correct_answer text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: questions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE questions_id_seq OWNED BY questions.id;


--
-- Name: quiz_submissions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE quiz_submissions (
    id integer NOT NULL,
    user_id integer,
    quiz_id integer,
    submitted_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    graded boolean,
    grade integer
);


--
-- Name: quiz_submissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE quiz_submissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: quiz_submissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE quiz_submissions_id_seq OWNED BY quiz_submissions.id;


--
-- Name: quizzes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE quizzes (
    id integer NOT NULL,
    course_id integer,
    title character varying,
    deadline date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    published boolean,
    corequisite_fullpaths text[]
);


--
-- Name: quizzes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE quizzes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: quizzes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE quizzes_id_seq OWNED BY quizzes.id;


--
-- Name: read_materials; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE read_materials (
    id integer NOT NULL,
    user_id integer,
    material_fullpath character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: read_materials_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE read_materials_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: read_materials_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE read_materials_id_seq OWNED BY read_materials.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: self_reports; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE self_reports (
    id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    user_id integer,
    attended boolean,
    hours_coding double precision,
    hours_learning double precision,
    hours_slept double precision,
    date timestamp without time zone
);


--
-- Name: self_reports_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE self_reports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: self_reports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE self_reports_id_seq OWNED BY self_reports.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying,
    last_sign_in_ip character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    name character varying,
    phone character varying,
    github_uid character varying,
    github_username character varying,
    github_access_token character varying,
    goals text,
    background text,
    instructor boolean,
    photo_confirmed boolean DEFAULT false,
    photo character varying,
    observer boolean
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY assignments ALTER COLUMN id SET DEFAULT nextval('assignments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY courses ALTER COLUMN id SET DEFAULT nextval('courses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY covered_materials ALTER COLUMN id SET DEFAULT nextval('covered_materials_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY enrollments ALTER COLUMN id SET DEFAULT nextval('enrollments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY events ALTER COLUMN id SET DEFAULT nextval('events_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY milestone_submissions ALTER COLUMN id SET DEFAULT nextval('milestone_submissions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY milestones ALTER COLUMN id SET DEFAULT nextval('milestones_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY notes ALTER COLUMN id SET DEFAULT nextval('notes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY question_answers ALTER COLUMN id SET DEFAULT nextval('question_answers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY questions ALTER COLUMN id SET DEFAULT nextval('questions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY quiz_submissions ALTER COLUMN id SET DEFAULT nextval('quiz_submissions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY quizzes ALTER COLUMN id SET DEFAULT nextval('quizzes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY read_materials ALTER COLUMN id SET DEFAULT nextval('read_materials_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY self_reports ALTER COLUMN id SET DEFAULT nextval('self_reports_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY assignments
    ADD CONSTRAINT assignments_pkey PRIMARY KEY (id);


--
-- Name: courses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (id);


--
-- Name: covered_materials_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY covered_materials
    ADD CONSTRAINT covered_materials_pkey PRIMARY KEY (id);


--
-- Name: enrollments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY enrollments
    ADD CONSTRAINT enrollments_pkey PRIMARY KEY (id);


--
-- Name: events_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: milestone_submissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY milestone_submissions
    ADD CONSTRAINT milestone_submissions_pkey PRIMARY KEY (id);


--
-- Name: milestones_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY milestones
    ADD CONSTRAINT milestones_pkey PRIMARY KEY (id);


--
-- Name: notes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY notes
    ADD CONSTRAINT notes_pkey PRIMARY KEY (id);


--
-- Name: question_answers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY question_answers
    ADD CONSTRAINT question_answers_pkey PRIMARY KEY (id);


--
-- Name: questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (id);


--
-- Name: quiz_submissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY quiz_submissions
    ADD CONSTRAINT quiz_submissions_pkey PRIMARY KEY (id);


--
-- Name: quizzes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY quizzes
    ADD CONSTRAINT quizzes_pkey PRIMARY KEY (id);


--
-- Name: read_materials_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY read_materials
    ADD CONSTRAINT read_materials_pkey PRIMARY KEY (id);


--
-- Name: self_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY self_reports
    ADD CONSTRAINT self_reports_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_notes_on_course_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_notes_on_course_id ON notes USING btree (course_id);


--
-- Name: index_notes_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_notes_on_user_id ON notes USING btree (user_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: fk_rails_666b79e1d8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notes
    ADD CONSTRAINT fk_rails_666b79e1d8 FOREIGN KEY (course_id) REFERENCES courses(id);


--
-- Name: fk_rails_7f2323ad43; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notes
    ADD CONSTRAINT fk_rails_7f2323ad43 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20140221201129');

INSERT INTO schema_migrations (version) VALUES ('20140221210333');

INSERT INTO schema_migrations (version) VALUES ('20140221215722');

INSERT INTO schema_migrations (version) VALUES ('20140223161553');

INSERT INTO schema_migrations (version) VALUES ('20140223164436');

INSERT INTO schema_migrations (version) VALUES ('20140223175851');

INSERT INTO schema_migrations (version) VALUES ('20140318151355');

INSERT INTO schema_migrations (version) VALUES ('20140318151819');

INSERT INTO schema_migrations (version) VALUES ('20140318180908');

INSERT INTO schema_migrations (version) VALUES ('20140318182026');

INSERT INTO schema_migrations (version) VALUES ('20140319223726');

INSERT INTO schema_migrations (version) VALUES ('20140320162828');

INSERT INTO schema_migrations (version) VALUES ('20140321165121');

INSERT INTO schema_migrations (version) VALUES ('20140321165343');

INSERT INTO schema_migrations (version) VALUES ('20140321184236');

INSERT INTO schema_migrations (version) VALUES ('20140324145817');

INSERT INTO schema_migrations (version) VALUES ('20140324150027');

INSERT INTO schema_migrations (version) VALUES ('20140324150327');

INSERT INTO schema_migrations (version) VALUES ('20140324164635');

INSERT INTO schema_migrations (version) VALUES ('20140324164935');

INSERT INTO schema_migrations (version) VALUES ('20140324174241');

INSERT INTO schema_migrations (version) VALUES ('20140324210024');

INSERT INTO schema_migrations (version) VALUES ('20140324210430');

INSERT INTO schema_migrations (version) VALUES ('20140325191630');

INSERT INTO schema_migrations (version) VALUES ('20140326160455');

INSERT INTO schema_migrations (version) VALUES ('20140326173606');

INSERT INTO schema_migrations (version) VALUES ('20140327172142');

INSERT INTO schema_migrations (version) VALUES ('20140328160519');

INSERT INTO schema_migrations (version) VALUES ('20140328162250');

INSERT INTO schema_migrations (version) VALUES ('20140330000247');

INSERT INTO schema_migrations (version) VALUES ('20140330000337');

INSERT INTO schema_migrations (version) VALUES ('20140401015258');

INSERT INTO schema_migrations (version) VALUES ('20140402184035');

INSERT INTO schema_migrations (version) VALUES ('20140414192538');

INSERT INTO schema_migrations (version) VALUES ('20140417184051');

INSERT INTO schema_migrations (version) VALUES ('20140423123810');

INSERT INTO schema_migrations (version) VALUES ('20140607233822');

INSERT INTO schema_migrations (version) VALUES ('20140609151348');

INSERT INTO schema_migrations (version) VALUES ('20140609160111');

INSERT INTO schema_migrations (version) VALUES ('20140610200914');

INSERT INTO schema_migrations (version) VALUES ('20140615162813');

INSERT INTO schema_migrations (version) VALUES ('20140621162136');

INSERT INTO schema_migrations (version) VALUES ('20140621175940');

INSERT INTO schema_migrations (version) VALUES ('20140702215950');

INSERT INTO schema_migrations (version) VALUES ('20140703184009');

INSERT INTO schema_migrations (version) VALUES ('20140703184558');

INSERT INTO schema_migrations (version) VALUES ('20140802164604');

INSERT INTO schema_migrations (version) VALUES ('20151005210453');

INSERT INTO schema_migrations (version) VALUES ('20151006131415');

INSERT INTO schema_migrations (version) VALUES ('20151124164846');

INSERT INTO schema_migrations (version) VALUES ('20151201162316');

INSERT INTO schema_migrations (version) VALUES ('20151208191729');

