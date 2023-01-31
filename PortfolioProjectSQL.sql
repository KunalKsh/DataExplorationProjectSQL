-- Select Data that are being used

select *
from dbo.CovidDeaths
where continent is not null
order by location

select *
from dbo.covidvaccination
where continent is not null
order by 3,4

select location,date,total_cases,new_cases,total_deaths, population
from dbo.coviddeaths
order by 1,2 

--Total Cases VS Total Deaths,Death Percentage in all Country

Select location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from dbo.coviddeaths
order by 1,2 

--Total Cases VS Total Deaths, Death Percentage(INDIA)

Select location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from dbo.coviddeaths
Where location like '%India%'
order by 1,2 

--Total Cases VS Population, Percentage of People got COVID

Select location,date,Population,total_cases, (total_cases/population)*100 as PercentofPopulation
from dbo.coviddeaths
order by 1,2 

--Highest Infection Rate compared to Population

Select Location,Population,MAX(total_cases) as HighestInfectionCount, MAX(total_cases/population)*100 as InfectionRate
from dbo.coviddeaths
Group by location, population
order by InfectionRate desc

--Countries with Highest Death Count

Select Location, MAX(cast(total_deaths as INT)) as DeathCount , MAX(total_deaths/population)*100 as DeathPercent
from dbo.coviddeaths
where continent is not null
Group by location
order by DeathCount desc  

--Death Count based on Continent

Select continent, MAX(CAST(total_deaths as INT)) AS DeathCount, MAX(total_deaths/population)*100 as DeathPercent
from dbo.coviddeaths
where continent is not null
group by continent
order by 2 desc

--Global Number of DeathCount & Death%

Select Sum(new_cases) as TotalCases, Sum(Cast(new_deaths as INT)) as TotalDeaths, Sum(Cast(new_deaths as INT))/SUM(new_cases)*100 as DeathPercent
from dbo.CovidDeaths
where continent is not null
order by 1,2

--Join DataSets

Select *
 from dbo.CovidDeaths CD
 Join dbo.CovidVaccination VC
 on CD.location = VC.location
 and CD.date=VC.date
 
 --Total Population VS People Vaccinated

 select cd.continent, cd.location,cd.date, cd.population, vc.new_vaccinations, SUM(CONVERT(int, vc.new_vaccinations))
 OVER (PARTITION BY CD.location order by cd.location, cd.date) as PeopleVaccinated
 from dbo.CovidDeaths cd
 join dbo.CovidVaccination vc
 on cd.location = vc.location
 and cd.date = vc.date
  where cd.continent is not null 
 order by 2,3

 --Create View for Visualization

 Create View PeopleVaccinated as
  select cd.continent, cd.location,cd.date, cd.population, vc.new_vaccinations, SUM(CONVERT(int, vc.new_vaccinations))
 OVER (PARTITION BY CD.location order by cd.location, cd.date) as PeopleVaccinated
 from dbo.CovidDeaths cd
 join dbo.CovidVaccination vc
 on cd.location = vc.location
 and cd.date = vc.date
  where cd.continent is not null 

 Select *
  from dbo.peoplevaccinated
 