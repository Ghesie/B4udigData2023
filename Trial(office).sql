DROP TABLE IF EXISTS Temp_TotalB4udigOutput
Create Table Temp_TotalB4udigOutput
(
Name nvarchar(255),
SiteName nvarchar(255),
Status nvarchar(255),
JO float,
Date datetime
)

Insert Into Temp_TotalB4udigOutput
Select Ghes.Name, Ghes.SiteName, Ghes.Status, Ghes.JO, Ghes.Date 
From B4udig_Ghesie as Ghes
Where Name Is Not Null

UNION ALL

Select Nik.Name, Nik.SiteName, Nik.Status, Nik.JO, Nik.Date
From B4udig_Nikko as Nik
Where Name Is Not Null

UNION ALL

Select Rus.Name, Rus.SiteName, Rus.Status, Rus.JO, Rus.Date
From B4udig_Russel as Rus
Where Name Is Not Null

UNION ALL

Select Dav.Name, Dav.SiteName, Dav.Status, Dav.JO, Dav.Date
From B4udig_David as Dav
Where Name Is Not Null

Select Name as Team_Member, COUNT(JO) as Total_Output
From Temp_TotalB4udigOutput
GROUP BY Name

--Create 2nd temp table 

Create Table Temp_TrialTable
(
Name nvarchar(255),
Month nvarchar(255),
Monthly_B4udig_Request int
)

Insert into Temp_TrialTable
Select Name, DATENAME(Month, Date) as Month, COUNT(JO) as Monthly_B4udig_Request
From Temp_TotalB4udigOutput

Group By Name, DATENAME(Month, Date)
Order By Name, DATENAME(Month, Date)

Select *
From 
 (
   Select Name as TeamMember, Month, Monthly_B4udig_Request
   From Temp_TrialTable
 ) as SourceTable PIVOT(AVG(Monthly_B4udig_Request) For Month in (January,February,March,April,May,June,July,August,September,October,November,December)) as PivotTable;


--4: Average B4uig Request of each team member daily
With CTE_Requests as
(
select Name as TeamMember,Date, count(JO) AS Request
From Temp_TotalB4udigOutput
Group by Name, Date
)
/*
select *
From CTE_Requests*/

select TeamMember, AVG(Request) AS DailyAve
From CTE_Requests
Group by TeamMember

--5: Total B4udig Reuest of the Team on year 2023

Select DATEPART(Year, Date) as Year, count(JO) as TotalB4udigRequest
FRom Temp_TotalB4udigOutput
Group by DATEPART(Year, Date)

--6: Completion rate of B4udig Request Per Person

--6.1: Create TempTable for completed requests
DROP TABLE IF EXISTS Temp_Completed
Create Table Temp_Completed
(
TeamMember nvarchar(255),
Request_With_Complete_Plans int,
)

Insert into Temp_Completed
select Name as TeamMember, Count(Status) as Request_With_Complete_Plans
FROM Temp_TotalB4udigOutput
WHERE Status='Completed'
GROUP by Name
 
--6.2: Create TempTable for pending requests
DROP TABLE IF EXISTS Temp_Pending
Create Table Temp_Pending
(
TeamMember nvarchar(255),
Request_With_Pending_Plans int,
)
insert into Temp_Pending
select Name as TeamMember, Count(Status) as Request_With_Pending_Plans
FROM Temp_TotalB4udigOutput
WHERE Status='Pending'
GROUP by Name

SELECT Name as TeamMember, Count(JO) as Total_Req
FROM Temp_TotalB4udigOutput
GROUP BY Name

with CTE_CompletionRate as 
(
Select Temp_Completed.TeamMember, Request_With_Complete_Plans, Request_With_Pending_Plans
From Temp_Completed
JOIN Temp_Pending on Temp_Completed.TeamMember = Temp_Pending.TeamMember
--ORder by Temp_Completed.TeamMember
)
Select *, (CAST(Request_With_Complete_Plans/SUM(Request_With_Complete_Plans + Request_With_Pending_Plans)AS NUMERIC))*100 as Percentage
From CTE_CompletionRate
Group By TeamMember, Request_With_Complete_Plans, Request_With_Pending_Plans
