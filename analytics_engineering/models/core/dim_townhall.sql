{{
    config(
        materialized='table'
    )
}}

WITH different_townhall AS (
    select distinct town_hall_start
    from {{ ref('silver_vial_incidents') }}
    order by 1
)

SELECT 
    row_number() OVER () as index_town_hall,
    town_hall_start as town_hall
FROM different_townhall
