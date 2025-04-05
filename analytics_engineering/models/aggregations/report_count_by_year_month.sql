{{
    config(
        materialized='table'
    )
}}

select 
year_creation_date,
month_creation_date,
count(*) as incidents_by_month
from {{ ref('fact_table') }}
group by 1,2
order by 1,2
