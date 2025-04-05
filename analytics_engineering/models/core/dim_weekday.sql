{{
    config(
        materialized='table'
    )
}}

WITH different_days AS (
    select distinct week_day_spanish as week_day_spanish 
    from {{ ref('silver_vial_incidents') }}
)

SELECT 
    CASE 
        WHEN week_day_spanish = 'Lunes' THEN '1'
        WHEN week_day_spanish = 'Martes' THEN '2'
        WHEN week_day_spanish = 'Miércoles' THEN '3'
        WHEN week_day_spanish = 'Jueves' THEN '4'
        WHEN week_day_spanish = 'Viernes' THEN '5' 
        WHEN week_day_spanish = 'Sábado' THEN '6'
        WHEN week_day_spanish = 'Domingo' THEN '7'
        ELSE '?'
    END AS index_week_day,
    week_day_spanish,
    CASE 
        WHEN week_day_spanish = 'Lunes' THEN 'Monday'
        WHEN week_day_spanish = 'Martes' THEN 'Tuesday'
        WHEN week_day_spanish = 'Miércoles' THEN 'Wednesday'
        WHEN week_day_spanish = 'Jueves' THEN 'Thursday'
        WHEN week_day_spanish = 'Viernes' THEN 'Friday' 
        WHEN week_day_spanish = 'Sábado' THEN 'Saturday'
        WHEN week_day_spanish = 'Domingo' THEN 'Sunday'
        ELSE 'Unknown'
    END AS week_day,
FROM different_days
ORDER BY 1