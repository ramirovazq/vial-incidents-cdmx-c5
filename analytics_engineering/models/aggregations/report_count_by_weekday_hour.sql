{{
    config(
        materialized='table'
    )
}}

with table_weekday_hour AS (
select 
dw.week_day_spanish as week_day_spanish,
f.hour_creation_date as hour_creation
from {{ ref('fact_table') }} f
left JOIN {{ ref('dim_weekday') }}  dw
on f.index_week_day = dw.index_week_day
where 1=1
and hour_creation_date is not null
)

SELECT
week_day_spanish,
hour_creation,
count(*) AS count_by
FROM table_weekday_hour
GROUP BY 1,2
ORDER BY 1,2

