with source as (

    select * from {{ source('raw', 'events') }}

),

shots as (

    select
        e.id                                                  as id,
        regexp_extract(e.filename, '(\d+)\.json$', 1)::bigint as match_id,
        e.period                                              as period,
        e.team.id                                             as team_id,
        e.team.name                                           as team_name,
        e.player.id                                           as player_id,
        e.player.name                                         as player_name,
        e.location[1]                                         as location_x,
        e.location[2]                                         as location_y,
        e.shot.statsbomb_xg                                   as xg,
        e.shot.outcome.name                                   as outcome_name

    from source as e
    where e.type.name = 'Shot'

)

select * from shots