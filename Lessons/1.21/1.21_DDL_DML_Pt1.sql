CREATE DATABASE IF NOT EXISTS jobs_mart;

SHOW DATABASES;

DROP DATABASE IF EXISTS jobs_mart;

SELECT *
FROM information_schema.schemata;

USE jobs_mart;

CREATE SCHEMA IF NOT EXISTS jobs_mart.staging;

DROP SCHEMA IF EXISTS jobs_mart.staging;

CREATE TABLE IF NOT EXISTS staging.preferred_roles (
    role_id INTEGER PRIMARY KEY,
    role_name VARCHAR
);

SELECT *
FROM information_schema.tables
WHERE table_catalog = 'jobs_mart';

DROP TABLE IF EXISTS main.preferred_roles;

INSERT INTO jobs_mart.staging.preferred_roles (role_id, role_name)
VALUES 
    (1, 'Data Engineer'),
    (2, 'Senior Data Engineer'),
    (3, 'Software Engineer');

SELECT *
FROM jobs_mart.staging.preferred_roles;

SELECT *
FROM jobs_mart.staging.priority_roles;

ALTER TABLE jobs_mart.staging.preferred_roles
ADD COLUMN preferred_roles BOOLEAN;

ALTER TABLE jobs_mart.staging.preferred_roles
DROP COLUMN preferred_roles;

UPDATE jobs_mart.staging.preferred_roles
SET preferred_roles = TRUE
WHERE role_name = 'Senior Data Engineer';

ALTER TABLE jobs_mart.staging.preferred_roles
RENAME TO priority_roles;

ALTER TABLE jobs_mart.staging.priority_roles
RENAME COLUMN priority_role TO priority_lvl;

ALTER TABLE jobs_mart.staging.priority_roles
ALTER COLUMN priority_lvl TYPE INTEGER;

UPDATE staging.priority_roles
SET priority_lvl = 1
WHERE role_name = 'Data Engineer';

UPDATE staging.priority_roles
SET priority_lvl = 1
WHERE role_name = 'Senior Data Engineer';

INSERT INTO jobs_mart.staging.priority_roles (role_id, role_name, priority_lvl)
VALUES
    (3,'Software Engineer', 3);