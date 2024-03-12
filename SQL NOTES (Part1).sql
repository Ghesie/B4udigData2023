BASIC SQL NOTES:

CREATING TABLE:

CREATE TABLE Table name

(
column-1-name int,
column-2-name Varchar (50),
column-3-name Varchar (50),
)
---------------------------------------------------------------------------------------

INSERTING DATA TO THE TABLE:

INSERT INTO Table-Name VALUES
(

Insert-a-value , ' column-1 ' , ' column-2 '

)
---------------------------------------------------------------------------------------

DELETING DATA on the TABLE:

DELETE FROM database-name . dbo . Table-name
WHERE select-a-column-name = condition  /note opparation can be changed/
---------------------------------------------------------------------------------------

 SELECTING DATA using SELECT FROM : *,  TOP, DISTINCT, COUNT, AS, MAX, MIN, AVG

1.1:
SELECT column-or-row-to-select , another-column-or-row
FROM table-name-to-get-data

/note: * symbol means "ALL"/
/Result will show the selected rows or columns/

------------------------------------------------------------------

1.2: TOP

SELECT TOP number-of-rows-to-select
FROM table-name-to-get-data

ex:
SELECT TOP 5
FROM EmployeeDemographics

result:
/will show the top 5 columns of the table/

------------------------------------------------------------------
1.3: DISTINCT

SELECT DISTINCT name-of-row-or-column
FROM table-name-to-get-data

ex:

SELECT DISTINCT (GENDER)
FROM EmployeeDemographics

result:
/ will show all the unique values of GENDER column

Male
Female
SELECT TOP number-of-rows-to-select
FROM table-name-to-get-data

------------------------------------------------------------------

1.4 COUNT & AS

SELECT COUNT name-of-row-or-column AS name-you-want-to-assign
FROM table-name-to-get-data

ex:

SELECT COUNT (LastName) AS LastNameCount
FROM EmployeeDemographics

resutls:
/ will show the number of LastName on the table

------------------------------------------------------------------

1.5: MAX, MIN, AVG

SELECT MAX (name-of-row-or-column)
FROM table-name-to-get-data


ex:

SELECT MAX (Salary)
FROM EmployeeSalary

result:
/will show the maximum salary on the table

------------------------------------------------------------------

2.1: Using FROM to select database and table

FROM database-name . dbo . table-name

ex:

FROM SQL Tutorial.dbo.EmployeeSalary

result:
/will select the EmployeeSalary table under the SQL Tutorial database

------------------------------------------------------------------

Using WHERE statement: AND, OR, LIKE, NULL, NOT NULL, IN
//note: 
<> means "not equal to"
!= means "not equal to"
= means "equal to"

1.1:
SELECT what-to-select
FROM name-of-table
WHERE name-of-row-or-column

ex:
SELECT *  //select all
FROM EmployeeDemographics
WHERE FirstName = 'Jim'

1.2: AND, OR

ex1:
SELECT *  //select all
FROM EmployeeDemographics
WHERE AGE <= 32 OR Gender = 'Male'

result:
/ will show the rows with age lessthan or equal to 32 
and all the rows with male gender

ex2:
SELECT *  //select all
FROM EmployeeDemographics
WHERE AGE <= 32 AND Gender = 'Male'

resutl:
/will show the rows with age lessthan or equal to 32 with gender male

1.3: LIKE
//note:
S% - start with "S"
%S - ends with "S"
%S% - "S" on a word

ex:
SELECT *  //select all
FROM EmployeeDemographics
WHERE LastName LIKE 'S%'

result:
/will show all the rows with Lastname that start with an S

1.4: NULL, NOT NULL

ex:
SELECT *  //select all
FROM EmployeeDemographics
WHERE FristName is NOT NULL

result:
/will shot all the rows with not null cell

1.5: IN
//note: 
IN purpose is to shorten the code for too many = statement
ex:

SELECT *  //select all
FROM EmployeeDemographics
WHERE FristName IN ('Jim', 'Michael') 

// WHERE FristName = 'Jim', FirstName = 'Michael //

result:
/will show the row with firstname jim and michael

------------------------------------------------------------------

GROUP BY and ORDER BY

SELECT column-name
FROM Table-name
GROUP BY column-name
ORDER BY column-name

ex;
SELECT Gender, COUNT (Gender)
FROM EmployeeDemographics
WHERE Age > 31
GROUP BY Gender
ORDER BY Gender

result:
/will show all the gender on first column.
/will  show the count of gender with age greater than 31 on second column
