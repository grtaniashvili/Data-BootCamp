/*1. შექმენიტ ტრიგერი ცხრილისთვის 
AdventureWorks2017].[HumanResources].[Employee], რომელიც აკრძალავს ცხრილში მონაცემების აფდეითს და ინსერტს. 
ეკრანზე უნდ აგამოვიდეს შეტყობინება, რომ შეუძლებელია ოპერაციის შესრულება და არ შესრულდეს ინსერტი და აფდეითი აღნიშნულ ცხრილზე (5 ქულა) */
--
use AdventureWorks2017
--
select *
from [AdventureWorks2017].[HumanResources].[Employee]
--
create trigger tr_emp
on [HumanResources].[Employee]
instead of update, insert
as
begin
	--
	set nocount on;
	--
	print 'Action is denied' 
	--
end
--
update [AdventureWorks2017].[HumanResources].[Employee]
set JobTitle = 'DDD'
where BusinessEntityID = 1
--
--2. შექმენით ტრიგერი, რომელიც გვიჩვენებს, რომ ყოველი ჩანაწერის ინსერტისას ან წაშლისას dbo.Date ცხრილში მოხდა ინსერტი ან დილეითი ( 5 ქულა)
--
drop table if exists log_date
--
create table log_date(
						ID int
						,date date
						,IsEndofMonth char(1)
						,log_time date
						,log_user nvarchar(100)
						,log_type char(1)
						)
--
create trigger tr_date
on dbo.date
for insert, delete
as
begin
	--
	set nocount on;
	--
	insert into dbo.log_date
	select i.id
		  ,i.date
		  ,i.IsEndOfMonth
		  ,getdate()
		  ,SUSER_NAME()
		  ,'I'
	from inserted i
	--
	insert into dbo.log_date
	select d.id
		  ,d.date
		  ,d.IsEndOfMonth
		  ,getdate()
		  ,SUSER_NAME()
		  ,'D'
	from deleted d
	--
end
--
exec DateFillUsingCTE '2011-06-25','2011-08-31'
--
delete from dbo.date
where id < 400
--
insert into date (Date)
values (getdate())
--
select *
from date
--
select *
from log_date
--
/*3. გამოიყენეთ ცხრილი [AdventureWorks2017].[Person].[Person], და შექმენით xml ტიპის ველი, სადაც მთავარი ტეგი იქნება Person, და ტეგის ჩაშლა იქნება : 
	<PersonsInformation> 
		 <Person BusinessEntityID="1"> 
			 <PersonInfo> 
				 <PersonType>EM</PersonType> 
				 <FirstName>Ken</FirstName> 
			 </PersonInfo> 
				<MiddleName>J</MiddleName> 
			 <PersonInfo> 
				tName>Sánchez</LastName> 
			 </PersonInfo> 
		</Person> 
		 <Person BusinessEntityID="2"> 
			 <PersonInfo> 
				 <PersonType>EM</PersonType> 
				 <FirstName>Terri</FirstName> 
			 </PersonInfo> 
				<MiddleName>Lee</MiddleName> 
			 <PersonInfo> 
				<LastName>Duffy</LastName> 
			 </PersonInfo> 
		 </Person> 
	. . . . და ა.შ ... 
	</PersonsInformation> 

( 5 ქულა) */
--
select p.BusinessEntityID
	  ,p.PersonType
	  ,p.FirstName
	  ,p.MiddleName
	  ,p.LastName
	  ,cast((select p1.BusinessEntityID as [Person/@BusinessEntityID]
			  ,p1.PersonType as [Person/PersonInfo/PersonType]
			  ,p1.FirstName as [Person/PersonInfo/FirstName]
			  ,p1.MiddleName as [Person/MiddleName]
			  ,p1.LastName as [Person/PersonInfo/LastName]
	   from [AdventureWorks2017].[Person].[Person] p1
	   where p1.BusinessEntityID = p.BusinessEntityID
	   for xml path(''), root('PersonsInformation')) as xml) as XML_Data
from [AdventureWorks2017].[Person].[Person] p
--
declare @v_xml_Person xml = (select p.BusinessEntityID as [Person/@BusinessEntityID]
								   ,p.PersonType as [Person/PersonInfo/PersonType]
								   ,p.FirstName as [Person/PersonInfo/FirstName]
								   ,p.MiddleName as [Person/MiddleName]
								   ,p.LastName as [Person/PersonInfo/LastName]
							from [AdventureWorks2017].[Person].[Person] p
							for xml path(''), root('PersonsInformation')) 
--
select @v_xml_Person as v_xml_Person
--
/*4. გამოიყენეთ ცხრილი : [AdventureWorks2017].[Sales].[Store], თითოეულ SalesPersonID ზე [Demographics] ველიდან წამოვიღოთ შემდეგი მნიშვნელობები :  
AnnualSales, 
AnnualRevenue, 
BankName,  
BusinessType,  
YearOpened , 
SquareFeet, 
Brands, 
Internet 
XML- ის გაპარსვისას თითოეულ ველს შეუსაბამეთ სწორი ტიპი , ანუ ყველა ტექსტურად არ გვინდა. თუ მთელია ინტად გაპარსეთ, ტექსტური- ტექსდად. */
--
with xmlnamespaces ('http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey' as t)
	select s.[Demographics]
		  ,x.y.value('(t:AnnualSales)','int') AnnualSales
		  ,x.y.value('(t:AnnualRevenue)','int') AnnualRevenue
		  ,x.y.value('(t:BankName)','varchar(20)') BankName
		  ,x.y.value('(t:BusinessType)','char(2)') BusinessType
		  ,x.y.value('(t:YearOpened)','int') YearOpened
		  ,x.y.value('(t:SquareFeet)','int') SquareFeet
		  ,x.y.value('(t:Brands)','varchar(10)') Brands
		  ,x.y.value('(t:Internet)','varchar(10)') Internet
	--select *	  
	from [AdventureWorks2017].[Sales].[Store] s
	cross apply s.Demographics.nodes('/t:StoreSurvey') as x(y)
	--

