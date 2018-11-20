CREATE TABLE public.organizations (
	id	BIGSERIAL PRIMARY KEY,
	name	varchar(256) NOT NULL,
	CONSTRAINT organization_name_unique UNIQUE (name )
);

CREATE TABLE public.users (
	id	BIGSERIAL PRIMARY KEY,
	password	varchar(128),
	name	varchar(256) NOT NULL,
	email	varchar(256) NOT NULL,
	role	integer NOT NULL,
	phone	varchar(16),
	organization_id	integer REFERENCES organizations,
	refresh_token	varchar(256),
	reset_password_token	varchar(256),
	reset_password_expire	integer,
	image_path 	varchar(256) NOT NULL DEFAULT 'uploads/default_profile.png',
	CONSTRAINT email_unique UNIQUE (email)
);

CREATE TABLE public.groups (
	id	BIGSERIAL PRIMARY KEY,
	name	varchar(256) NOT NULL,
	owner_id	integer REFERENCES users
);

CREATE TABLE public.tags (
	id	BIGSERIAL PRIMARY KEY,
	name	varchar(256) NOT NULL,
    CONSTRAINT tag_name_unique UNIQUE (name)
);

CREATE TABLE public.users_groups_map (
	id	BIGSERIAL PRIMARY KEY,
	user_id integer REFERENCES users ON DELETE CASCADE,
	group_id integer REFERENCES groups ON DELETE CASCADE
);

CREATE TABLE public.documents (
	id BIGSERIAL PRIMARY KEY,
	type character varying(255),
	status integer DEFAULT 0,  -- 0 = in_progress by default
	owner_id integer REFERENCES users,
	organization_id	integer REFERENCES organizations,
	title character varying(512),
	gold_master boolean NOT NULL DEFAULT false,
	template boolean NOT NULL DEFAULT false,
	checkout boolean NOT NULL DEFAULT false,
	last_modified timestamp with time zone NOT NULL DEFAULT NOW(),
    checkout_id integer REFERENCES users,
);

CREATE TABLE public.documents_data (
	id BIGSERIAL PRIMARY KEY,
	document_id integer REFERENCES documents ON DELETE CASCADE,
	document_data jsonb,
	CONSTRAINT unique_documents_data_document_id UNIQUE (document_id)	
);

CREATE TABLE public.comments (
	id BIGSERIAL PRIMARY KEY,
	document_id integer REFERENCES documents ON DELETE CASCADE,
	comment_data jsonb,
	CONSTRAINT unique_comments_document_id UNIQUE (document_id)
);

CREATE TABLE public.documents_groups_map (
	id	BIGSERIAL PRIMARY KEY,
	document_id	integer REFERENCES documents ON DELETE CASCADE,
	group_id	integer REFERENCES groups ON DELETE CASCADE
);

ALTER TABLE ONLY public.documents_groups_map
    ADD CONSTRAINT documents_groups_unique UNIQUE (document_id, group_id);

ALTER TABLE ONLY public.users_groups_map
    ADD CONSTRAINT users_groups_unique UNIQUE (group_id, user_id);
    

CREATE TABLE public.buckets (
	id	BIGSERIAL PRIMARY KEY,
	name	varchar(256) NOT NULL,
    CONSTRAINT bucket_name_unique UNIQUE (name)
);

CREATE TABLE public.documents_buckets_map (
	id	BIGSERIAL PRIMARY KEY,
	document_id	integer REFERENCES documents ON DELETE CASCADE,
	bucket_id	integer REFERENCES buckets ON DELETE CASCADE
);

ALTER TABLE ONLY public.documents_buckets_map
    ADD CONSTRAINT documents_buckets_map_unique UNIQUE (document_id, bucket_id);



CREATE TABLE public.documents_tags_map (
	id	BIGSERIAL PRIMARY KEY,
	document_id	integer REFERENCES documents ON DELETE CASCADE,
	tag_id	integer REFERENCES tags ON DELETE CASCADE
);
ALTER TABLE ONLY public.documents_tags_map
    ADD CONSTRAINT documents_tags_map_unique UNIQUE (document_id, tag_id);


CREATE TABLE public.documents_users_map (
	id	BIGSERIAL PRIMARY KEY,
	document_id	integer REFERENCES documents ON DELETE CASCADE,
	user_id	integer REFERENCES users ON DELETE CASCADE
);
ALTER TABLE ONLY public.documents_users_map
    ADD CONSTRAINT documents_users_map_unique UNIQUE (document_id, user_id);

