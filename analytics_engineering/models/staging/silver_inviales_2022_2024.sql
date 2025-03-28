with 

source as (

    select * from {{ source('raw', 'external_inviales_2022_2024_brz') }}

),

renamed as (

    select
        folio,
        fecha_creacion,
        hora_creacion,
        dia_semana,
        fecha_cierre,
        hora_cierre,
        tipo_incidente_c4,
        incidente_c4,
        alcaldia_inicio,
        codigo_cierre,
        clas_con_f_alarma,
        tipo_entrada,
        alcaldia_cierre,
        alcaldia_catalogo,
        colonia_catalogo,
        longitud,
        latitud

    from source

)

select * from renamed

-- dbt build --select <model_name> --vars '{'is_test_run': 'false'}'
{% if var('is_test_run', default=true) %}

  limit 100

{% endif %}