/*1. შექმენით DateFill პროცედურა,რომელსაც გადავცემთ 2 პარამეტრს @StartDate და @EndDate; 
@EndDate-ს დეფოლტად ჰქონდეს მიმდინარე თარიღი ( რა რიცხვიცაა დღეს). 
პროცედურა უნდა ავსებდეს [Date] ცხრილს, გადაცემული პარამეტრების მიხედვით. მაგ. თუ გადავცემთ
StartDate= 20210101 და EndDate= 20210131 მაშინ ცხრილში ციკლის გამოყენებით ჩაიწეროს 1-დან 31 ჩთ დღეები. 
ციკლში ჩავდოთ ასეთი შეზღუდვა, რომ თუ ცხრილის შევსებისას შეგვხვდება თარიღი 20120201, მაშინ ეს თარიღი გამოტოვოს და არ ჩაიწეროს ცხრილში; 
ასევე, თუ თარიღი იქნება 20140701 -ს მაშინ შეწყდეს ციკლი; 
ცხრილს უნდა ჰქონდეს შემდეგი ველები:  
ID - მთელი ტიპის, რომელიც ყოველი ჩანაწერის დამატებისას იზრდება 1 -ით; Date - DATE ტიპის არაცარიელი; 
IsEndOfMonth - რომელსაც აქვს მნიშვნელობა 1 ან 0 არაცარიელი; თუ თვის ბოლოა, ცხრილის შევსების დროს ჩაიწეროს 1 იანი, თუ არადა, 0 ; ) 
პროცედურაში ჩავდოთ ასეთი ლოგიკაც : 
რა პარამეტრებიც პროცედურას გადაეცემა, თუ ამ პარამეტრებზე Date ცხრილში ჩანაწერი უკვე არსებობს ( ანუ დღეები უკვე შევსებულია), 
ცხრილიდან წაიშალოს ამ თარიღებზე ჩანაწერები და ახლიდან შეივსოს; ( რადგან არ მოხდეს მონაცემების გადუბლირება ) ; 
შეავსეთ ცხრილი 2011-05-31 დან 2014-07-31 ჩათვლით 
(5 ქულა) */
--
use AdventureWorks2017
--
create table [Date](
					ID int identity(1,1)
					,[Date] date not null
					,IsEndOfMonth tinyint
					)
--
create or alter proc DateFill(
							  @StartDate date
							  ,@EndDate date =  getdate
							  )
	as
begin
	declare @i int = 0
	declare @a tinyint
	while DATEDIFF(DAY,dateadd(DAY,@i,@StartDate),@EndDate) >= 0
		begin
			--
			if (dateadd(DAY,@i,@StartDate) = eomonth(dateadd(DAY,@i,@StartDate)))
						set @a=1
						else
							set @a=0
			--
			if exists (select 1 
					   from [date] d
					   where d.Date = dateadd(DAY,@i,@StartDate)
					   )
				delete from [date] 
				where date=dateadd(DAY,@i,@StartDate)
			--
			if dateadd(DAY,@i,@StartDate) != '20120201'
			--
			
				insert into [Date](
									[Date]
									,IsEndOfMonth
									)
				values(
						dateadd(DAY,@i,@StartDate)
						,@a
					 )
			--
				 
			set @i = @i + 1
			--
			if dateadd(DAY,@i,@StartDate) = '20140701'
				break
				else 
				continue
			
        end
end
--
truncate table date
--
select *
from Date
--
exec DateFill '2011-05-31','2014-07-31'
--
/*2. შექმენით view, რომელიც დააბრუნებს [AdventureWorksDW2017].[dbo].[DimCustomer]  ცხრილიდან საჭირო ინფორმაციას : 
 [CustomerKey], 
 [GeographyKey],  
 City,([dbo].[DimGeography] ცხრილიდან) 
 [EnglishCountryRegionName] ([dbo].[DimGeography] ცხრილიდან) 
BirthDate, (აქ დავწეროთ პირობა , რომ თუ დაბადების წელი <1940-ზე, მაშინ ყველა ასეთ CUSTOMER-ს დაბადების თარიღად დაეწეროს 19500101 წელი) (1 ქულა)  
Age ( customer-ების ასაკი, აქვე გამოვიყენოთ BirthDate - ში ჩადებული ლოგიკაც ) (1 ქულა)  CustomerName ( [FirstName] და [LastName] -ველების გაერთიანება,
sql-ის ჩაშენებული ფუნქციის საშუალებით , სახელსა და გვარს შორის იყოს სფეისი) ( სულ - 5 ქულა)  */
--
create or alter view v_test1
	as
select dc.CustomerKey
	  ,dc.GeographyKey
	  ,dg.City
	  ,dg.EnglishCountryRegionName	  
	  ,'19500101' BirthDay
	  ,DATEDIFF(DAY,'19500101',getdate())/365 Age
	  ,concat_ws(' ',dc.FirstName,dc.LastName) FullName
from [AdventureWorksDW2017].[dbo].[DimCustomer] dc
join [AdventureWorksDW2017].[dbo].[DimGeography] dg
on dc.GeographyKey = dg.GeographyKey
where year(dc.BirthDate) < 1940
union
select dc.CustomerKey
	  ,dc.GeographyKey
	  ,dg.City
	  ,dg.EnglishCountryRegionName	  
	  ,dc.BirthDate
	  ,DATEDIFF(DAY,dc.BirthDate,getdate())/365 Age
	  ,concat_ws(' ',dc.FirstName,dc.LastName) FullName
from [AdventureWorksDW2017].[dbo].[DimCustomer] dc
join [AdventureWorksDW2017].[dbo].[DimGeography] dg
on dc.GeographyKey = dg.GeographyKey
where year(dc.BirthDate) >= 1940

--
select *
from v_test1
--
/*3. გამოვიყენოთ ქვემოთ მოცემული სკრიპტი :  
DECLARE @StartDate DATE= '20020101', 
@EndDate Date = '20140630' 
--Create temp table with new ModifedDates 
SELECT ProductID 
,[AdventureWorks2017].dbo.LastDateOfMonth(ModifiedDate) AS ModifiedDate  
,UnitPrice  
,OrderQty  
INTO #SalesOrderDetail 
FROM [AdventureWorks2017].[Sales].[SalesOrderDetail] AS SOD  
WHERE SOD.ModifiedDate BETWEEN @StartDate AND @EndDate
SELECT ProductID 
,ModifiedDate 
,SUM(UnitPrice * OrderQty) SalesAmount  
,(SUM(UnitPrice * OrderQty) - LAG(SUM(UnitPrice * OrderQty),1,0) OVER (PARTITION BY ProductID ORDER BY ModifiedDate)) AS NetSalesAmount 
into #SalesOrderGrouped 
FROM #SalesOrderDetail 
GROUP BY ProductID 
,ModifiedDate 
მიღებულ #SalesOrderGrouped ცხრილში გამოტოვებულია ზოგიერთი თვის ბოლო თარიღი. მაგ. ProductID=707 -ზე თარიღში 
გვიბრუნდება 2011-05-31, 2011-07-31... , აქ არაა ინფორმაცია 2011-06-30  რიცხვზე. 
პირველ დავალებაში შექმნილი [Date] ცხრილის გამოყენებით, თითოეული პროდუქტისთვის შეავსეთ გამოტოვებული დღეები, 
ხოლო თანხობრივ ველებში ჩაუწერეთ 0; ამის შემდეგ გააკეთეთ სხვაობა ყოველ თვეზე წინა თვის ნავაჭრთან და პროცედურას დააბრუნებინეთ მიღებული შედეგი. (5 ქულა)  */

create or alter proc insertporc
as
begin
	--
	DECLARE @StartDate DATE= '20020101', 
	@EndDate Date = '20140630' 
	--Create temp table with new ModifedDates 
	SELECT ProductID 
		  ,[AdventureWorks2017].dbo.Last_Day_Month(ModifiedDate) AS ModifiedDate  
		  ,UnitPrice  
		  ,OrderQty  
	INTO #SalesOrderDetail 
	FROM [AdventureWorks2017].[Sales].[SalesOrderDetail] AS SOD  
	WHERE SOD.ModifiedDate BETWEEN @StartDate AND @EndDate
	--
	SELECT ProductID 
		  ,ModifiedDate 
		  ,SUM(UnitPrice * OrderQty) SalesAmount  
		  ,(SUM(UnitPrice * OrderQty) - LAG(SUM(UnitPrice * OrderQty),1,0) OVER (PARTITION BY ProductID ORDER BY ModifiedDate)) AS NetSalesAmount 
	into #SalesOrderGrouped 
	FROM #SalesOrderDetail 
	GROUP BY ProductID 
			,ModifiedDate 

--

	declare @ID int = 707
	--
	while @ID <= 999
	begin
		--
		if exists (select 1
				   from #SalesOrderGrouped 
				   where ProductID = @ID )
		--
			insert into #SalesOrderGrouped 
				select  @ID ProductID
						,d.Date ModifiedDate
						,0 SalesAmount
						,0 NetSalesAmount
				from date d
				where d.IsEndOfMonth=1
				except
				select  @ID ProductID
						,a.ModifiedDate 
						,0 SalesAmount
						,0 NetSalesAmount
				from #SalesOrderGrouped a
				where a.ProductID =  @ID
				--
			set @ID = @ID +1
			--
		end
		--
		--
		select sog.ProductID
			  ,sog.ModifiedDate
			  ,sog.SalesAmount
			  ,sog.SalesAmount - LAG(sog.SalesAmount,1,0) OVER (PARTITION BY ProductID ORDER BY ModifiedDate) NetSalesAmount
		from #SalesOrderGrouped sog
	--
end
--
exec insertporc
--

/*4. ტრანზაქციის გამოყენებით ჩაწერეთ თქვენ მიერ შექმნილ Date ცხრილში გამოტოვებული რიცხვები 20120201 და 20140701;  
თუ ტრანზაქცია წარმატებით ან წარუმატებლად შესრულდება, დააბრუნოს მესიჯი (ტექსტი თქვენ განუსაზღვრეთ) . 
!!! სკრიპტებში გამოიყენეთ ბრძანება, რომელიც დაუქომითებელი მონაცემების წაკითხვის საშუალებას მოგვცემს.*/
--
begin tran nolock
	--
	BEGIN TRY  
		insert into date([Date])  
			values ('20120201')
			      ,('20140701')
		 print 'Done'
	END TRY 
	--
	BEGIN CATCH  
		 print'Error Inserting'
	END CATCH;
	--
--rollback tran
--
select *
from date
where date in ('20120201','20140701')


