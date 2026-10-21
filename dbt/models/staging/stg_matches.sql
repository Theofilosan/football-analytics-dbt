with source as (
    select *
    from {{ source('raw', 'matches') }}
),
renamed as (
    select
        match_id,
        match_date,
        kick_off,
        home_score,
        away_score,
        match_status,
        match_week,

        -- flattened from structs
        competition.competition_name as competition_name,
        season.season_name as season_name,
        home_team.home_team_id as home_team_id,
        home_team.home_team_name as home_team_name,
        away_team.away_team_id as away_team_id, 
        away_team.away_team_name as away_team_name,
        competition_stage.name as stage_name,
        stadium.name as stadium_name,
        referee.name as referee_name
    from source
)
select *
from renamed