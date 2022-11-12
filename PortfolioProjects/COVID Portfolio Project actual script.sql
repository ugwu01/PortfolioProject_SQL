11select *
from PortfolioProject..CovidDeath$
where continent is not Null 
order by 3,4

--select *
--from PortfolioProject..CovidVaccinationcsv$
--order by 3,4

select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeath$
where continent is not Null
order by 1,2

--Looking at Total Casesvs Total Death
-- Likelyhood of dying if you contract Covid19 in your Country
select location, date, total_cases, total_deaths, (total_deaths/total_cases)* 100 as DeathPercentage
from PortfolioProject..CovidDeath$
where location like 'Nigeri%'and continent is not Null
order by 1,2

-- Looking at TotalCases vs Population
--Shows what percentage of population got Covid
select location, date, population, total_cases, (total_cases/population)* 100 as PercentageInfection
from PortfolioProject..CovidDeath$
where location like 'Nigeri%' and continent is not Null 
order by 1,2

--Looking at countries with the highest Infection Rate compared to Population
select location, population, max(total_cases) as HighestInfectionCount, max((total_cases/population))* 100 as PercentagePopulationInfected
from PortfolioProject..CovidDeath$
where continent is not Null
Group by location, population
order by PercentagePopulationInfected desc


-- Showing Countries with Highest Death Count per Population
select location, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeath$
where continent is not Null
Group by location
order by TotalDeathCount desc

-- LET'S BREAK THINGS UP BY CONTINENT
-- Showing continents with thehighest death count per population

select continent, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeath$
where continent is NOT Null
Group by continent
order by TotalDeathCount desc


-- GLOBAL NUMBERS
select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_death, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeath$
where continent is not Null
group by date
order by 1,2

select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_death, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeath$
where continent is not Null
order by 1,2

-- Looking at Total Population vs vaccination
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location)
from PortfolioProject..CovidDeath$  dea
join PortfolioProject..CovidVaccinationcsv$  vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not Null
order by 2,3

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(convert(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeath$  dea
join PortfolioProject..CovidVaccinationcsv$  vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not Null
order by 2,3

-- USE CTE
with PopvsVac (continent, Location, Date, Population, New_vaccination, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(convert(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeath$  dea
join PortfolioProject..CovidVaccinationcsv$  vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not Null
)
select*, (RollingPeopleVaccinated/Population)*100
from PopvsVac

-- TEMP TABLE
DROP Table IF exists #PercentPopulationsVaccinated
create Table #PercentPopulationsVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentPopulationsVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(convert(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeath$  dea
join PortfolioProject..CovidVaccinationcsv$  vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not Null

select*
from #PercentPopulationsVaccinated


--creating views to store data for later visualization

create view PercentagePopulationVaccination as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(convert(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeath$  dea
join PortfolioProject..CovidVaccinationcsv$  vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not Null

select *
from PercentagePopulationVaccination