-- LEFT JOIN
SELECT
    job_id,
    job_title_short,
    cd.name AS company_name,
    job_location,
    salary_year_avg
FROM
    job_postings_fact AS jpf 
LEFT JOIN company_dim AS cd  
    ON jpf.company_id = cd.company_id
LIMIT 10;

--RIGHT_JOIN
SELECT
    job_id,
    job_title_short,
    cd.name AS company_name,
    job_location,
    salary_year_avg
FROM
    job_postings_fact AS jpf 
RIGHT JOIN company_dim AS cd  
    ON jpf.company_id = cd.company_id
LIMIT 10;

-- INNER JOIN
SELECT
    job_id,
    job_title_short,
    cd.name AS company_name,
    job_location,
    salary_year_avg
FROM
    job_postings_fact AS jpf 
INNER JOIN company_dim AS cd  
    ON jpf.company_id = cd.company_id
LIMIT 10;

-- FULL OUTER JOIN
SELECT
    job_id,
    job_title_short,
    cd.name AS company_name,
    job_location,
    salary_year_avg
FROM
    job_postings_fact AS jpf 
FULL OUTER JOIN company_dim AS cd  
    ON jpf.company_id = cd.company_id
LIMIT 10;

SELECT *
FROM skills_job_dim
LIMIT 10;

SELECT *
FROM skills_dim
LIMIT 10;

SELECT
    jpf.job_id,
    jpf.job_title_short,
    sd.skill_id,
    sd.skills
FROM job_postings_fact AS jpf
LEFT JOIN skills_job_dim AS sjd 
    ON jpf.job_id = sjd.job_id
LEFT JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
LIMIT 10;