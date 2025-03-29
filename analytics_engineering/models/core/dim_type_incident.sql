{{
    config(
        materialized='table'
    )
}}

WITH different AS (
    select distinct type_incident
    from {{ ref('silver_vial_incidents') }}
    order by 1
)

SELECT 
    row_number() OVER () as index_type_incident,
    type_incident as type_incident
FROM different
