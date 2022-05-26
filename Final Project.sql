-- PART 1: DATA CLEANING AND WRANGLING 
/*joining tables together to create one tablefor adult arrests*/
CREATE VIEW adultarrests AS 
SELECT*FROM  adultarrests2019 
UNION
SELECT*FROM adultarrests2020
UNION
SELECT*FROM adultarrests2021;
/*joining tables together to create one table for juvenile arrests*/
CREATE VIEW juvenilearrests AS 
SELECT*FROM  juvjanjune19 
UNION
SELECT*FROM juvjulydec19
UNION
SELECT*FROM juvjanjune20
UNION
SELECT*FROM juvjulydec20
UNION
SELECT*FROM juvjanjune21
UNION
SELECT*FROM juvjanjune21;

/*delete empty rows*/
DELETE FROM juvjanjune21 WHERE arrest_date = '';
/* convert the date of all crime to datetime format */
-- ALTER TABLE allcrime
-- ADD report_date_converted date;
UPDATE allcrime set report_date = replace (report_date,',',''); 
UPDATE allcrime set report_date = replace (report_date,'AM',''); 
UPDATE allcrime set report_date = replace (report_date,'PM',''); 
UPDATE allcrime set report_date = replace (report_date,'/','-'); 
ALTER TABLE allcrime
ADD reportdate5 DATETIME;
UPDATE allcrime 
SET reportdate5 = STR_TO_DATE(report_date, "%m-%d-%Y %H:%i:%s"); 
-- create tables with union 
CREATE table juvenilearrests_all AS 
SELECT*FROM  juvjanjune19 
UNION
SELECT*FROM juvjulydec19
UNION
SELECT*FROM juvjanjune20
UNION
SELECT*FROM juvjulydec20
UNION
SELECT*FROM juvjanjune21
UNION
SELECT*FROM juvjanjune21;
CREATE TABLE adultarrests_all AS 
SELECT*FROM  adultarrests2019 
UNION
SELECT*FROM adultarrests2020
UNION
SELECT*FROM adultarrests2021;
-- Formatting the Dates 
UPDATE hatecrimes set Date_of_Offense = replace (Date_of_Offense,'/','-');
UPDATE hatecrimes set report_date = replace (report_date,'/','-');
UPDATE hatecrimes SET report_date = STR_TO_DATE(report_date, "%m-%d-%Y");
UPDATE hatecrimes SET Date_of_Offense = STR_TO_DATE(Date_of_Offense, "%m-%d-%Y");
UPDATE uoff2020  set IncidentDate = replace (IncidentDate,'/','-');
UPDATE uoff2020 SET IncidentDate = STR_TO_DATE(IncidentDate, "%m-%d-%Y");

UPDATE adultarrests_all set arrest_date = replace (arrest_date,'/','-');
UPDATE adultarrests_all
SET arrest_date = STR_TO_DATE(arrest_date, "%m-%d-%Y");
UPDATE adultarrests_all
SET arrest_year = STR_TO_DATE(arrest_year, "%Y");
UPDATE adultarrests_all set arrest_year = replace (arrest_year,'20190','2019');
UPDATE adultarrests_all set arrest_year = replace (arrest_year,'20200','2020');
UPDATE adultarrests_all set arrest_year = replace (arrest_year,'20210','2021');
SET arrest_year = STR_TO_DATE(arrest_year, "%Y");

-- PART 2: DATA ANALYSIS
create view CrimeTrends_2020 AS
SELECT offence, count(offence) as offence_count
FROM allcrime
WHERE crime_year = 2020
group by offence order by count(offence) desc;
--
create view CrimeTrends_2021 AS
SELECT offence, count(offence) as offence_count
FROM allcrime
WHERE crime_year = 2021
group by offence order by count(offence)  desc;
--
create view CrimeTrends_2022 AS
SELECT offence, count(offence) as offence_count 
FROM allcrime
WHERE crime_year = 2022
group by offence order by count(offence) desc;
-- join the views
CREATE VIEW crime_alloffences AS
select a.offence, a.offence_count AS offence_count_2020,
b.offence_count AS offence_count_2021,
c.offence_count AS offence_count_2022
FROM crimedc.CrimeTrends_2020 a 
left join crimedc.CrimeTrends_2021 b    
on a.offence = b.offence
left join crimedc.CrimeTrends_2022 c on a.offence = c.offence;

-- crime by count by year 
create view crime_count_byyear AS
select crime_year, count(crime_number)
from allcrime 
group by crime_year order by count(crime_number) desc; 
-- count crime by method used
select method_used, count(crime_number)
from allcrime 
group by method_used order by count(crime_number) desc; 

-- Adult arrests 
SELECT avg(age), count(arrest_id) as arrest_count
FROM crimedc.adultarrests_all;
SELECT age, count(arrest_id) as arrest_count
FROM crimedc.adultarrests_all
group by age;
-- create view Adult_Arrests_feq_race AS

-- top 5 type of adult arrests 
SELECT arrest_category, count(arrest_id) as arrest_count
FROM crimedc.adultarrests_all
group by arrest_category order by count(arrest_id)  desc
limit 5;

create view arrest_race_2020 AS
SELECT Defendant_race, count(arrest_id) as arrest_count
FROM adultarrests_all
WHERE arrest_year = 2020
group by Defendant_race
order by count(arrest_id) desc; 
-- arrest in 2021
create view arrest_race_2021 AS
SELECT Defendant_race, count(arrest_id) as arrest_count
FROM adultarrests_all
WHERE arrest_year = 2021
group by Defendant_race
order by count(arrest_id) desc; 
-- arrest 2019
create view arrest_race_2019 AS
SELECT Defendant_race, count(arrest_id) as arrest_count
FROM adultarrests_all
WHERE arrest_year = 2019
group by Defendant_race
order by count(arrest_id) desc; 

-- adult all arrest years by race 
CREATE VIEW arrest_allyears_race AS
select a.defendant_race, a.arrest_count AS arrest_count_2019,
b.arrest_count AS arrest_count_2020,
c.arrest_count AS arrest_count_2021
FROM crimedc.arrest_race_2019 a 
left join arrest_race_2020 b    
on a.defendant_race = b.defendant_race
left join crimedc.arrest_race_2021 c on a.defendant_race = c.defendant_race;

-- arrest by sex  
SELECT defendant_sex, count(arrest_id) as arrest_count
FROM crimedc.adultarrests_all
group by defendant_sex order by count(arrest_id)  desc;

-- arrest by arrest_category 
CREATE VIEW arrest_allyears_category AS
SELECT arrest_category, count(arrest_id) as arrest_count
FROM crimedc.adultarrests_all
where Defendant_sex = 'FEMALE'
group by arrest_category order by count(arrest_id)  desc;

-- HOMICDE ARREST 
SELECT defendant_sex, arrest_category, count(arrest_id) as arrest_count
FROM crimedc.adultarrests_all
where Arrest_category = 'Homicide'
group by Defendant_sex order by count(arrest_id)  desc;
SELECT distinct (age), defendant_sex, arrest_category, count(arrest_id) as arrest_count
FROM crimedc.adultarrests_all
where Arrest_category = 'Homicide' AND defendant_sex = 'FEMALE'
group by age order by count(arrest_id)  desc;
SELECT distinct (age), defendant_sex, arrest_category, count(arrest_id) as arrest_count
FROM crimedc.adultarrests_all
where Arrest_category = 'Homicide' AND defendant_sex = 'MALE'
group by age order by count(arrest_id)  desc;
-- AVG AGE HOMOCIDE DEFENDANT 
SELECT avg (age), defendant_sex, arrest_category
FROM crimedc.adultarrests_all
where Arrest_category = 'Homicide' AND defendant_sex = 'MALE';
SELECT avg (age), defendant_sex, arrest_category
FROM crimedc.adultarrests_all
where Arrest_category = 'Homicide' AND defendant_sex = 'FEMALE'; -- avg age for female defendant is 31 but for males it's 30
-- changing the dates juvenile_arrests
update juvenilearrests_all
set arrest_date = replace (arrest_date,'/','-');
update juvenilearrests_all 
SET arrest_date = STR_TO_DATE(arrest_date, "%m-%d-%Y"); 
ALTER TABLE juvenilearrests_all
ADD arrest_year YEAR;
UPDATE juvenilearrests_all
SET arrest_year = year(arrest_date); 

-- juvenile arrest 
-- juvenile arrest by year 
CREATE view juvenile_arrests_year AS
SELECT arrest_year,count(arrest_number) as arrest_count
FROM juvenilearrests_all
group by arrest_year;
-- arrest type  juvenile 
SELECT top_charge, count(arrest_number) as arrest_count
FROM juvenilearrests_all
group by top_charge order by count(arrest_number) desc
limit 5;
-- crime by count by year 
create view crime_count_byyear AS
select crime_year, count(crime_number)
from allcrime 
group by crime_year order by count(crime_number) desc; 

-- all crime by ward 
-- UPDATE allcrime set ward = replace (ward ,'0' ,'');
create view allcrime_byward AS
select ward, count(crime_number)
from allcrime 
where ward <> 0
group by ward order by count(crime_number) desc; 


-- adult arrests percent change from preCOVID to COVID
create view arrestcount_2019 AS
select arrest_category, count(arrest_id)as Arrest_2019_Count
from adultarrests_all
where arrest_year = 2019 
group by arrest_category order by count(Arrest_ID) desc;
create view arrestcount_2021 AS
select arrest_category, count(arrest_id)as Arrest_2021_Count
from adultarrests_all
where arrest_year = 2021 
group by arrest_category order by count(Arrest_ID) desc;
create view arrestcount_2021_2019 AS 
select a.arrest_category, a.arrest_2019_Count,
b.arrest_2021_Count
FROM crimedc.arrestcount_2019 a 
left join arrestcount_2021 b    
on a.arrest_category = b.arrest_category;
create view arrestcount_2021_2019_Diff AS
Select arrest_category, arrest_2019_count, arrest_2021_count, (arrest_2021_count - arrest_2019_count) as Arrest_COVID_Change
FROM arrestcount_2021_2019;

-- hate crime over the years, types of crimes  
create view hatecrime_type AS
select hate_bias_type, count(incident_number) as Number_Hate_Crimes_Type
from hatecrimes 
group by hate_bias_type order by count(incident_number) desc;
-- hate crimes : types of offence 
select top_offence, count(incident_number) as Number_Hate_Crimes_Offence
from hatecrimes 
group by top_offence order by count(incident_number) desc
limit 15;
-- number of hate crimes by year 
create view hatecrime_year AS
select report_year, count(incident_number) as Number_Hate_Crimes_Year 
from hatecrimes 
group by report_year order by count(incident_number) desc;

-- police use of force by officer race  
select officer_race, count(incident_number) as UoF_Incidents_Officer_Race
from uoff2020
group by officer_race order by count(incident_number) desc;
-- police ufe of force by officer gender 
select officer_gender, count(incident_number) as UoF_Incidents_Officer_Gender
from uoff2020
group by officer_gender order by count(incident_number) desc;
-- Use of Force by subject's race 
select subject_race, count(incident_number) as UoF_Incidents_Subject_Race
from uoff2020
group by subject_race order by count(incident_number) desc;

-- strategy used by officers 
select uof_type, count(incident_number) as UoF_Incidents_Strategy
from uoff2020
group by uof_type order by count(incident_number) desc;

-- joining hate crimes and all crime tables with matching CCNs 
CREATE TABLE hatecrimes_allcrime AS
select a.* , b.date_report, b.report_year, b.hate_bias_type, b.targeted_group, b.top_offence
FROM crimedc.allcrime a 
inner join crimedc.hatecrimes b   
on a.CCN = b.CCN_hatecrime;


