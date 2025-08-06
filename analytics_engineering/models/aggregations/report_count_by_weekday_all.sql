{{
    config(
        materialized='table'
    )
}}

with table_weekday AS (

SELECT
index_week_day,
count(*) as count_by_day
FROM {{ ref('fact_table') }}
GROUP BY 1

)

SELECT
tw.index_week_day,
tw.count_by_day,
dw.week_day_spanish,
dw.week_day
FROM table_weekday as tw
left JOIN {{ ref('dim_weekday') }}  dw
ON tw.index_week_day = dw.index_week_day
ORDER BY 1

