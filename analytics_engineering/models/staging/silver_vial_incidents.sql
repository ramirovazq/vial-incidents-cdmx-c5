with silver_ids_without_na as (
    SELECT id
    FROM {{ ref('silver_vial_incidents_all_years') }}
    WHERE 1=1
    AND (
        town_hall_start = 'Na' 
        OR town_hall_end = 'Na' 
        OR reception_medium IN ('Na','Sos Mujeres *765','Lector De Placas')
    )
), 
silver_all_years_first_clean as (
    SELECT *
    FROM {{ ref('silver_vial_incidents_all_years') }}
    WHERE id NOT IN (
        SELECT id FROM silver_ids_without_na
    )
)
SELECT *
FROM silver_all_years_first_clean
