{{
    config(
        materialized='table'
    )
}}

select 
month_creation_date,
count(*) as count_incidents
from {{ ref('fact_table') }}
group by 1
order by 1
