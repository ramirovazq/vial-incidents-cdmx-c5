{{
    config(
        materialized='table'
    )
}}

with table_weekday_monday AS (

SELECT
year_creation_date,
index_week_day,
index_type_incident,
index_incident_classification,
index_incident
FROM {{ ref('fact_table') }}
WHERE 1=1
AND year_creation_date = 2024
AND index_week_day ='5'

)

SELECT

dti.type_incident,
dic.incident_classification,
di.incident,
count(*) as count_by

FROM table_weekday_monday as twm

left JOIN {{ ref('dim_type_incident') }}  dti
ON dti.index_type_incident = twm.index_type_incident

left JOIN {{ ref('dim_incident_classification') }}  dic
ON dic.index_incident_classification = twm.index_incident_classification

left JOIN {{ ref('dim_incident') }}  di
ON di.index_incident = twm.index_incident

GROUP BY 1,2,3
order by 4 desc 

