{{
    config(
        materialized='table'
    )
}}

WITH different AS (
    select distinct reception_medium
    from {{ ref('silver_vial_incidents') }}
    order by 1
)

SELECT 
    row_number() OVER () as index_reception_medium,
    reception_medium as reception_medium
FROM different
