{{
    config(
        materialized='table'
    )
}}

WITH different AS (
    select distinct incident_classification
    from {{ ref('silver_vial_incidents') }}
    order by 1
)

SELECT 
    row_number() OVER () as index_incident_classification,
    incident_classification as incident_classification
FROM different
