Select *
From b4udigData2023..[B4udig_Nikko(2023)]

Select *
From b4udigData2023..[B4udig_Ghesie(2023)]

Select *
From b4udigData2023..[B4udig_Russel(2023)]

Select *
From b4udigData2023..[B4udig_David(2023)]


-- TOTAL B4UDIG OUTPUT (Union 4 tables)

Select Ghes.Name, Ghes.SiteName, Ghes.Status, Ghes.JO, Ghes.Date 
From b4udigData2023..B4udig_Ghesie as Ghes
Where Name Is Not Null

UNION ALL

Select Nik.Name, Nik.SiteName, Nik.Status, Nik.JO, Nik.Date
From b4udigData2023..B4udig_Nikko as Nik
Where Name Is Not Null

UNION ALL

Select Rus.Name, Rus.SiteName, Rus.Status, Rus.JO, Rus.Date
From b4udigData2023..B4udig_Russel as Rus
Where Name Is Not Null

UNION ALL

Select Dav.Name, Dav.SiteName, Dav.Status, Dav.JO, Dav.Date
From b4udigData2023..B4udig_David as Dav
Where Name Is Not Null

ORDER BY Date



-- Create Temp Table for TOTAL B4UDIG OUTPUT

DROP TABLE IF EXISTS #Temp_TotalB4udigOutput

Create Table #Temp_TotalB4udigOutput
(
Name nvarchar(255),
SiteName nvarchar(255),
Status nvarchar(255),
JO float,
Date datetime
)

Insert Into #Temp_TotalB4udigOutput
Select Ghes.Name, Ghes.SiteName, Ghes.Status, Ghes.JO, Ghes.Date 
From b4udigData2023..B4udig_Ghesie as Ghes
Where Name Is Not Null

UNION ALL

Select Nik.Name, Nik.SiteName, Nik.Status, Nik.JO, Nik.Date
From b4udigData2023..B4udig_Nikko as Nik
Where Name Is Not Null

UNION ALL

Select Rus.Name, Rus.SiteName, Rus.Status, Rus.JO, Rus.Date
From b4udigData2023..B4udig_Russel as Rus
Where Name Is Not Null

UNION ALL

Select Dav.Name, Dav.SiteName, Dav.Status, Dav.JO, Dav.Date
From b4udigData2023..B4udig_David as Dav
Where Name Is Not Null


Select *
From #Temp_TotalB4udigOutput

--1: Total B4udig Request Per Person (DONE)

Select Name as Team_Member, COUNT(JO) as Total_Output
From #Temp_TotalB4udigOutput
GROUP BY Name


--2: Showing the monthly b4udig request of each member

--2.1: Creating a Temp table of monthly b4udig request for future reference (Step 1)
DROP TABLE IF EXISTS #Temp_TrialTable

Create Table #Temp_TrialTable
(
Name nvarchar(255),
Month nvarchar(255),
Monthly_B4udig_Request int
)

Insert into #Temp_TrialTable
Select Name, DATENAME(Month, Date) as Month, COUNT(JO) as Monthly_B4udig_Request
From #Temp_TotalB4udigOutput

Group By Name, DATENAME(Month, Date)
Order By Name, DATENAME(Month, Date)


Select *
From #Temp_TrialTable
Order By Name

--2.2: Showing Monthly B4udig Request per member (FINAL)
Select *
From 
 (
   Select Name as TeamMember, Month, Monthly_B4udig_Request
   From #Temp_TrialTable
 ) as SourceTable PIVOT(AVG(Monthly_B4udig_Request) For Month in (January,February,March,April,May,June,July,August,September,October,November,December)) as PivotTable;

 -- Trial below
With CTE_PivotTable as
 (
Select *
From 
 (
   Select Name as TeamMember, Month, Monthly_B4udig_Request
   From #Temp_TrialTable
 ) as SourceTable PIVOT(MAX(Monthly_B4udig_Request) For Month in (January,February,March,April,May,June,July,August,September,October,November,December)) as PivotTable
)

Select *,
Case
	When January is Null Then 'tite'
End as mm

From CTE_PivotTable

--3: Showing the average monthly b4udig request of each team member

Select Name as Team_Member, AVG(Monthly_B4udig_Request) as Average_Monthly_B4udig_Request
From #Temp_TrialTable
Group by Name











--4: Average B4uig Request of each team member daily








--5: Total B4udig Reuest of the Team on year 2023


-- Completion rate of B4udig Request Per Person


-- Completion Rate of B4udig Request of the Team
