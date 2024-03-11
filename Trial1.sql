/*
WITH CTE_Test AS
(
select Name, SiteName, Status, JO, Date
FROM B4udig_Ghesie_2023

UNION ALL

select Name, SiteName, Status, JO, Date
FROM B4udig_David_2023

UNION ALL

select Name, SiteName, Status, JO, Date
FROM B4udig_Russel_2023
 )
 
 Select Name as TeamMember, MONTHNAME(Date) AS Month, COUNT(JO) AS MonthlyRequest
 From CTE_Test
 GROUP BY TeamMember, Month
 */
 DROP TABLE IF EXISTS CombinedTable;
 create TABLE CombinedTable
 ( 
   Name varchar(255),
   SiteName varchar(255),
   Stats varchar(255),
   JO decimal(20),
   Date Datetime
  )
 
 
INSERT INTO CombinedTable

   select Name, SiteName, Status, JO, Date
   FROM B4udig_Ghesie_2023
   
   UNION ALL
   
   select Name, SiteName, Status, JO, Date
   FROM B4udig_David_2023
   
   UNION ALL
   
   select Name, SiteName, Status, JO, Date
   FROM B4udig_Russel_2023
   
WITH CTE_Test AS
(
 Select Name as TeamMember, MONTHNAME(Date) AS Month, cOUNT(JO) AS MonthlyRequest
 From CombinedTable
 GROUP BY TeamMember, Month
 )
sELECT *
fROM CTE_Test
 
 
 sELECT *
 fROM 
 (
   SELECT TeamMember, Month, MonthlyRequest
   FROM CTE_Test
 ) AS SourceTable PIVOT(AVG(MonthlyRequest) FOR Month in (March,April,May,June,July,August,
                                                          September,October,November,December))
                                                          as PivotTable;
 

                        
 sELECT *
 fROM CTE_Test
 
