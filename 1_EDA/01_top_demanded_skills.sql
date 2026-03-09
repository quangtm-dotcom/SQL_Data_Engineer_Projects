/*
   - Top 10 kỹ năng data engineers được yêu cầu nhiều nhất
   - Tập trung vào các vị trí việc làm từ xa hoặc tại VIệt Nam
*/

SELECT
    sd.skills AS ky_nang_yeu_cau_nhieu_nhat,
    COUNT(sd.skills) AS so_luong_yeu_cau
FROM
    job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
WHERE
    (jpf.job_work_from_home = True
    OR jpf.job_country = 'Vietnam')
    AND jpf.job_title_short = 'Data Engineer'
GROUP BY 
    sd.skills
ORDER BY
    COUNT(sd.skills) DESC
LIMIT 10;

/*
┌────────────────────────────┬──────────────────┐
│ ky_nang_yeu_cau_nhieu_nhat │ so_luong_yeu_cau │
│          varchar           │      int64       │
├────────────────────────────┼──────────────────┤
│ sql                        │            30240 │
│ python                     │            29721 │
│ aws                        │            18371 │
│ azure                      │            14497 │
│ spark                      │            13360 │
│ airflow                    │            10318 │
│ snowflake                  │             8732 │
│ databricks                 │             8362 │
│ java                       │             7678 │
│ kafka                      │             6789 │
├────────────────────────────┴──────────────────┤
│ 10 rows                             2 columns │
└───────────────────────────────────────────────┘
*/