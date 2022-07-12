select * from [Portfolio project]..Coviddeaths
where continent is not null
order by 3,4

--select * from [Portfolio project]..CovidVaccinations
--order by 3,4

Select location, Date, total_cases, new_cases, total_deaths, population
from [Portfolio project]..Coviddeaths
where continent is not null
order by 1,2

--looking at total cases v/s total deaths

Select location, Date, total_cases, total_deaths, (total_deaths/total_cases)*100 as deathpercentage
from [Portfolio project]..Coviddeaths
where location='India' and continent is not null
order by 1,2

-- What percentage of population got covid?

Select location, Date, total_cases, population, (total_cases/population)*100 as PercentagePopulationInfected
from [Portfolio project]..Coviddeaths
where continent is not null
--where location='India'
order by 1,2


Select location, population, MAX(total_cases) as highestInfectionCount, MAX(total_cases/population)*100 as PercentagePopulationInfected
from [Portfolio project]..Coviddeaths
where continent is not null
--where location='India'
Group by Location, Population
order by PercentagePopulationInfected desc

Select location, MAX(Cast(Total_deaths as int)) as TotalDeathCount
From [Portfolio project]..Coviddeaths
where continent is not null
group by location
Order by TotalDeathCount desc

Select location, MAX(Cast(Total_deaths as int)) as TotalDeathCount
From [Portfolio project]..Coviddeaths
where continent is null
group by location
Order by TotalDeathCount desc

--GLOBAL NUMBERS
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int))as total_deaths,
SUM(cast(new_deaths as int))/SUM(new_cases)*100 as deathPercentage
from [portfolio project]..Coviddeaths
where continent is not null
order by 1,2

-- total population vs vaccination

-- For using CTE 

With PopvsVac (Continent, Date, Location, Population, New_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.date, dea.location, dea.population, vac.new_vaccinations, 
sum(cast(vac.new_vaccinations as float)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from [Portfolio project]..Coviddeaths dea
Join [Portfolio project]..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null and dea.population is not null
-- order by 3,2
)
Select *, RollingPeopleVaccinated/Population*100 as percentpeoplevaccinated
--max(percentagepeoplevaccinated) as MaximumVaccinationPercentage 
from PopvsVac
Order by percentpeoplevaccinated desc


-- Temp table

Drop table if exists #PercentPopulationVaccinated 
Create table #PercentPopulationVaccinated 
(
continent nvarchar(255), 
location nvarchar(255),
date datetime ,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)
insert into #PercentPopulationVaccinated 
select dea.continent, dea.date, dea.location, dea.population, vac.new_vaccinations, 
sum(cast(vac.new_vaccinations as float)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from [Portfolio project]..Coviddeaths dea
Join [Portfolio project]..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
-- where dea.continent is not null and dea.population is not null
-- order by 3,2

Select *, RollingPeopleVaccinated/Population*100 as percentpeoplevaccinated
--max(percentagepeoplevaccinated) as MaximumVaccinationPercentage 
from #PercentPopulationVaccinated


-- Creating view 
create view PercentPopulationVaccinated as
select dea.continent, dea.date, dea.location, dea.population, vac.new_vaccinations, 
sum(cast(vac.new_vaccinations as float)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from [Portfolio project]..Coviddeaths dea
Join [Portfolio project]..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null and dea.population is not null
-- order by 3,2

select * from dbo.PercentPopulationVaccinated










