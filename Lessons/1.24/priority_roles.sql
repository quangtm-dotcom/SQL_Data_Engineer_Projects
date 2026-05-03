-- Intial Load & update
-- .read D:/git/github/SQL_Data_Engineer_Project/Lessons/1.24/priority_roles.sql
CREATE OR REPLACE TABLE jobs_mart.staging.priority_roles (
    role_id INTEGER PRIMARY KEY,
    role_name VARCHAR,
    priority_lvl INTEGER
);

INSERT INTO jobs_mart.staging.priority_roles (role_id, role_name, priority_lvl)
VALUES
    (1, 'Data Engineer', 1),
    (2, 'Senior Data Engineer', 2),
    (3, 'Software Engineer', 4);
--    (4, 'Data Scientist',3);

SELECT * FROM jobs_mart.staging.priority_roles;