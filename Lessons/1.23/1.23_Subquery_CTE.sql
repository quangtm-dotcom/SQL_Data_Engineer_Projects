-- Subquery
SELECT *
FROM (
    SELECT *
    FROM data_jobs.job_postings_fact
    WHERE 
        salary_year_avg IS NOT NULL
        OR salary_hour_avg IS NOT NULL
)
LIMIT 10;

-- CTE
WITH valid_salaries AS (
    SELECT *
    FROM data_jobs.job_postings_fact
    WHERE 
        salary_year_avg IS NOT NULL
        OR salary_hour_avg IS NOT NULL
)
SELECT *
FROM valid_salaries;

-- Scenario 1: - Subquery in `SELECT`\
-- Hiển thị ra các công việc có mức lương trung vị trên thị trường
SELECT
    job_title_short,
    salary_year_avg,
    (
        SELECT MEDIAN(salary_year_avg)
        FROM data_jobs.job_postings_fact
    ) AS market_median_salary
FROM data_jobs.job_postings_fact
WHERE salary_year_avg IS NOT NULL
LIMIT 10;

--Scennario 2: - Subquery in `HAVING`
-- Giai đoạn chỉ các công việc được thực hiện từ xa trước khi tổng hợp
SELECT
    job_title_short,
    MEDIAN(salary_year_avg) AS median_salary,
    (
        SELECT MEDIAN(salary_year_avg)
        FROM data_jobs.job_postings_fact
        WHERE job_work_from_home = TRUE
    ) AS market_median_salary
FROM (
    SELECT 
        job_title_short,
        salary_year_avg
    FROM data_jobs.job_postings_fact
    WHERE job_work_from_home = TRUE
) AS clean_jobs
GROUP BY job_title_short
LIMIT 10;

-- Scenario 3 - Subquery in `HAVING
-- Chỉ giữ chức danh công việc với mức lương trung vị cao hơn mức tring vị tổng thể
SELECT
    job_title_short,
    MEDIAN(salary_year_avg) AS median_salary,
    (
        SELECT MEDIAN(salary_year_avg)
        FROM data_jobs.job_postings_fact
        WHERE job_work_from_home = TRUE
    ) AS market_median_salary
FROM (
    SELECT 
        job_title_short,
        salary_year_avg
    FROM data_jobs.job_postings_fact
    WHERE job_work_from_home = TRUE
) AS clean_jobs
GROUP BY job_title_short
HAVING median_salary > market_median_salary
LIMIT 10;

-- Ví dụ CTE
-- So sánh xem công việc làm từ xa trả lương cao hay thấp hơn bao nhiêu so với các công việc làm thêm
WITH title_median AS (
    SELECT
        job_title_short,
        job_work_from_home,
        MEDIAN(salary_year_avg)::INT AS median_salary
    FROM data_jobs.job_postings_fact
    WHERE job_country = 'United States'
    GROUP BY
        job_title_short,
        job_work_from_home
)

SELECT
    r.job_title_short,
    r.median_salary AS remote_median_salary,
    o.median_salary AS onsite_median_salary,
    (remote_median_salary - onsite_median_salary) AS remote_premium
FROM title_median AS r
INNER JOIN title_median AS o
    ON r.job_title_short = o.job_title_short
WHERE r.job_work_from_home = TRUE
    AND o.job_work_from_home = FALSE
ORDER BY remote_premium DESC;

SELECT * FROM range(3) AS src(key);
SELECT * FROM range(2) AS tgt(key);

SELECT *
FROM range(3) AS src(key)
WHERE NOT EXISTS (
    SELECT 1
    FROM range(2) AS tgt(key)
    WHERE src.key = tgt.key
);

-- Xác định những kỹ năng không có liên kết nào trước khi được tải vào data mart

SELECT *
FROM data_jobs.job_postings_fact
ORDER BY job_id
LIMIT 10;

SELECT *
FROM data_jobs.skills_job_dim
ORDER BY job_id
LIMIT 40;

SELECT *
FROM data_jobs.job_postings_fact AS jpf
WHERE NOT EXISTS (
    SELECT 1
    FROM data_jobs.skills_job_dim AS sjd
    WHERE  jpf.job_id = sjd.job_id
)
ORDER BY job_id;