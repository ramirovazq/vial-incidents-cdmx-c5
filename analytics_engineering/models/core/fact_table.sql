{{
    config(
        materialized='table'
    )
}}

    SELECT
    id,
    creation_date,
    creation_hour,
    latitude,
    longitud,
    dw.index_week_day,
    ds.index_suburb,
    dti.index_type_incident
    FROM {{ ref('silver_vial_incidents') }} as s

    LEFT JOIN {{ ref('dim_weekday') }} as dw
    ON s.week_day_spanish = dw.week_day_spanish

    LEFT JOIN {{ ref('dim_suburb') }} as ds
    ON s.suburb_catalog = ds.suburb

    LEFT JOIN {{ ref('dim_type_incident') }} as dti
    ON s.type_incident = dti.type_incident
