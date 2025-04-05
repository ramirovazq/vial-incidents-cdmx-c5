{{
    config(
        materialized='table'
    )
}}

select 
hour_creation_date,
count(*) as count_incidents
from {{ ref('fact_table') }}
where hour_creation_date is not null
group by 1
order by 1
