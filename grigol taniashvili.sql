use AdventureWorksDW2017
--
drop table [FactFinanceNew]
drop table [FactFinanceStatisticalNew]
--
select *
from [FactFinanceNew]
--
select *
from [FactFinanceStatisticalNew]
--
CREATE TABLE [dbo].[FactFinanceNew](
								     [ID] int identity(1,1) primary key
									,[FinanceKey] int 
									,[OrganizationKey] tinyint 
									,[DepartmentGroupKey] tinyint 
									,[ScenarioKey] tinyint 
									,[AccountKey] tinyint 
									,[Amount] int 
									,[Date] date
									,[DateKey] int 
									,[ScenarioName] nvarchar(50) 
									,[DepartmentGroupName] nvarchar(50) 
									,[AccountType] nvarchar(50) 
									,[OrganizationName] nvarchar(50) 
) 

CREATE TABLE [dbo].[FactFinanceStatisticalNew](
                                     [ID] int identity(1,1) primary key
									,[FinanceKey] int 
									,[OrganizationKey] tinyint 
									,[DepartmentGroupKey] tinyint 
									,[ScenarioKey] tinyint 
									,[AccountKey] tinyint 
									,[Amount] int 
									,[Date] date
									,[DateKey] int 
									,[ScenarioName] nvarchar(50) 
									,[DepartmentGroupName] nvarchar(50) 
									,[AccountType] nvarchar(50) 
									,[OrganizationName] nvarchar(50) 
) 
