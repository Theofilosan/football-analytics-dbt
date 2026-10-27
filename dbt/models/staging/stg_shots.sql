with source as (

    select * from {{ source('raw', 'events') }}

),

shots as (

    select
        e.id                                                  as id,
        regexp_extract(e.filename, '(\d+)\.json$', 1)::bigint as match_id,
        e.period                                              as period,
        e.player.id                                           as player_id,
        e.player.name                                         as player_name,
        e.shot.statsbomb_xg                                   as xg,
        e.shot.outcome.name                                   as outcome_name

    from source as e
    where e.type.name = 'Shot'

)

select * from shots