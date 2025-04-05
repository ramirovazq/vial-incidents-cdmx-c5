{{
    config(
        materialized='table'
    )
}}


select 
ds.suburb,
count(*) as count_by_suburb
from {{ ref('fact_table') }} f
left JOIN {{ ref('dim_suburb') }}  ds
on f.index_suburb = ds.index_suburb
group by 1

