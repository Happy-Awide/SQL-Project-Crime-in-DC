# SQL Project 
This report seeks to provide insight on crime rates in Washington DC  using data on all crimes, adult and juvenile arrests, use of force by the police as well as hate crimes. The datasets used for this project are publicly available data provided by the Metropolitan Police Department (MPD), accessible on their websites. All the tables were downloaded in CSV formats. The All-Crime dataset used was obtained through the DC Crime Cards initiative which allows users to explore incidents reported over the past 2 years citywide. This initiative is also through (MPD) and allows for an updated dataset to be downloaded as a CSV file. 

Given  that datasets comprised of 12 tables (see Table 3)  , the first part of this project involved extensive time on data cleaning and wangling to create appropriate tables. The student used UNION to join all of the data from adult arrests and juvenile arrests into two respective tables. The 12 tables were turned into 6 tables appropriate for the data analysis (see ERD). Additionally, the data formatting for most of the tables included “/” as a separator which was not compatible for the data format required in SQL. I used UPDATE, SET, REPLACE, STR_TO_DATE, DATETIME, ALTER TABLE commands to address the data formatting and also remove the timestamp from the date. The final format of the dates in the table is "%Y-%M-%D”. Additionally, I removed empty rows that were added in the tables during the data import process. 

Most of the columns in the tables imported as TEXT or INT. The student changed the column names to provide unique names for each table, applied appropriate datatype, especially for dates and created a primary key based on the table. Given that the datasets were unique in all 5 tables, there was no foreign keys involved. The primary keys are auto incremented lists of each row. The primary key in the adult arrest table is arrest_ID, for all crime it’s crime_number, for juvenile arrests it’s arrest_number, for hate crime it’s incident_number and for Use of Force it’s incident_number.

Research Questions Answered by this Project 
1.	What are the trends is crime committed over the years?
2.	What types of crime are most frequent and by who? 
3.	What is the distribution of crime rates by Ward?
4.	What time of day are most crimes committed?
5.	What are the common methods used during reported incidences? 
6.	What is the difference between crime committed by adults vs. juveniles?
7.	What are the demographics of adult arrestees (race, age, gender)? 
8.	What are the most targeted groups of hate crimes? 
9.	What are the most common types of offences during hate crimes? 
10.	What are the demographics of police officers reported using force during incidents ? (Race, age, gender)
11.	What are the demographics of offenders in incidences of use of force by the police? (Race, age, gender)
12.	What strategies are most frequent in reported incidences of use of force by officers? 
