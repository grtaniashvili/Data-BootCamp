/*1. შექმენით DateFillUsingCTE პროცედურა,რომელსაც გადავცემთ 2 პარამეტრს @StartDate  და @EndDate; 
პროცედურამ უნდა შეავსოს ისევ Date ცხრილი, რომელიც შევქმენით წინა დავალებაში, მაგრამ ამჯერად ცხრილის შევსება უნდა ხდებოდეს CTE და რეკურსიით 
, არ დაგავიწყდეთ IsEndOfMonth ველის განსაზღვრა თითოეული ჩანაწერისთვის. (7 ქულა)  */
--
use AdventureWorks2017
--
DROP TABLE IF EXISTS [Date];
	CREATE TABLE [Date}
	(
			ID int identity(1,1) primary key,
			[Date] date not null,
			IsEndOfMonth as (case when [Date] = eomonth([Date]) then 1 else 0 end)
	)
--
create or alter proc DateFillUsingCTE(
									  @StartDate date
									 ,@EndDate date =getdate
									 )
	  as
	begin 
		--
		if exists(
					select 1
					from date d
					where d.date between @StartDate and @EndDate
				)
			delete from date
			where date between @StartDate and @EndDate
		 --
		;with Date_cte
		as
		(
			select @StartDate [date]
			union all
			select dateadd(day,1,d.date) [date]
			from Date_cte d
			where date < @EndDate
		)
		--
		insert into date(date)
		select * from Date_cte
		--
end
--
exec DateFillUsingCTE '2011-06-25','2011-08-31'
--
select *
from date
--
truncate table date
--
/*2. გამოიყენეთ ვიუ [AdventureWorksDW2017].[dbo].[vTargetMail] , რომელიც დაგვითვლის [City]- ებზე 
რეგიონების მიხედვით დაპაივოტებულ yearlyIncome-ს; ანუ როუებში უნდა გვქონდეს city ხოლო column-ში თითოეული რეგიონი,
რომლის მნიშვნელობაშიც იქნება დაჯამებული yearlyIncome. შეინახეთ გადათვლილი ინფორმაცია დროებით ცხრილი, 
რომელიც ყოველი სკრიპტის გაშვებისას წაიშლება და ახლიდან შეიქმნება. ცხრილში გვექნება ველები: City და რეგიონები (7 ქულა)  */
--
select dg.City
	,tm.Region
	,tm.yearlyIncome
into #t1		
from [AdventureWorksDW2017].[dbo].[vTargetMail] tm
join [AdventureWorksDW2017].[dbo].[DimGeography] dg
on tm.GeographyKey = dg.GeographyKey

--
select *
from #t1
--
create table #t_piv(
					city varchar(50)
					,Europe int
					,[North America] int
					,Pacific int
					)

--
insert into #t_piv
SELECT * 
FROM #t1
PIVOT (sum(yearlyIncome)
       for region in ([Europe],[North America],[Pacific])) AS pvt
--
select *
from #t_piv
--
--3. გამოიყენეთ მე-2-ე დავალებაში შექმნილი დროებითი ცხრილი და unpivot – ის საშუალებით  შექმენით ველი RegionName და Amount ველები, (6 ქულა)
--
create table #t_unpiv(
					RegionName varchar(50)
					,Amount int
					)
--
insert into #t_unpiv
SELECT region, sum(Amount)
FROM #t_piv
UNPIVOT (Amount
       for region in ([Europe],[North America],[Pacific])) AS unpvt
group by region
--
select *
from #t_unpiv