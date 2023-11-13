/*1. გამოიყენეთ ბაზა, AdventureworksDW2017, ცხრილი dbo.FactFinance და დაწერეთ ფუნქცია, რომელსაც გადავცემთ თარიღს და ქვეყნის კოდს 
(მთელ ტიპს, კოდების მოძიება და გატესტვა შეგვიძლია აღნიშნული ცხრილიდან dbo.DimOrganization ) .  გუნქციამ უნდა დაგვიბრუნოს ჯამური თანხა,
DcenarioKey,ScenarioName და AccountKey- ების ჭრილში. გაითვალისწინეთ, რომ ჯამური თანხა არ უნდა აღემატებოდეს 9000-ს. (4 ქულა)  */
--
use adventureworksDW2017
--
create or alter function fun1
		 (
		 @Date int
		,@Cid int
		 )
returns Table
     as
return
select ff.ScenarioKey
		,ds.ScenarioName
		,ff.AccountKey
		,sum(ff.Amount) SumAmount
from FactFinance ff
join DimScenario ds
on ff.ScenarioKey = ds.ScenarioKey
where ff.OrganizationKey = @Cid
		and ff.DateKey = @Date
group by ff.ScenarioKey
		,ds.ScenarioName
		,ff.AccountKey
having sum(ff.Amount) >=9000


--2. მოცემულია მზა ცხრილი: 
--
drop table if exists #WeekExpense
--
CREATE TABLE #WeekExpense 
( WeekNumber VARCHAR(20),WeekDayName VARCHAR(50), Expense MONEY) 
INSERT INTO #WeekExpense 
VALUES 
( 'Week05','Monday', 20 ), 
( 'Week05','Tuesday', 60 ), 
( 'Week05','Wednesday', 20 ), 
( 'Week05','Thurusday', 42 ), 
( 'Week05','Friday', 10 ), 
( 'Week05','Saturday', 15 ) , 
( 'Week05','Sunday', 8 ), 
( 'Week04','Monday', 29 ), 
( 'Week04','Tuesday', 17 ), 
( 'Week04','Wednesday', 42 ), 
( 'Week04','Thurusday', 11 ), 
( 'Week04','Friday', 43 ), 
( 'Week04','Saturday', 10 ) , 
( 'Week04','Sunday', 15 ), 
( 'Week03','Monday', 10 ), 
( 'Week03','Tuesday', 32 ), 
( 'Week03','Wednesday', 35 ), 
( 'Week03','Thurusday', 19 ), 
( 'Week03','Friday', 30 ), 
( 'Week03','Saturday', 10 ) , 
( 'Week03','Sunday', 15 ) 
--
--WeekNumber- ველის ჭრილში დათვალეთ ჩანაწერების რაოდენობა, საშუალო, ჯამი, მინიმალური და მაქსიმალური თანხები , (3 ქულა) 
--
select we.WeekNumber
		,count(*) [Quantity]
		,avg(we.Expense) [Average Expense]
		,sum(we.Expense) [Sum Expense]
		,min(we.Expense) [Min Expense]
		,max(we.Expense) [Max Expense]
from #WeekExpense we
group by we.WeekNumber
--

/*3. გამოიყენეთ dbo.FactFinance ცხრილი. დაასელექთეთ მონაცემები აღნიშნული ცხრილიდან 20101229 – მდგომარეობით,
წამოსაღები ველი არის AccountKey და Amount- ველის ჯამი, შეინახეთ დროებით ცხრილში; 
ვასელექთებთ იგივე ცხრილს 20110129 მდგომარეობით, იგივე ველებით დ ავინახავთ მეორე დროებით ცხრილში; 
ეს ცხრილები გავაერთიანოთ join-ის გამოყენებით ისე, რომ არ დავკარგოთ ჩანაწერი არცერთი ცხრილიდან (3)*/
--
drop table if exists #Table_1
drop table if exists #Table_2
--
select ff.AccountKey
	   ,sum(ff.Amount) Summary
into #Table_1
from FactFinance ff
where ff.Date = '20101229'
group by ff.AccountKey
--
select ff.AccountKey
	   ,sum(ff.Amount) Summary
into #Table_2
from FactFinance ff
where ff.Date = '20110129'
group by ff.AccountKey        
--
select *
from #Table_1 t1
full outer join #Table_2 t2
on t1.AccountKey = t2.AccountKey
--

select*
from fun1(20101229,3)