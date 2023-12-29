/*

PROJECT: COVID-19 GLOBAL CASUALTY TRACKER
Last update: 04-12-2023
Objective: transform data and explore new metrics

*/

----------CALCULATE CALSUALTIES FROM TABLE I: COVID DEATHS----------
-- 1. Calculate DeathChance by each date
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathChance
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

-- 2. Calculate Infection Rate by each date
select location, date, total_cases, population, (total_cases/population)*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

-- 3. Show latest Infection Rate by country
select location, population, max(total_cases) as HighestInfectionCount, max(total_cases/population)*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths
where continent is not null
group by location, population
order by PercentPopulationInfected desc

-- 4. Show latest Death Count by country
select location, max(cast(total_deaths as int)) as HighestDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by location
order by HighestDeathCount desc

-- 5. Show latest Death Count by continent
select location, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is null
group by location
order by TotalDeathCount desc

-- 6. Show Total Global Data by each date
select date, sum(total_cases), sum(cast(total_deaths as int)), 
sum(cast(total_deaths as int))/sum(total_cases)*100 as DeathChance
from PortfolioProject..CovidDeaths
where continent is not null
group by date
order by 1

-- 7. Show latest Total Global Data 
select top 1 date, sum(total_cases), sum(cast(total_deaths as int)), 
sum(cast(total_deaths as int))/sum(total_cases)*100 as DeathChance
from PortfolioProject..CovidDeaths
where continent is not null
group by date
order by 1 desc


----------CALCULATE VAC RATE FROM TABLE II: COVID VACCINATIONS----------
-- 8. Join 2 tables together
select * 
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3
	
-- 9. Show Vaccination Rate by each date
--- Op1: Create CTE to make calculation with column RollingPeopleVaccinated
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated) 
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.date) 
AS RollingPeopleVaccinated
from PortfolioProject1..CovidDeaths dea
join PortfolioProject1..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
)

Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac
order by 2,3

--- Op2: Create temp table
Drop table if exists #PercentPopulationVaccinated
Create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime, 
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.date) 
AS RollingPeopleVaccinated
from PortfolioProject1..CovidDeaths dea
join PortfolioProject1..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated
order by 2,3

-- 10. Create VIEW to store data
Create View PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.date) 
AS RollingPeopleVaccinated
from PortfolioProject1..CovidDeaths dea
join PortfolioProject1..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
