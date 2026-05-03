-- Array Intro
SELECT ['python', 'sql', 'r'] AS skill_array;

WITH skills AS (
    SELECT 'python' AS skill
    UNION ALL
    SELECT 'sql'
    UNION ALL
    SELECT 'r'
), skill_array AS(
    SELECT ARRAY_AGG(skill ORDER BY skill) AS skills
    FROM skills
)
SELECT
    skills[1] AS first_skills,
    skills[2] AS second_skills,
    skills[3] AS third_skills,
FROM skill_array;

-- STRUC
SELECT {skill: 'python', type: 'programming'} AS skill_struct;

WITH skill_struct AS(
    SELECT
        STRUCt_PACK(
            skill:= 'python',
            type := 'progamming'
        ) AS s
)
SELECT
    s.skill,
    s.type
FROM skill_struct;


WITH skill_table AS(
    SELECT 'python' AS skills, 'programming' AS types
    UNION ALL
    SELECT 'sql', 'query_language'
    UNION ALL
    SELECT 'r', 'programming'
)
SELECT 
    STRUCt_PACK(
        skill := skills,
        type := types
    )
FROM skill_table;

-- Array of Struct
SELECT [
    {skill: 'python', type: 'programming'},
    {skill: 'sql', type: 'query_language'}
] AS skills_array_of_structs;

WITH skill_table AS(
    SELECT 'python' AS skills, 'programming' AS types
    UNION ALL
    SELECT 'sql', 'query_language'
    UNION ALL
    SELECT 'r', 'programming'
), skill_array_struct AS(
    SELECT
        ARRAY_AGG(
            STRUCt_PACK(
                skill := skills,
                type := types
            )
        ) AS array_struct
    FROM skill_table
)
SELECT
    array_struct[1].skill 
FROM skill_array_struct;

-- MAP
WITH skill_map AS(
    SELECT MAP{'skill':'python', 'type':'programming'} AS skill_type
)
SELECT
    skill_type['type']
FROM skill_map;
    
-- JSON
WITH raw_skill_json AS(
    SELECT
        '{"skill":"python","type":"program"}'::JSON AS skill_json
)
SELECT
    STRUCt_PACK(
        skill:= json_extract_string(skill_json, '$.skill')
    ),
    skill_json
FROM raw_skill_json;

-- JSON to Array of Structs
WITH raw_json AS(
    SELECT
        '[
            {"skill":"python","type":"program"},
            {"skill":"sql","type":"query_language"},
            {"skill":"r","type":"program"}
        ]'::JSON AS skills_json
)
SELECT
    ARRAY_AGG(
        STRUCt_PACK(
            skill:= json_extract_string(e.value, '$.skill'),
            type:= json_extract_string(e.value, '$.type')
        )
        ORDER BY json_extract_string(e.value, '$.skill')
    ) AS skills
FROM raw_json, json_each(skills_json) AS e;

-- Arrays - Final Example
-- Build a flat skill table for co-workers to access job_title, salary info, and skills in one table

CREATE OR REPLACE TEMP TABLE jobs_skills_array AS
SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    ARRAY_AGG(sd.skills ORDER BY sd.skills) AS skills_array
FROM job_postings_fact AS jpf
LEFT JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
LEFT JOIN skills_dim AS sd
    ON sd.skill_id = sjd.skill_id
GROUP BY ALL;

-- Lọc đại diện data engineer, phân tích theo median salary per skill
WITH flat_skills AS(
    SELECT
        UNNEST(jsa.skills_array) AS skill,
        salary_year_avg
    FROM jobs_skills_array AS jsa 
    WHERE jsa.salary_year_avg IS NOT NULL
        AND jsa.job_title_short = 'Data Engineer'
)
SELECT 
    skill,
    MEDIAN(salary_year_avg) AS median_salary
FROM flat_skills
GROUP BY skill
ORDER BY MEDIAN(salary_year_avg) DESC
LIMIT 20;

-- Array of Structs - Final Example
-- Build a fat skill & type table for co-workers to access job titles, salary info, skills, and type in one table
DESCRIBE
SELECT * FROM data_jobs.skills_dim;

CREATE OR REPLACE TEMP TABLE jobs_skills_array_struct AS
SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    ARRAY_AGG(
        STRUCt_PACK(
            skill_name:= sd.skills,
            skill_type:= sd.type
        )
    ) AS skills_type
FROM job_postings_fact AS jpf
LEFT JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
LEFT JOIN skills_dim AS sd
    ON sd.skill_id = sjd.skill_id
GROUP BY ALL;

-- Lọc Đại diện Data Engineer, phân tích median salary per type of skill

WITH flat_type_skill AS(
    SELECT
        UNNEST(skills_type).skill_type AS skill_type,
        salary_year_avg
    FROM jobs_skills_array_struct AS jsa 
    WHERE jsa.salary_year_avg IS NOT NULL
        AND jsa.job_title_short = 'Data Engineer'
)
SELECT 
    skill_type,
    MEDIAN(salary_year_avg) AS median_salary
FROM flat_type_skill
GROUP BY skill_type
ORDER BY MEDIAN(salary_year_avg) DESC;
