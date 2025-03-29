WITH raw_source AS (
    SELECT
        UPPER(TRIM(folio))                as folio,
        INITCAP(TRIM(dia_semana))         as dia_semana,
        INITCAP(TRIM(tipo_incidente_c4))  as tipo_incidente_c4,
        INITCAP(TRIM(incidente_c4))       as incidente_c4,
        INITCAP(TRIM(clas_con_f_alarma))  as clas_con_f_alarma,
        INITCAP(TRIM(tipo_entrada))       as tipo_entrada,
        INITCAP(TRIM(alcaldia_inicio))    as alcaldia_inicio,
        INITCAP(TRIM(alcaldia_cierre))    as alcaldia_cierre,
        INITCAP(TRIM(alcaldia_catalogo))  as alcaldia_catalogo,
        INITCAP(TRIM(colonia_catalogo))   as colonia_catalogo,
        TRIM(codigo_cierre)               as codigo_cierre,
        TRIM(fecha_creacion)              as fecha_creacion,
        TRIM(hora_creacion)               as hora_creacion,
        TRIM(fecha_cierre)                as fecha_cierre,
        TRIM(hora_cierre)                 as hora_cierre,
        TRIM(latitud)                     as latitud,
        TRIM(longitud)                    as longitud
    from {{ source('raw', 'external_inviales_2016_2018_brz') }}
),

brz_source as (
    select *,
        row_number() over(partition by folio, fecha_creacion) as rn
    from raw_source
    where folio is not null
)

    select

        {{ dbt_utils.generate_surrogate_key(['folio', 'fecha_creacion']) }} as id,

        SAFE_CAST(fecha_creacion AS DATE)  AS creation_date,
        SAFE_CAST(hora_creacion AS TIME)   AS creation_hour,
        SAFE_CAST(fecha_cierre AS DATE)    AS close_date,
        SAFE_CAST(hora_cierre AS TIME)     AS close_hour,

        SAFE_CAST(latitud AS FLOAT64)      AS latitude,
        SAFE_CAST(longitud AS FLOAT64)     AS longitud,

        dia_semana                         AS week_day_spanish,
        tipo_incidente_c4                  AS type_incident,
        incidente_c4                       AS incident,

        clas_con_f_alarma                  AS incident_classification,
        tipo_entrada                       AS reception_medium,

        alcaldia_inicio                    AS town_hall_start, 
        alcaldia_cierre                    AS town_hall_end, 
        alcaldia_catalogo                  AS town_hall_catalog,
        colonia_catalogo                   AS suburb_catalog

    -- not necessary fields
     -- folio,
     -- codigo_cierre,

    FROM brz_source
    WHERE rn = 1

-- dbt build --select <model_name> --vars '{'is_test_run': 'false'}'
{% if var('is_test_run', default=true) %}
  limit 100
{% endif %}