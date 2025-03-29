{{
    config(
        materialized='table'
    )
}}

WITH different_suburbs AS (
    select distinct suburb_catalog
    from {{ ref('silver_vial_incidents') }}
    order by 1
)

SELECT 
    row_number() OVER () as index_suburb,
    suburb_catalog as suburb
FROM different_suburbs
