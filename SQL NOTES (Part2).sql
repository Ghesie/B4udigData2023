INTERMEDIATE SQL NOTES:

JOINS:

1.1 INNER JOIN (common in both)

SELECT *
FROM Database . dbo . Table1-name / Column-name
Inner Join Database . dbo . Table2-name
    ON Table1-name . column-name = Table2-name . column-name //Common on both

ex:
SELECT *
FROM [SQL Tutorial].dbo.EmployeeDemographics
Inner Join [SQL Tutorial].dbo.EmployeeSalary
	ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID

result:
/will show all the values common in column name "EmployeeID" from both Tables
------------------------------------------------------------------------------------------------

UNION and UNION OPERATOR:

SELECT column-names-on-table1
FROM Table1-name

UNION

SELECT column-names-on-table2
FROM Table2-name

ex:

SELECT *
FROM [SQL Tutorial].dbo.EmployeeDemographics

UNION

SELECT *
FROM [SQL Tutorial].dbo.WareHouseEmployeeDemographics

result:
/will show the combination of all columns from both table eliminating the redundant data
------------------------------------------------------------------------------------------------

CASE STATEMENT:

SELECT column-name
CASE 
    WHEN condition THEN output
     ELSE output-if-condition-is-invalid
END

FROM Database . dbo . TableName

ex 1:

SELECT FirstName, LastName, Age,

CASE
     WHEN Age = 38 THEN 'Stanley'
     WHEN Age > 30 THEN 'Old'
     WHEN Age BETWEEN 27 AND 30 THEN 'Young'
     ELSE 'Baby'
END AS AgeType

FROM [SQL Tutorial].dbo.EmployeeDemographics
WHERE AGE IS NOT NULL
ORDER BY AGE

result:
/will show the output based on the condition
/ simmilar to fuction IF ELSE on C-Prog

NOTE:
WHEN = IF
ELSE = ELSE
THEN = PRINT or OUTPUT (New Column)


ex 2:

SELECT FirstName, LastName, JobTitle, Salary,
CASE
	WHEN JobTitle = 'Salesman' THEN Salary + (Salary * 0.1)
	WHEN JobTitle = 'Accountant' THEN Salary + (Salary * 0.05)
	WHEN JobTitle = 'Hr' THEN Salary + (Salary * 0.000001)
	ELSE Salary + (Salary * 0.03)
END AS NewSalary

FROM [SQL Tutorial].dbo.EmployeeDemographics
JOIN [SQL Tutorial].dbo.EmployeeSalary
	ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID

-----------------------------------------------------------------------------------------------

HAVING CLAUSE:
note:
can be use as WHARE on JOIN functions

SELECT  column
FROM Database . dbo . Table1-name / Column-name
JOIN Database . dbo . Table2-name
    ON Table1-name . column-name = Table2-name . column-name //Common on both
GROUP BY column
HAVING condition-like-WHERE-statement


ex1:
FROM [SQL Tutorial].dbo.EmployeeDemographics
JOIN [SQL Tutorial].dbo.EmployeeSalary
	ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
GROUP BY JobTitle
HAVING COUNT(JobTitle) > 1

result:
/ will show the JobTitle that has a count greater than 1

ex2:
SELECT  JobTitle, AVG(Salary)
FROM [SQL Tutorial].dbo.EmployeeDemographics
JOIN [SQL Tutorial].dbo.EmployeeSalary
	ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
GROUP BY JobTitle
HAVING AVG(Salary) > 45000
ORDER BY AVG(Salary)

result:
/will show the JobTitles with > 45000 average salary
-----------------------------------------------------------------------------------------------
UPDATING DELETING DATA

1.1 UPDATING

UPDATE Table-name
SET column-name = value-or-character-to-be-set
WHERE condition-to-specify-what-row-to-update

ex1:

UPDATE [SQL Tutorial].dbo.EmployeeDemographics
SET EmployeeID = 1012
WHERE FirstName = 'Holly' AND LastName = 'Flax'

result:
/will update the employeeID of the row that contains a name Holly Flax


ex2:

UPDATE [SQL Tutorial].dbo.EmployeeDemographics
SET Age = 31, Gender = 'Female'
WHERE FirstName = 'Holly' AND LastName = 'Flax'

result:
/will update the age and gender of the row that contains a name Holly Flax

1.2 DELETING

DELETE FROM database-name . dbo . Table-name
WHERE select-a-column-name = condition  /note opparation can be changed/

ex1:
DELETE FROM SQL Tutorial].dbo.EmployeeDemographics
WHERE EmployeeID = 1005

result:
/will delete the row that contains an EmployeeID of 1005

-----------------------------------------------------------------------------------------------

ALIASING
- Used to temporarily rename a column


ex1:
SELECT FirstName AS FName
FROM [SQL Tutorial].dbo.EmployeeDemographics

result:
/will rename the FirstName column to FName

ex2:
SELECT FirstName + ' ' + LastName AS FullName
FROM [SQL Tutorial].dbo.EmployeeDemographics

result:
/will combine the FirstName and LastName column and rename is as FullName

ALIASING FOR TABLE NAME:

SELECT Demo.Age
FROM [SQL Tutorial].dbo.EmployeeDemographics AS Demo

result:
/wil rename the table to "Demo" for shorter call
-----------------------------------------------------------------------------------------------

PARTITION BY
- Divide the results into partition
- Does not reduce the output

ex:
SELECT FirstName, LastName, Gender, Salary,
COUNT(Gender) OVER (PARTITION BY Gender) AS TotalGender
FROM [SQL Tutorial].dbo.EmployeeDemographics AS EmpDemo
JOIN [SQL Tutorial].dbo.EmployeeSalary AS EmpSal
	ON EmpDemo.EmployeeID = EmpSal.EmployeeID

result:
/will show the JOINED table while showing the total number of gender on each row
-----------------------------------------------------------------------------------------------

CTEs (Common Table Expressions)
- Used to manipulate the complex subquery data
- Temporary
- Data that can be call like a shortcut
- CTE is not stored on database
- Can only used one time

ex1:

--CTE

WITH CTE_Employee AS
(
SELECT FirstName, LastName, Gender, Salary,
COUNT(Gender) OVER (PARTITION BY Gender) as TotalGender,
AVG(Salary) OVER (PARTITION BY Gender) as AvgSalary
FROM [SQL Tutorial].dbo.EmployeeDemographics as Emp
JOIN [SQL Tutorial].dbo.EmployeeSalary as Sal	
	ON Emp.EmployeeID = Sal.EmployeeID
WHERE Salary > 45000
)

SELECT *
FROM CTE_Employee
-----------------------------------------------------------------------------------------------

TEMP TABLE
- Temporary table that can be used multiple time
- Like creating simple table for testing and calculation

NOTE:
----------
TO OVERWRITE TABLE:

DROP TABLE IF EXISTS #Temp_Tablename
----------


CREATE TABLE #Temp_Table name

(
column-1-name int,
column-2-name Varchar (50),
column-3-name Varchar (50),
)

Inserting data from TABLE to TempTable:

INSERT INTO #Temp_Table name
SELECT column-1-name , column-2-name
FROM Table-name


ex:
CREATE TABLE #Temp_Employee2
(
JobTitle varchar(50),
EmployeePerJob int,
AvgAge int,
AvgSalary int
)

INSERT INTO #Temp_Employee2
SELECT JobTitle, COUNT(JobTitle), Avg(Age), Avg(Salary)
FROM [SQL Tutorial]..EmployeeDemographics as Emp
JOIN [SQL Tutorial]..EmployeeSalary as Sal
	ON Emp.EmployeeID = Sal.EmployeeID
GROUP BY JobTitle

SELECT *
FROM #Temp_Employee2
-----------------------------------------------------------------------------------------------

STRING FUNCTIONS - TRIM, LTRIM, RTRIM, Replace, Substring, Upper, Lower

----------
1.1 TRIM, LTRIM, RTRIM:

ex:
SELECT EmployeeID, TRIM(EmployeeID) as IDTRIM
FROM EmployeeErrors

SELECT EmployeeID, LTRIM(EmployeeID) as IDTRIM
FROM EmployeeErrors

SELECT EmployeeID, RTRIM(EmployeeID) as IDTRIM
FROM EmployeeErrors

result:
/will remove the blank space on left or side of the selected word

---------
1.2 REPLACE:

ex:
SELECT LastName, Replace(LastName, '- Fired', ' ') as LastNameFixed
FROM EmployeeErrors

result:
/will replace the value of the selected cell
----------

1.3 SUBSTRING:

ex1:

SELECT Substring(FirstName, 1, 2)  //Substring(Column-name, Start, Number of string)
FROM EmployeeErrors

result:
/will show the value from the first character to 3rd character

----------
1.4 UPPER / LOWER:
- Used tp capitalized text

ex:
SELECT FirstName, LOWER(FirstName)
FROM EmployeeErrors

SELECT FirstName, UPPER(FirstName)
FROM EmployeeErrors

----------
-----------------------------------------------------------------------------------------------

STORED PROCEDURES:
- Used to store a command or operation that can be call using an EXEC syntax.

ex1:

CREATE PROCEDURE TEST
AS
SELECT *
FROM EmployeeDemographics

EXEC TEST

result:
/will show the given table

----------
ex2:


CREATE PROCEDURE Temp_Employee
AS
CREATE TABLE #Temp_Employee2
(
JobTitle varchar(100),
EmployeePerJob int,
AvgAge int,
AvgSalary int
)

INSERT INTO #Temp_Employee2
SELECT JobTitle, COUNT(JobTitle), Avg(Age), Avg(Salary)
FROM [SQL Tutorial]..EmployeeDemographics as Emp
JOIN [SQL Tutorial]..EmployeeSalary as Sal
	ON Emp.EmployeeID = Sal.EmployeeID
GROUP BY JobTitle

SELECT *
FROM #Temp_Employee2

EXEC Temp_Employee

NOTE: MODIFY THE POCEDURE
- You can modify the procedure and add a situation.

ex:
(Add an option to only show a specific jobtitle)

- under the ALTER PROCEDURE add:
--------------------------
@JobTitle nvarchar(100)

WHERE JobTitle = @JobTItle
--------------------------
EXEC Temp_Employee @JobTItle = 'HR'

result:
/will only show the HR row data

-----------------------------------------------------------------------------------------------

SUBQUERIES
- Use to return data that can be used in main query
- Call a data to create new datas

EXAMPLES are in the codes
