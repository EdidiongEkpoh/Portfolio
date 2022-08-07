-- Dropping players that did not play at least 21 games
DELETE
from dbo.[2021-2022 Regular Season]
where GP < 21

-- Assist/Turnover Ratio for players that recorded at least 3 assists per game
select Name, Team, POS, GP, MPG, APG, TOPG, (APG / TOPG) as AST_TO_Ratio
from dbo.[2021-2022 Regular Season]
where APG >= 3 and TOPG <> 0
order by AST_TO_Ratio desc

-- Combined Assist to Turnover Ratio for each team
select Team, (sum(APG)/ sum(TOPG)) as TeamAST_TO_Ratio
from dbo.[2021-2022 Regular Season]
group by TEAM
order by TeamAST_TO_Ratio desc

-- Players under the age of 25 that averaged and had a usage rate of at least 25%
select Name, Team, Age, GP, MPG, USG
from dbo.[2021-2022 Regular Season]
where Age < 25 and USG >= 25 and GP >=20 and MPG >= 20
order by USG desc, Age asc

-- Calculating Free Throw Rates for players that averaged at least 25 minutes per game
select Name, Team, GP, MPG, TS, FTA, _2PA, _3PA, round(cast(FTA as float) / cast(_2PA + _3PA as float), 3) as FTRate
from dbo.[2021-2022 Regular Season]
where MPG >= 25
order by FTRate desc

-- Selecting players that averaged at least 24 PPG and a TS% of at least 57%
-- Case statement on if the player is under the age of 25, or not
select Name, Team, Age, GP, PPG, MPG, TS,
CASE
    when Age < 25 then 'Yes'
    else 'No'
END as 'Under_25'
from dbo.[2021-2022 Regular Season]
where PPG >= 24 and TS >= .57
order by Under_25 desc, Age

-- Finding the league leaders in STOCKS per game (steals + blocks)
select Name, Team, Age, GP, SPG, BPG, MPG, (SPG+BPG) as STOCKS
from dbo.[2021-2022 Regular Season]
order by STOCKS desc


-- PPG per 36 minutes played
select Name, Team, Age, GP, PPG, MPG, round((cast(PPG as float) / cast(MPG as float)) * 36, 2) as PPG_Per_36
from dbo.[2021-2022 Regular Season]
order by PPG_Per_36 desc



