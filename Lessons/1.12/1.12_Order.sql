/* Top 10 công ty hàng đầu đăng tuyển dụng.
    Họ phải có hơn 3000 việc làm
    Giới hạn các công việc ở Mỹ  
*/

EXPLAIN ANALYZE
SELECT 
    cd.name AS company_name,
    COUNT(job_id) AS NUMBER_JOB
FROM job_postings_fact AS jpf
LEFT JOIN company_dim AS cd  
    ON jpf.company_id = cd.company_id
WHERE 
    jpf.job_country = 'United States'
GROUP BY 
    cd.name
HAVING COUNT(job_title_short) > 3000
ORDER BY
    COUNT(job_id) DESC
LIMIT 10;