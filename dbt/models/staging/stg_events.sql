with source as (
    select
    *
    from {{ source('raw', 'events') }}
),

renamed as(
    select 
    e.id as id,
    regexp_extract(e.filename, '(\d+)\.json$', 1)::bigint as match_id,

    e."index" as "index",
    e.period,
    e."timestamp" as "timestamp",
    e.minute,
    e.second,
    e.possession,
    e.duration,
    e.under_pressure,
    e.counterpress,
    e.off_camera,
    e."out" as "out",

    --flattened structs

    e.type.id as event_type_id,
    e.type.name as event_type_name,
    e.team.id as team_id,
    e.team.name as team_name,
    e.possession_team.id                                as possession_team_id,
    e.possession_team.name                              as possession_team_name,
    e.play_pattern.name                                 as play_pattern_name,
    e.player.id                                         as player_id,
    e.player.name                                       as player_name,
    e.position.name                                     as position_name,

    e.location[1]                                       as location_x,
    e.location[2]                                       as location_y

    from source as e

)

select * from renamed
