{{
    config(
        materialized='table'
    )
}}

WITH different AS (
    select distinct incident
    from {{ ref('silver_vial_incidents') }}
    order by 1
)

SELECT 
    row_number() OVER () as index_incident,
    incident as incident
FROM different
