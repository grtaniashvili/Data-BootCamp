/*1. გამოიყენეთ წინა დავალების მე-4-ამოცანის სკრიპტი: 
გამოიყენეთ ცხრილი : [AdventureWorks2017].[Sales].[Store], თითოეულ SalesPersonID ზე [Demographics] ველიდან წამოვიღოთ შემდეგი მნიშვნელობები : 
AnnualSales, AnnualRevenue, BankName, BusinessType,YearOpened ,  
SquareFeet,Brands,Internet 
XML- ის გაპარსვისას თითოეულ ველს შეუსაბამეთ სწორი ტიპი , ანუ ყველა ტექსტურად არ გვინდა. თუ მთელია ინტად გაპარსეთ, ტექსტური- ტექსტად. 
შექმენით ცხრილი AdventureWorks2017.dbo.Store , რომელშიც ჩავწერთ დაბრუნებულ შედეგს შემდეგი მოთხოვნების გათვალისწინებით : 
ველებს შეუსაბამეთ სწორი ტიპები; ( 1 ქულა ) 
ცხრილს დამატებით ჰქონდეს ID ველი, მთელი ტიპის, ავტომატურად გენერირებადი; ( 1  ქულა ) 
შექმენით ტრიგერი, რომელიც დაგვიბრუნებს ინფორმაციას, აღნიშნულ ცხრილში მოხდა ინსერტი, აფდეითი თუ დილეითი (5 ქულა); 
ცხრილში მონაცემების ინსერტის დროს მოხდეს ID ველის შევსებაც.( 1 ქულა ) დაადეთ ცხრილს კომპრესია (page); (1 ქულა) 
შექმენით კლასტერული ინდექსი ID ველზე; (1 ქულა) 
შექმენით არაკლასტერული ინდექსი YearOpened,BankName ველებზე ერთად; (1 ქულა) შეავსეთ შექმნილი ცხრილი ციკლის გამოყენებით (3 ქულა ) */
--
use AdventureWorks2017
--
create table Store_Demographics(
								ID int identity(1,1) --promery key  ავტომატურად დაადებს კლასტერდ ინდექსს ან ქვემოთ შევქმნი ხელით
							   ,AnnualSales int
							   ,AnnualRevenue int
							   ,BankName varchar(50)
							   ,BusinessType char(2)
							   ,YearOpened int
							   ,SquareFeet int
							   ,Brands varchar(10)
							   ,Internet varchar(10)
							   )
--
;with xmlnamespaces ('http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey' as t)
    insert into Store_Demographics(
									AnnualSales
								   ,AnnualRevenue
								   ,BankName
								   ,BusinessType
								   ,YearOpened 
								   ,SquareFeet
								   ,Brands 
								   ,Internet 
							       )
	select x.y.value('t:AnnualSales','int') AnnualSales
		  ,x.y.value('t:AnnualRevenue','int') AnnualRevenue
		  ,x.y.value('t:BankName','varchar(50)') BankName
		  ,x.y.value('t:BusinessType','char(2)') BusinessType
		  ,x.y.value('t:YearOpened','int') YearOpened
		  ,x.y.value('t:SquareFeet','int') SquareFeet
		  ,x.y.value('t:Brands','varchar(10)') Brands
		  ,x.y.value('t:Internet','varchar(10)') Internet
	from [AdventureWorks2017].[Sales].[Store] s
	cross apply s.Demographics.nodes('/t:StoreSurvey') as x(y)
--
--truncate table Store_Demographics
----
--select *
--from Store_Demographics
--
create or alter trigger tr_Store_Demographics
on dbo.Store_Demographics
after update, insert, delete
as
begin 
	--
	if exists (
				select 1
				from inserted
				)
		and exists (
					select 1
					from deleted
					)
			print 'Updated data in dbo.Store_Demographics table'
			--
	else if exists (
				select 1
				from deleted
				)
			print 'Deleted data in dbo.Store_Demographics table'
			--
	     else 
			print 'Inserted data in dbo.Store_Demographics table'
	--
end
--
set identity_insert Store_Demographics on
insert into Store_Demographics (ID,BankName)
values (1000,'AAA'),(2000,'BBB')
set identity_insert Store_Demographics off
--
update Store_Demographics
set BankName = 'CCC'
where BankName = 'BBB'
--
delete from Store_Demographics
where BankName in ('AAA','CCC')
--
alter table Store_Demographics REBUILD PARTITION = ALL  
WITH (DATA_COMPRESSION = page);  
--
create clustered index CI
on Store_Demographics (ID)
--
create nonclustered index NCI
on Store_Demographics(YearOpened,BankName)
--
declare @i int = 1, @b int = 100
begin
	--
	set identity_insert Store_Demographics on
	--
	while @i <= @b
		begin
			--
			insert into Store_Demographics (ID,AnnualRevenue)
			values (1000+@i,@i)
			--
			set @i = @i+1;
			--
		end
		set identity_insert Store_Demographics off
end
--
--2. განაახლეთ სტატისტიკები AdventureWorks2017 ბაზაში; (1 ქულა) 
--
use adventureworks2017
exec sys.sp_updatestats
--
/*3. გამოიყენეთ ცხრილი [AdventureWorks2017].[HumanResources].[JobCandidate] შექმენით ვიუ, რომელიც დანარჩენ ველებთან ერთად გამოიტანს 
: FirstName , LastName ველებს. არნისნული ველის მნიშვნელობები უნდა ამოვიღოთ Resume xml ტიპის ველიდან:  
(5 ქულა)*/
--
create view vu_JobCandidate
as
	with XMLNAMESPACES ('http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume' AS ns)
	select *
		  ,[Resume].query('(//ns:Name.First)').value('.[1]', 'nvarchar(100)') [First Name]
		  ,[Resume].query('(//ns:Name.Last)').value('.[1]', 'nvarchar(100)') [Last Name]
	from [AdventureWorks2017].[HumanResources].[JobCandidate]
--
select *
from vu_JobCandidate
--