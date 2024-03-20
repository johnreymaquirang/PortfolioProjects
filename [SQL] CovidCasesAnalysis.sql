Select *
From CovidDeaths

Select *
From CovidVaccinations

-- Total Count of Cases in the World
Select COUNT(total_cases) Overall_Cases
From CovidDeaths

-- Total Count of Deaths in the World
Select COUNT(total_deaths) Overall_Deaths
From CovidDeaths

-- Total Cases Per Country
Select distinct location, SUM(total_cases) Total_cases_per_Country
From CovidDeaths
Group by location
Order by location

-- Percentage of Deaths in the Philippines 2020
Select location, date, total_cases, total_deaths, population, (total_deaths/total_cases)*100 Percentage_Deaths
From CovidDeaths
Where location = 'Philippines' and YEAR(date) = 2020

-- Percentage of Deaths in the Philippines 2020
Select location, date, total_cases, total_deaths, population,(total_deaths/total_cases)*100 Percentage_Deaths
From CovidDeaths
Where location = 'Philippines' and YEAR(date) = 2021

-- Percentage of Population that got COVID in the Philippines
Select location, date, population, total_cases, (total_cases/population)*100 Percentage_Cases
From CovidDeaths
Where location = 'Philippines'

-- Countries with the Highest Infection Rate
Select location, population, max(total_cases) Highest_Cases, max((total_cases/population)*100) Percentage_Cases
From CovidDeaths
Group by location, population
Order by Percentage_Cases desc

--Countries with Highest Death Count Per Population
Select location, max(cast(total_deaths as int)) TotalDeathCount
From CovidDeaths
Where continent is not null
Group by location
Order by TotalDeathCount desc


--Continents with Highest Death Count Per Population
Select location, max(cast(total_deaths as int)) TotalDeathCount
From CovidDeaths
Where continent is null and location not in ('World', 'International', 'European Union')
Group by location
Order by TotalDeathCount desc


--Total Death Percentage
Select Sum(new_cases) Total_cases, Sum(cast(new_deaths as int)) Total_deaths, (Sum(cast(new_deaths as int))/Sum(new_cases))*100 Death_Percentage
From CovidDeaths
Where continent is not null


--People who got vaccinated per country timeline
Select cd.location, cd.date, cd.population, cv.new_vaccinations, Sum(Convert(bigint, cv.new_vaccinations)) Over (Partition By cd.location Order by cd.location, cd.date) as VaccinationsOverTime
From CovidDeaths cd
Join CovidVaccinations cv
	on cd.location = cv.location
	and cd.date = cv.date
Where cd.continent is not null
Order by cd.location, cd.date


--People who got vaccinated in the Philippines timeline
Select cd.location, cd.date, cd.population, cv.new_vaccinations, Sum(Convert(bigint, cv.new_vaccinations)) Over (Partition By cd.location Order by cd.location, cd.date) as VaccinationsOverTime
From CovidDeaths cd
Join CovidVaccinations cv
	on cd.location = cv.location
	and cd.date = cv.date
Where cd.continent is not null and cd.location = 'Philippines'
Order by cd.location, cd.date


-- Vaccination Rate Over Time
With VaxRate (Location, Date, Population, New_vaccinations, VaccinationsOverTime)
as
(
Select cd.location, cd.date, cd.population, cv.new_vaccinations, Sum(Convert(bigint, cv.new_vaccinations)) Over (Partition By cd.location Order by cd.location, cd.date) as VaccinationsOverTime
From CovidDeaths cd
Join CovidVaccinations cv
	on cd.location = cv.location
	and cd.date = cv.date
Where cd.continent is not null
) 

Select Location, Population, New_vaccinations, (VaccinationsOverTime/Population)*100 VaccinationRate
From VaxRate


-- Create a Temporary Table
Drop Table if exists #VaccinationRate
Create Table #VaccinationRate 
(
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
VaccinationsOverTime numeric
)

Insert Into #VaccinationRate
Select cd.location, cd.date, cd.population, cv.new_vaccinations, Sum(Convert(bigint, cv.new_vaccinations)) Over (Partition By cd.location Order by cd.location, cd.date) as VaccinationsOverTime
From CovidDeaths cd
Join CovidVaccinations cv
	on cd.location = cv.location
	and cd.date = cv.date
Where cd.continent is not null

Select Location, Population, New_vaccinations, (VaccinationsOverTime/Population)*100 VaccinationRate
From #VaccinationRate


-- Creating View
Create View DeathCountPerPopulation as
Select location, max(cast(total_deaths as int)) TotalDeathCount
From CovidDeaths
Where continent is null and location not in ('World', 'International', 'European Union')
Group by location
--Order by TotalDeathCount desc

Select *
From DeathCountPerPopulation
Order By TotalDeathCount desc
