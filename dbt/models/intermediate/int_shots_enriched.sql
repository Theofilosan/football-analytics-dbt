with shots as (

    select * from {{ ref('stg_shots') }}

),

matches as (

    select * from {{ ref('stg_matches') }}

),

joined as (

    select
        -- all shot columns
        shots.id,
        shots.match_id,
        shots.period,
        shots.team_id,
        shots.team_name,
        shots.player_id,
        shots.player_name,
        shots.location_x,
        shots.location_y,
        shots.xg,
        shots.outcome_name,

        -- flags
        shots.outcome_name = 'Goal'   as is_goal,
        shots.period = 5              as is_shootout,

        -- match context
        matches.match_date,
        matches.stage_name,
        matches.home_team_name,
        matches.away_team_name

    from shots
    left join matches
        on shots.match_id = matches.match_id

)

select * from joined