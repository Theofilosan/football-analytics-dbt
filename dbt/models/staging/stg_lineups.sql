with source as(
    select *
    from {{ source('raw', 'lineups') }}
),
with_match_id as (
    select
        regexp_extract(filename, '(\d+)\.json$', 1)::bigint as match_id,
        team_id,
        team_name,
        lineup
    from source
),

--one row per player: the array is turned into multiple rows, one for each player in the lineup
exploded as(
    select
        match_id,
        team_id,
        team_name,
        unnest(lineup) as player
    from with_match_id
),
renamed as (

    select
        match_id,
        team_id,
        team_name,
        player.player_id          as player_id,
        player.player_name        as player_name,
        player.player_nickname    as player_nickname,
        player.jersey_number      as jersey_number,
        player.country.name       as country_name
    from exploded

)

select * from renamed