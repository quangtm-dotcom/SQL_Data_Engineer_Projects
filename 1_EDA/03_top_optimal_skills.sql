/*
    kỹ năng tối ưu nhất cho data engineer giữa thu nhập và yêu cầu
    - Tạo xếp hạng cột kết hợp giữa thu nhập và mức lương để mô tả công việc tối ưu nhất
    - Tập trung vào các vị trí việc làm từ xa hoặc tại VIệt Nam
*/

SELECT
    sd.skills AS ky_nang_co_thu_nhap_cao,
    ROUND(MEDIAN(jpf.salary_year_avg), 0) AS thu_nhap_theo_nam,
    COUNT(sd.skills) AS so_luong_cong_viec,
    ROUND(LN(COUNT(sd.skills)), 2) AS logarit_so_luong_cong_viec,
    ROUND(MEDIAN(jpf.salary_year_avg) * LN(COUNT(sd.skills)) / 1_000_000, 2) AS chi_so_cong_viec_toi_uu
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
    AND jpf.salary_year_avg IS NOT NULL
GROUP BY 
    sd.skills
Having
    COUNT(sd.skills) > 100
ORDER BY
    MEDIAN(jpf.salary_year_avg) * LN(COUNT(sd.skills)) DESC
LIMIT 25;

/*
┌──────────────────────┬───────────────────┬────────────────────┬────────────────────────┬─────────────────────────┐
│ ky_nang_co_thu_nha…  │ thu_nhap_theo_nam │ so_luong_cong_viec │ logarit_so_luong_con…  │ chi_so_cong_viec_toi_uu │
│       varchar        │      double       │       int64        │         double         │         double          │
├──────────────────────┼───────────────────┼────────────────────┼────────────────────────┼─────────────────────────┤
│ terraform            │          184000.0 │                194 │                   5.27 │                    0.97 │
│ python               │          135000.0 │               1140 │                   7.04 │                    0.95 │
│ aws                  │          137290.0 │                785 │                   6.67 │                    0.92 │
│ sql                  │          130000.0 │               1135 │                   7.03 │                    0.91 │
│ airflow              │          150000.0 │                388 │                   5.96 │                    0.89 │
│ spark                │          140000.0 │                511 │                   6.24 │                    0.87 │
│ snowflake            │          136000.0 │                439 │                   6.08 │                    0.83 │
│ kafka                │          145000.0 │                296 │                   5.69 │                    0.83 │
│ azure                │          127500.0 │                478 │                   6.17 │                    0.79 │
│ java                 │          132603.0 │                310 │                   5.74 │                    0.76 │
│ kubernetes           │          150500.0 │                147 │                   4.99 │                    0.75 │
│ scala                │          135500.0 │                250 │                   5.52 │                    0.75 │
│ git                  │          140000.0 │                208 │                   5.34 │                    0.75 │
│ databricks           │          132500.0 │                269 │                   5.59 │                    0.74 │
│ redshift             │          130000.0 │                275 │                   5.62 │                    0.73 │
│ gcp                  │          136000.0 │                197 │                   5.28 │                    0.72 │
│ hadoop               │          132707.0 │                203 │                   5.31 │                    0.71 │
│ pyspark              │          140000.0 │                152 │                   5.02 │                     0.7 │
│ nosql                │          132500.0 │                195 │                   5.27 │                     0.7 │
│ docker               │          135000.0 │                144 │                   4.97 │                    0.67 │
│ mongodb              │          135500.0 │                140 │                   4.94 │                    0.67 │
│ go                   │          140000.0 │                113 │                   4.73 │                    0.66 │
│ r                    │          133638.0 │                134 │                    4.9 │                    0.65 │
│ github               │          135000.0 │                127 │                   4.84 │                    0.65 │
│ bigquery             │          135000.0 │                123 │                   4.81 │                    0.65 │
├──────────────────────┴───────────────────┴────────────────────┴────────────────────────┴─────────────────────────┤
│ 25 rows                                                                                                5 columns │
└──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
*/