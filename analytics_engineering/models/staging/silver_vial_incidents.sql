with data_2014_2015 as (
    select *
    from {{ ref('silver_vial_incidents_2014_2015') }}
),
data_2016_2018 as (
    select *
    from {{ ref('silver_vial_incidents_2016_2018') }}
),
data_2019_2021 as (
    select *
    from {{ ref('silver_vial_incidents_2019_2021') }}
),
data_2022_2024 as (
    select *
    from {{ ref('silver_vial_incidents_2022_2024') }}
),
tables_unioned as (
    SELECT * FROM data_2014_2015
    UNION ALL
    SELECT * FROM data_2016_2018
    UNION ALL
    SELECT * FROM data_2019_2021
    UNION ALL
    SELECT * FROM data_2022_2024
)

SELECT *
FROM tables_unioned
WHERE town_hall_start NOT IN ('Alcaldia_Inicio','Na')
