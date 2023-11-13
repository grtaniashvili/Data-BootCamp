--1. შექმენით ბაზა MyDatabase; განუსაზღვრეთ ზომები ფაილებს ზომები mdf –ზრდა 10% , ლიმიტი 1000 მბ; ldf – 120 მბ , ლიმიტი 500 მბ (2 ქულა)  
CREATE DATABASE [MyDatabase]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'MyDatabase', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\MyDatabase.mdf' , SIZE = 8192KB , MAXSIZE = 1024000KB , FILEGROWTH = 8%)
 LOG ON 
( NAME = N'MyDatabase_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\MyDatabase_log.ldf' , SIZE = 8192KB , MAXSIZE = 512000KB , FILEGROWTH = 122880KB )
GO
ALTER DATABASE [MyDatabase] SET COMPATIBILITY_LEVEL = 150
GO
ALTER DATABASE [MyDatabase] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [MyDatabase] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [MyDatabase] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [MyDatabase] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [MyDatabase] SET ARITHABORT OFF 
GO
ALTER DATABASE [MyDatabase] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [MyDatabase] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [MyDatabase] SET AUTO_CREATE_STATISTICS ON(INCREMENTAL = OFF)
GO
ALTER DATABASE [MyDatabase] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [MyDatabase] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [MyDatabase] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [MyDatabase] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [MyDatabase] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [MyDatabase] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [MyDatabase] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [MyDatabase] SET  DISABLE_BROKER 
GO
ALTER DATABASE [MyDatabase] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [MyDatabase] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [MyDatabase] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [MyDatabase] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [MyDatabase] SET  READ_WRITE 
GO
ALTER DATABASE [MyDatabase] SET RECOVERY FULL 
GO
ALTER DATABASE [MyDatabase] SET  MULTI_USER 
GO
ALTER DATABASE [MyDatabase] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [MyDatabase] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [MyDatabase] SET DELAYED_DURABILITY = DISABLED 
GO
USE [MyDatabase]
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = Off;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = Primary;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = On;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = Primary;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = Off;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = Primary;
GO
USE [MyDatabase]
GO
IF NOT EXISTS (SELECT name FROM sys.filegroups WHERE is_default=1 AND name = N'PRIMARY') ALTER DATABASE [MyDatabase] MODIFY FILEGROUP [PRIMARY] DEFAULT
GO

--2. აღნიშნულ ბაზაში შექმენით სქემა MySchema owner dbo (1 ქულა)
--
use [MyDatabase]
--
CREATE SCHEMA MySchema 
AUTHORIZATION dbo
--3. ამავე ბაზაში და სქემაში შექმენით ფუნქცია GetAge, რომელსაც გადავცემთ დაბადების თარიღს და დაგვიბრუნებს მიმდინარე მგომარეობით ასაკს (ანუ რამდენი წლისაა ადამიანი) - (3 ქულა) 
-- 
create or alter function GetAge(
					@bday date
					)
returns tinyint
as
begin
return DATEDIFF(year,@bday,getdate())
end
--
select dbo.GetAge('02-19-1994')

--
/*4. AdventureWorkDW2017 ბაზაში მყოფი view dbo.vTargetMail დაასელექთეთ ქვემოთ მოცემული პირობებით და ველებით : 
CustomerKey, 
GeographyKey, 
CustomerAlternateKey, 
FullName - ფუნქციის გამოყენებით შევაერთოთ ცხრილში არსებული ველები  FirstName და LastName , ტექსტი არ უნდა იყოს გადაბმულად, ანუ სახელს და გვარს შორის უნდა იყოს სფეისი, 
BirthDate, 
BirthYear- რომელ წელს დაიბადა, 
CustomerAge - ვიყენებთ მე-3-ე დავალებაში შექმნილ ფუნქციას, რომ დავითვალოთ ასაკი, ფუნქციას უნდა გადაეცემოდეს თითოეულ customer-ის დაბადების თარიღი და გვითვლიდეს ასაკს თითოეულ ქასთომერზე. 
YearIncome, - შემოწმდეს ველს თუ აქვს ცარიელი მნიშვნელობა, ჩაისვას 0, Phone, 
და ეს მონაცემები უნდა ჩავყაროთ MySchema. TargetMail ცხრილში. (5 ქულა) */
--
use AdventureWorksDW2017
--
select tm.CustomerKey
	,tm.GeographyKey 
	,tm.CustomerAlternateKey
	,tm.FirstName +' '+ tm.LastName FullName -- ფუნქციის გამოყენებით შევაერთოთ ცხრილში არსებული ველები  FirstName და LastName , ტექსტი არ უნდა იყოს გადაბმულად, ანუ სახელს და გვარს შორის უნდა იყოს სფეისი, 
	,tm.BirthDate
	,year(tm.BirthDate) BirthYear -- რომელ წელს დაიბადა, 
	,dbo.GetAge(tm.BirthDate) CustomerAge --- ვიყენებთ მე-3-ე დავალებაში შექმნილ ფუნქციას, რომ დავითვალოთ ასაკი, ფუნქციას უნდა გადაეცემოდეს თითოეულ customer-ის დაბადების თარიღი და გვითვლიდეს ასაკს თითოეულ ქასთომერზე. 
	,isnull(tm.YearlyIncome,0) [isnull] --- შემოწმდეს ველს თუ აქვს ცარიელი მნიშვნელობა, ჩაისვას 0, Phone,
	,tm.phone
into [MyDatabase].MySchema.TargetMail
from dbo.vTargetMail tm
--
--5. დაააფდეითეთ PhoneNumber ველი, ისეთ კლიენტებზე, ვისი სახელის იწყება M  სიმბოლოზე და გვარი მთავრდება n- ზე, გაითვალისწინეთ დიდი და პატარა სიმბოლოებიც; 1(11) უნდა შეიცვალოს 599 -ით (2 ქულა) 
--
update [MyDatabase].MySchema.TargetMail
set phone = stuff(phone,1,6,'599 ')
where upper(left(FullName,1))='M'
		and upper(right(FullName,1))='N'
--
/*6. თქვენივე შექმნილ სქემაში შექმენით ცხრილი AccountTypes. ველები:  
ID- ავტომატურად გენერირებადი, ყოველი ახალი ჩანაწერის ჩამატებისას, ავტომატურად იზრდება 1-ით. 
Description - ტექსტური; 
ჩაწერეთ ქვემოთ მოცემული მონაცემები ცხრილში: ს 
Description = ' Balance Sheet ' ; 
Description = ' Assets '; 
Description = ' Current Assets '; 
Description = ' Cash '; 
Description = ' Receivables '; 
Description = 'Trade Receivables '; 
Description = ' Other Receivables '; 
Description = ' Allowance for Bad Debt '; 
Description = ' Property, Plant, Equipment ';
Description = ' Land & Improvements '; 
Description = ' Buildings & Improvements '; 
Description = ' Machinery & Equipment '; 
Description = ' Office Furniture & Equipment '; 
აღნიშნულ ცხრილში Description- ველში მოაშორეთ სფეისები ( ასევე შუაშიც) მაგ, : ID=1 უნდა დარჩეს ‘BalanceSheet’ 
სფეისების მოშორების შემდეგ დააფდეითეთ ცხრილში ისეთი ველები, სადაც გამოიყენება &  სიმბოლო და ჩაანაცვლეთ ის And -ით. (5 ქულა) */
--
use [MyDatabase]
--
create table MySchema.AccountTypes(ID int identity(1,1)
							,[Description] varchar(100)
)
--
insert into MySchema.AccountTypes([Description])
values (' Balance Sheet ')
		,(' Assets ')
		,(' Current Assets ')
		,(' Cash ')
		,(' Receivables ')
		,('Trade Receivables ')
		,(' Other Receivables ')
		,(' Allowance for Bad Debt ')
		,(' Property, Plant, Equipment ')
		,(' Land & Improvements ')
		,(' Buildings & Improvements ')
		,(' Machinery & Equipment ')
		,(' Office Furniture & Equipment ')
--
update MySchema.AccountTypes
set [Description] = replace(replace(replace([Description],' ',''),char(9),''),'&','and')
--
/*7. SELECT [ModifiedDate] 
 ,[OrderQty] 
 ,[ProductID] 
 , UnitPrice 
 FROM [AdventureWorks2017].[Sales].[SalesOrderDetail] 
 ORDER BY ProductID 
 აღნიშნული სელექთიდან, თითოეულ პროდუქტზე წლისა და თვის ჭრილში დათვალეთ რამდენი პროდუქტი გაიყიდა და ჯამური თანხა; 
 ანუ პროდუქტის, წლის და თვის კომბინაცია უნდა იყოს უნიკალური, ანუ თითო ჩანაწერი უნდა გვქონდეს და მათ გასწვრივ ეწეროს შესაბამისი თანხა.( 3 ქულა)*/
  --
SELECT year([ModifiedDate]) [year]
	,month([ModifiedDate]) [month] 
	,sum([OrderQty]) [raodenoba]
	,[ProductID] 
	,sum(UnitPrice) [sumPrice]
FROM [AdventureWorks2017].[Sales].[SalesOrderDetail] 
group by year([ModifiedDate])
		,month([ModifiedDate])
		,ProductID
order by 4,1,2
--
--8. გამოიყენეთ ცხრილი : [AdventureWorks2017].[Sales].[SalesOrderDetail] დაამატეთ 1 ველი სელექთს და აჩვენეთ პროდუქტების გადანომვრა, ისე, რომ თითოეულ პროდუქტზე ModifiedDate-ის შეცვლაზე, ნუმერაცია იწყებოდეს 1 დან და იზრდებოდეს 1-ით. (2 ქულა) 
--
select *, dense_rank() over (PARTITION BY ModifiedDate order by ProductID) AS Rank  
from [AdventureWorks2017].[Sales].[SalesOrderDetail]
--
/*9. შექმენით ცხრილი StudentPoints ველებით : სტუდენტის სახელი, საგნის დასახელება, ქულა; შეიყვანეთ ცხრილში მონაცემები, მინიმუმ 3 სტუდენტი, თითოეულ სტუდენტზე მინიმუმ 3  საგანი, ქულები. (2 ქულა) 
გადანომრეთ ჩანაწერები ქულების მიხედვით, ზრდადობით (1 ქულა) – 
გადანომრეთ სტუდენტის ქულები ისე, რომ ათვლა იწყებოდეს თითოეულ სტუდენტზე ახალი ნუმერაციით. ქულები უნდა ითვლებოდეს კლების მიხედვით. (2 ქულა)
გამოთვალეთ სტუდენტის საშუალო ქულა; ველები :სტუდენტი, საშუალო ქულა (1 ქულა)
აჩვენეთ თითოეული სტუდენტის მაქსიმალური ქულა (1 ქულა) */
--
use MyDatabase
--
create table StudentPoints(StudentName varchar(50)
							,SubjectName varchar(30)
							,Mark tinyint
							)
--
insert into StudentPoints
values('Grigol Taniashvili', 'Physics', 100)
		,('Grigol Taniashvili', 'Hystory', 34)
		,('Grigol Taniashvili', 'Chemistry', 56)
		,('Grigol Papalshvili', 'Physics', 65)
		,('Grigol Papalshvili', 'Geography', 45)
		,('Grigol Papalshvili', 'MAth', 46)
		,('natia Gogua', 'Chemistry', 76)
		,('natia Gogua', 'Math', 98)
		,('natia Gogua', 'IST', 23)
		,('Teo Rurua', 'History', 12)
		,('Teo Rurua', 'Georaphy', 11)
		,('Teo Rurua', 'Math', 89)

--
select *
	,rank() over (order BY sp.Mark) AS Rank  
from StudentPoints sp
--
select *
	,dense_rank() over (PARTITION BY sp.StudentName ORDER BY sp.mark desc) AS Rank  
from StudentPoints sp
--
select sp.StudentName
		,avg(mark) [AVG Mark]
from StudentPoints sp
group by sp.StudentName
--
select sp.StudentName
		,max(mark) [MAX Mark]
from StudentPoints sp
group by sp.StudentName
--
/*10. ნორმალიზაციის წესებიტ დაცვით შექმენით ქვემოთ მოცემული ცხრილები, საჭიროებისამებრ დაამატეთ ახალი ობიექტები და შეავსეთ (3 ქულა) 1. Book ველები :  
ID- ავტომატურად გენერირებადი ველი,ყოველი ახალი ჩანაწერის დამატებისას გაიზარდოს 1 ით; 
Name - ტექსტური, ნებისმიერ ენაზე შეიძლება იყოს 
2. Author ველები :  
ID - ავტომატურად გენერირებადი ველი, ყოველი ახალი ჩანაწერის დამატებისას გაიზარდოს 1 ით; 
Firstname,  
Lastname,  
Birthdate 
გარე გასაღების სწორად დადება - 1 ქულა
Primary Key – 1 ქულა
*/
-- 
use MyDatabase
--
create table Book(ID int identity(1,1) primary key
				,Name nvarchar(20) not null
				,AuthorID int not null
				)
--
create table Author(ID int identity(1,1) primary key
				,FirstName varchar(20) not null
				,LastName varchar(30) not null
				,BirthDate date not null
				)
--
insert into Book(Name,AuthorID)
values ('Book1',1),('Book2',1),('Book2',2),('Book2',3),('Book4',3),('Book5',2),('Book6',2),('Book7',1)
--
insert into Author(FirstName
				,LastName
				,BirthDate
				)
values('Nini'
		,'Papava'
		,'02-04-1993'
		)
		,('Nini'
		,'Papava'
		,'02-04-1993'
		)
		,('Teo'
		,'Papava'
		,'02-04-2001'
		)
		,('Nini'
		,'Gugua'
		,'02-04-1987'
		)
		,('Ana'
		,'Lorenz'
		,'02-05-2001'
		)

--
alter table Book
add constraint Book_U1 unique (ID, name)
--
alter table Author
add constraint Author_U1 unique (ID, FirstName, LastName)
--
alter table Book
add constraint Book_FK1 foreign key (AuthorID) references Author (ID)


