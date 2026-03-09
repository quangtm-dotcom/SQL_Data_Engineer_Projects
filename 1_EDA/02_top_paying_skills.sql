/*
    25 kỹ năng có thu nhập tốt nhất data engineer:
    - Tính hàm trung vị thu nhập của data engineer với mỗi skill
    - Tập trung vào các vị trí việc làm từ xa hoặc tại VIệt Nam
    - Tần suất kỹ năng được tính giữa lương và yêu cầu thực tế
*/

SELECT
    sd.skills AS ky_nang_co_thu_nhap_cao,
    MEDIAN(jpf.salary_year_avg) AS thu_nhap_theo_nam,
    COUNT(sd.skills) AS so_luong_cong_viec_yeu_cau
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
    --AND jpf.salary_year_avg IS NOT NULL
GROUP BY 
    sd.skills
Having
    COUNT(sd.skills) > 100
ORDER BY
    MEDIAN(jpf.salary_year_avg) DESC
LIMIT 25;

/*
┌─────────────────────────┬───────────────────┬────────────────────────────┐
│ ky_nang_co_thu_nhap_cao │ thu_nhap_theo_nam │ so_luong_cong_viec_yeu_cau │       
│         varchar         │      double       │           int64            │       
├─────────────────────────┼───────────────────┼────────────────────────────┤
│ rust                    │          210000.0 │                        257 │       
│ sheets                  │          196697.5 │                        105 │       
│ golang                  │          184000.0 │                        957 │       
│ terraform               │          184000.0 │                       3327 │       
│ spring                  │          175500.0 │                        396 │       
│ neo4j                   │          170000.0 │                        316 │       
│ gdpr                    │          169615.5 │                        591 │       
│ zoom                    │          168437.5 │                        127 │       
│ graphql                 │          167500.0 │                        456 │       
│ mongo                   │          162250.0 │                        278 │
│ fastapi                 │          157500.0 │                        232 │       
│ bitbucket               │          155000.0 │                        482 │       
│ django                  │          155000.0 │                        281 │       
│ crystal                 │          154223.5 │                        129 │       
│ atlassian               │          151500.0 │                        256 │       
│ c                       │          151500.0 │                        459 │       
│ typescript              │          151000.0 │                        396 │       
│ kubernetes              │          150500.0 │                       4343 │       
│ css                     │          150000.0 │                        279 │
│ ruby                    │          150000.0 │                        748 │       
│ node                    │          150000.0 │                        182 │       
│ airflow                 │          150000.0 │                      10318 │       
│ redis                   │          149000.0 │                        630 │       
│ ansible                 │         148798.25 │                        486 │       
│ vmware                  │         148798.25 │                        138 │       
├─────────────────────────┴───────────────────┴────────────────────────────┤
│ 25 rows                                                        3 columns │       
└──────────────────────────────────────────────────────────────────────────┘
*/