/*

PROJECT: COVID-19 GLOBAL CASUALTY TRACKER
Last update: 04-12-2023
Objective: extract data for visualization

*/

Select * 
from PortfolioProject1..CovidData
  

-- 1. GLOBAL DATA: Death, Infection, Death as % of Infection (per million people)

--- Note: Intuitive approach is to filter by latest date '2023-12-04' to get the total data. However, many countries 
--- do not update up until this date. Therefore, total data is calculated based on the latest date available for each 
--- countries

With GlobalData (location, TotalDeath, TotalCases, DeathChance) 
as
(
select location, max(convert(bigint,total_deaths)) as TotalDeath, max(convert(bigint,total_cases)) as TotalCases,
max(convert(float,total_deaths))/max(convert(float,total_cases))*1000000 as DeathChance
from PortfolioProject1..CovidData
where continent is not null
group by location
)
Select sum(TotalDeath) as TotalDeath, sum(TotalCases) as TotalCases, sum(TotalDeath)/sum(convert(float,TotalCases))*1000000 as DeathChance
from GlobalData


-- 2. CONTINENT DATA: Death, Infection, Death as % of Infection

With GlobalData (continent, location, TotalDeath, TotalCases, DeathChance) 
as
(
select continent ,location, max(convert(bigint,total_deaths)) as TotalDeath, max(convert(bigint,total_cases)) as TotalCases,
max(convert(float,total_deaths))/max(convert(float,total_cases))*1000000 as DeathChance
from PortfolioProject1..CovidData
where continent is not null
group by location, continent
)
Select continent, sum(TotalDeath) as TotalDeath, sum(TotalCases) as TotalCases, sum(TotalDeath)/sum(convert(float,TotalCases))*1000000 as DeathChance
from GlobalData
group by continent
order by 1


-- 3. COUNTRY DATA: Death, Infection, Vac, Death as % of Infection, Infection as % of Pop, Vac as % of Pop

Select location, population, max(convert(bigint,total_deaths)) as TotalDeath, max(convert(bigint,total_cases)) as TotalCases,
max(convert(bigint,people_vaccinated)) as TotalVac,
max(convert(float,total_deaths))/max(convert(float,total_cases))*1000000 as DeathChance, 
max(convert(float,total_cases))/population as InfectionPercentage,
max(convert(bigint,people_vaccinated))/population as VacPercentage
from PortfolioProject1..CovidData
where continent is not null
group by location, population
order by 1

  
-- 4. COUNTRY DATA: Top 5 countries by Death Count

Select top 5 location, max(convert(bigint,total_deaths)) as TotalDeath, max(convert(bigint,total_cases)) as TotalCases,
max(convert(float,total_deaths))/max(convert(float,total_cases))*1000000 as DeathChance
from PortfolioProject1..CovidData
where continent is not null
group by location
order by 2 desc