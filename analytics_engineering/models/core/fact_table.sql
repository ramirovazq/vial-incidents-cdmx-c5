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
    dti.index_type_incident,
    dth.index_town_hall,
    drm.index_reception_medium,
    dic.index_incident_classification,
    di.index_incident
    FROM {{ ref('silver_vial_incidents') }} as s

    LEFT JOIN {{ ref('dim_weekday') }} as dw
    ON s.week_day_spanish = dw.week_day_spanish

    LEFT JOIN {{ ref('dim_suburb') }} as ds
    ON s.suburb_catalog = ds.suburb

    LEFT JOIN {{ ref('dim_type_incident') }} as dti
    ON s.type_incident = dti.type_incident

    LEFT JOIN {{ ref('dim_townhall') }} as dth
    ON s.town_hall_start = dth.town_hall

    LEFT JOIN {{ ref('dim_reception_medium') }} as drm
    ON s.reception_medium = drm.reception_medium

    LEFT JOIN {{ ref('dim_incident_classification') }} as dic
    ON s.incident_classification = dic.incident_classification

    LEFT JOIN {{ ref('dim_incident') }} as di
    ON s.incident = di.incident
