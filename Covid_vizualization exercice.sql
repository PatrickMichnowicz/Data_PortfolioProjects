-- https://ourworldindata.org/covid-deaths

-- BELGIUM DATA

SELECT *
FROM Covid_deaths
WHERE location LIKE 'Belgium'
ORDER BY 3,4

SELECT * 
FROM Covid_vaccinations
WHERE location LIKE 'Belgium'
ORDER BY 3,4


--Selected data from tables
SELECT Death.location, Death.date, population, total_cases, new_cases, total_deaths, new_deaths, icu_patients, hosp_patients, 
total_tests, new_tests, positive_rate, total_vaccinations, people_fully_vaccinated
FROM Covid_deaths AS Death
JOIN Covid_vaccinations AS Vaccine
	ON Death.location = Vaccine.location
	AND Death.date = Vaccine.date
WHERE Death.location LIKE 'Belgium'
ORDER BY 1,2


-- Population vs Total Cases (infected population) vs Total Deaths (death by covid compared to pop + to infected people) 
SELECT date, total_cases, total_deaths, (total_deaths / total_cases)*100 AS Death_percent, icu_patients, hosp_patients, (icu_patients/hosp_patients)*100 AS ICU_percent 
FROM Covid_deaths
WHERE location LIKE 'Belgium' AND hosp_patients != 0
ORDER BY 1

SELECT (SUM(new_deaths)/SUM(new_cases))*100 AS Total_Death_percent
FROM Covid_deaths
WHERE location LIKE 'Belgium'

SELECT SUM(new_deaths)
FROM Covid_deaths
WHERE location LIKE 'Belgium'

SELECT SUM(new_cases)
FROM Covid_deaths
WHERE location LIKE 'Belgium'

-- Total cases vs total hospital intakes

SELECT date, total_cases, hosp_patients, (hosp_patients / total_cases)*100 AS Hospitalized_percent
FROM Covid_deaths
WHERE location LIKE 'Belgium'
ORDER BY 1

-- Tests vs positive tests
SELECT date, total_tests, new_tests, positive_rate
FROM Covid_vaccinations
WHERE location LIKE 'Belgium'
ORDER BY 1


--Vaccine impact (pending method)
SELECT Death.date, total_cases, new_cases, total_deaths, new_deaths, 
total_vaccinations, people_fully_vaccinated
FROM Covid_deaths AS Death
JOIN Covid_vaccinations AS Vaccine
	ON Death.location = Vaccine.location
	AND Death.date = Vaccine.date
WHERE Death.location LIKE 'Belgium'
ORDER BY 1


--EUROPE
--Data selection
SELECT *
FROM Covid_deaths
WHERE continent LIKE 'Europe'
ORDER BY 3,4

SELECT * 
FROM Covid_vaccinations
WHERE continent LIKE 'Europe'
ORDER BY 3,4


SELECT Death.location, Death.date, population, total_cases, new_cases, total_deaths, new_deaths, 
total_tests, new_tests, positive_rate, population_density 
FROM Covid_deaths AS Death
JOIN Covid_vaccinations AS Vaccine
	ON Death.location = Vaccine.location
	AND Death.date = Vaccine.date
WHERE Death.continent LIKE 'Europe'
ORDER BY 1,2


--European Union only (segregated from other stats)
SELECT population, MAX(total_cases)
FROM Covid_deaths 
WHERE location LIKE 'European Union'
GROUP BY population


SELECT Death.location, MAX(population) AS Population, MAX(total_cases) AS Cases_tot, MAX(total_deaths) AS Death_Tot, (MAX(total_deaths) / MAX(total_cases))*100 AS Mortality_rate,
MAX(total_tests) AS Tests_total, MAX(people_fully_vaccinated) AS Pop_FullyVaccinated, (MAX(people_fully_vaccinated)/MAX(population))*100 AS TotVac_rate, MAX(population_density) AS Population_Density
FROM Covid_deaths AS Death
JOIN Covid_vaccinations AS Vaccine
	ON Death.location = Vaccine.location
WHERE Death.location IN ('Austria', 'Belgium', 'Bulgaria', 'Croatia', 'Cyprus', 'Czechia', 'Denmark', 'Estonia', 'Finland', 'France', 'Germany', 
'Greece', 'Hungary', 'Ireland', 'Italy', 'Latvia', 'Lithuania', 'Luxembourg', 'Malta', 'Netherlands', 'Poland', 'Portugal', 'Romania', 
'Slovakia', 'Slovenia', 'Spain', 'Sweden')
GROUP BY Death.location
ORDER BY 3 DESC



-- WORLD
SELECT *
FROM Covid_deaths
WHERE continent IS NOT NULL
ORDER BY 3,4

SELECT * 
FROM Covid_vaccinations
WHERE continent IS NOT NULL
ORDER BY 3,4

-- World Mortality rate by descending rate
SELECT location, MAX(population) AS Population, MAX(total_cases) AS Cases_tot, MAX(total_deaths) AS Death_tot, (MAX(total_deaths)/MAX(total_cases))*100 AS Mortality_rate
FROM Covid_deaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY Mortality_rate DESC


--VIZUALIZATIONS

--BELGIUM
-- Population vs Total Cases (infected population) vs Total Deaths (death by covid compared to pop + to infected people) 
CREATE VIEW BELCasesVSDeaths AS 
SELECT date, total_cases, total_deaths, (total_deaths / total_cases)*100 AS Death_percent, icu_patients, hosp_patients, (icu_patients/hosp_patients)*100 AS ICU_percent 
FROM Covid_deaths
WHERE location LIKE 'Belgium' AND hosp_patients != 0


SELECT * 
FROM BELCasesVSDeaths


-- Total cases vs total hospital intakes
CREATE VIEW BELCasesVSHospIntakes AS 
SELECT date, total_cases, hosp_patients, (hosp_patients / total_cases)*100 AS Hospitalized_percent
FROM Covid_deaths
WHERE location LIKE 'Belgium'

SELECT * 
FROM BELCasesVSHospIntakes

-- Tests vs positive tests
CREATE VIEW BELTestsVSPositiveRate AS 
SELECT date, total_tests, new_tests, positive_rate
FROM Covid_vaccinations
WHERE location LIKE 'Belgium'

SELECT * 
FROM BELTestsVSPositiveRate

--Vaccine impact (pending method)
CREATE VIEW BELVaccineImpact AS 
SELECT Death.date, total_cases, new_cases, total_deaths, new_deaths, 
total_vaccinations, people_fully_vaccinated
FROM Covid_deaths AS Death
JOIN Covid_vaccinations AS Vaccine
	ON Death.location = Vaccine.location
	AND Death.date = Vaccine.date
WHERE Death.location LIKE 'Belgium'

SELECT * 
FROM BELVaccineImpact

--EUROPEAN UNION
CREATE VIEW EUCovidStats AS 
SELECT Death.location, MAX(population) AS Population, MAX(total_cases) AS Cases_tot, MAX(total_deaths) AS Death_Tot, (MAX(total_deaths) / MAX(total_cases))*100 AS Mortality_rate,
MAX(total_tests) AS Tests_total, MAX(people_fully_vaccinated) AS Pop_FullyVaccinated, (MAX(people_fully_vaccinated)/MAX(population))*100 AS TotVac_rate, MAX(population_density) AS Population_Density
FROM Covid_deaths AS Death
JOIN Covid_vaccinations AS Vaccine
	ON Death.location = Vaccine.location
WHERE Death.location IN ('Austria', 'Belgium', 'Bulgaria', 'Croatia', 'Cyprus', 'Czechia', 'Denmark', 'Estonia', 'Finland', 'France', 'Germany', 
'Greece', 'Hungary', 'Ireland', 'Italy', 'Latvia', 'Lithuania', 'Luxembourg', 'Malta', 'Netherlands', 'Poland', 'Portugal', 'Romania', 
'Slovakia', 'Slovenia', 'Spain', 'Sweden')
GROUP BY Death.location

SELECT * 
FROM EUCovidStats


--WORLD
-- World Mortality rate by descending rate
CREATE VIEW WorldCovidStats AS 
SELECT location, MAX(population) AS Population, MAX(total_cases) AS Cases_tot, MAX(total_deaths) AS Death_tot, (MAX(total_deaths)/MAX(total_cases))*100 AS Mortality_rate
FROM Covid_deaths
WHERE continent IS NOT NULL
GROUP BY location

SELECT * 
FROM WorldCovidStats
