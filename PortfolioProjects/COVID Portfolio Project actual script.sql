SELECT *
FROM PortfolioProject..CovidDeath$
WHERE continent IS NOT NULL 
ORDER BY 3,4

--select *
--from PortfolioProject..CovidVaccinationcsv$
--order by 3,4

select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeath$
where continent is not Null
order by 1,2

--Looking at Total Casesvs Total Death
-- Likelyhood of dying if you contract Covid19 in your Country
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)* 100 AS DeathPercentage
FROM PortfolioProject..CovidDeath$
WHERE location LIKE 'Nigeri%' AND continent IS NOT NULL
ORDER BY 1,2

-- Looking at TotalCases vs Population
--Shows what percentage of population got Covid
SELECT location, date, population, total_cases, (total_cases/population)* 100 AS PercentageInfection
FROM PortfolioProject..CovidDeath$
WHERE location LIKE 'Nigeri%' AND continent IS NOT NULL
ORDER BY 1,2

--Looking at countries with the highest Infection Rate compared to Population
SELECT location, population, max(total_cases) AS HighestInfectionCount, max((total_cases/population))* 100 AS PercentagePopulationInfected
FROM PortfolioProject..CovidDeath$
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY PercentagePopulationInfected DESC


-- Showing Countries with Highest Death Count per Population
SELECT location, max(CAST(total_deaths AS int)) AS TotalDeathCount
FROM PortfolioProject..CovidDeath$
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC

-- LET'S BREAK THINGS UP BY CONTINENT
-- Showing continents with thehighest death count per population

SELECT continent, max(CAST(total_deaths AS int)) AS TotalDeathCount
FROM PortfolioProject..CovidDeath$
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC


-- GLOBAL NUMBERS
SELECT date, sum(new_cases) AS total_cases, sum(CAST(new_deaths AS int)) AS total_death, SUM(CAST(new_deaths AS int))/SUM(new_cases)*100 AS DeathPercentage
FROM PortfolioProject..CovidDeath$
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2

SELECT sum(new_cases) AS total_cases, sum(CAST(new_deaths AS int)) AS total_death, SUM(CAST(new_deaths AS int))/SUM(new_cases)*100 AS DeathPercentage
FROM PortfolioProject..CovidDeath$
WHERE continent IS NOT NULL
ORDER BY 1,2

-- Looking at Total Population vs vaccination
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(CAST(vac.new_vaccinations AS int)) OVER (Partition BY dea.location)
FROM PortfolioProject..CovidDeath$  dea
JOIN PortfolioProject..CovidVaccinationcsv$  vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(CONVERT(int,vac.new_vaccinations)) OVER (Partition BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeath$  dea
JOIN PortfolioProject..CovidVaccinationcsv$  vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3

-- USE CTE
WITH PopvsVac (continent, Location, Date, Population, New_vaccination, RollingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(convert(int,vac.new_vaccinations)) OVER (Partition BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeath$  dea
JOIN PortfolioProject..CovidVaccinationcsv$  vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
)
SELECT*, (RollingPeopleVaccinated/Population)*100
FROM PopvsVac

-- TEMP TABLE
DROP Table IF exists #PercentPopulationsVaccinated
CREATE TABLE #PercentPopulationsVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationsVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(convert(int,vac.new_vaccinations)) OVER (Partition BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeath$  dea
JOIN PortfolioProject..CovidVaccinationcsv$  vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL

SELECT*
FROM #PercentPopulationsVaccinated


--creating views to store data for later visualization

CREATE VIEW PercentagePopulationVaccination AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(convert(int,vac.new_vaccinations)) OVER (Partition BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeath$  dea
JOIN PortfolioProject..CovidVaccinationcsv$  vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL

SELECT *
FROM PercentagePopulationVaccination
