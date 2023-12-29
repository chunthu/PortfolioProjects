/*

PROJECT: CO2 EMISSIONS TIME-SERIES ANALYSIS
Last update: 20-12-2023
Objective: extract data for visualization

*/

------------- CONTINENT DATA -------------

-- 1. CO2 contribution
Select substring(country, 1, CHARINDEX('(', country)-1) as continent, year, co2
from PortfolioProject2..CO2data
where country like '%(GCP)' and country not like '%OECD%' and year like '2022'


------------- COUNTRY DATA -------------

-- 2. CO2 contribution by income brackets
Select country, year, co2, share_global_co2
from PortfolioProject2..CO2data
where country like '%income%'

-- 3. Data by countries: CO2 contribution, CO2 per capita, Cumulative CO2, Energy per capita
Drop view if exists CO2data

Create view CO2data as
Select country, year, iso_code, population, convert(float,co2) as co2, share_global_co2, co2_per_capita, cumulative_co2, share_global_cumulative_co2, energy_per_capita
from PortfolioProject2..CO2data
where iso_code is not null

select *
from CO2data
order by 1

-- 4. Data by countries in 2022: incl GDP per capita

Select CO2data.*, GDP.[2022] as GDP_PC_2022
from PortfolioProject2..GDP
inner join CO2data
on GDP.[Country Code] = CO2data.iso_code
where GDP.[Indicator Name] like 'GDP per capita (constant 2015 US$)'
and CO2data.year like '2022' 
order by 1
