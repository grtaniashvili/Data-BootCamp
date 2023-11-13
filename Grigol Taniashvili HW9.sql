--1. დაწერეთ ფუნქცია, რომელსაც გადავცემთ თარიღს და დაგვიბრუნებს იგივე თარიღის თვის ბოლოს.
--მაგ. : თუ გადავცემთ 20210301-ს დამიბრუნოს 20210331. (3 ქულა) 
--
use AdventureWorks2017
--
create or alter function Last_Day_Month(
										@Date_in date
										)
	returns date 
		as
	begin
		return eomonth(@Date_in)
	end
--
select dbo.Last_Day_Month('20210301')
--

/*2. დაწერეთ პროცედურა , რომელსაც გადავცემთ 2 თარიღს: STARTDATE და ENDDATE . ENDDATE 
iყოს დეფოლტ პარამეტრი, ანუ თუ არ მივუთითებთ, 30.06.2014 წელი მიეთითოს.(1 ქულა) 
პროცედურა დათვალოს :  
გამოიყენეთ ცხრილი [ADVENTUREWORKS2017].[SALES].[SALESORDERDETAIL]. ველები PRODUCTID, UNITPRICE , ORDERQTY, MODIFIEDDATE. 
MODIFIEDDATE - ჩავანაცვლოთ თვის ბოლოებით, ჩვენი დაწერილი ფუნქციის გამოყენებით. ( 1 ქულა) 
პროცედურა უნდა გვიბრუნებდეს თვის ბოლოებით თითოეული გაყიდული პროდუქტის თანხახის სხვაობას, წინა თვესტან შედარებით. 
დასაბრუნებელი ველები :  
PRODUCTID,  
SALESAMOUNT(ჩვეულებრივი პროდუქტის და თვის ჭრილში ჯამური თანხა, სადაც ვითვალისწინებთ ORDERQTY-საც 1 ქულა), 
NETSALESAMOUNT- თვითონ სხვაობა თანხებს შორის (მიმდინარე თვეს - წინა თვის თანხა) MODIFIEDDATE (თვის ბოლო თარიღები) 
ეს ამოცანა დაწერეთ 2 ხერხით:  
ანალიტიკური ფუნქციის გამოყენებით და RANKINFUNCTION-ების გამოყენებით თითოეულ ხერხზე დაიწერება 5-5 ქულა. */
--
use AdventureWorks2017
--
drop proc if exists Change_Date_pr
--
create or alter proc Change_Date_pr(
									@STARTDATE date
									,@ENDDATE date = '06.30.14'
									)
		as
	begin
		--
		drop table if exists #t1
		--
		select sod.PRODUCTID
				,SUM(sod.ORDERQTY)*sod.UNITPRICE SALESAMOUNT
				,dbo.Last_Day_Month(sod.MODIFIEDDATE) MODIFIEDDATE
		into #t1
		from [ADVENTUREWORKS2017].[SALES].[SALESORDERDETAIL] sod
		where sod.ModifiedDate between @STARTDATE  and @ENDDATE
		group by PRODUCTID
				,UNITPRICE
				,dbo.Last_Day_Month(sod.MODIFIEDDATE)
		order by 1
		--
		select a.ProductID
		,sum(a.SALESAMOUNT) SALESAMOUNT
		,sum(a.SALESAMOUNT)-lag(sum(a.SALESAMOUNT),1,0) over(partition by a.PRODUCTID order by a.MODIFIEDDATE) NETSALESAMOUNT
		,a.MODIFIEDDATE
		from #t1 a
		group by a.ProductID
				,a.MODIFIEDDATE
		order by 1
	end
--
--ranking!!!
--
drop proc if exists Change_Date_rank_pr
--
create or alter proc Change_Date_rank_pr(
									@STARTDATE date
									,@ENDDATE date = '06.30.14'
									)
		as
	begin
		--
		drop table if exists #t1
		drop table if exists #t2
		--
		select sod.PRODUCTID
			,SUM(sod.ORDERQTY)*sod.UNITPRICE SALESAMOUNT
			,dbo.Last_Day_Month(sod.MODIFIEDDATE) MODIFIEDDATE
		into #t1
		from [ADVENTUREWORKS2017].[SALES].[SALESORDERDETAIL] sod
		where sod.ModifiedDate between @STARTDATE  and @ENDDATE
		group by PRODUCTID
				,UNITPRICE
				,dbo.Last_Day_Month(sod.MODIFIEDDATE)
		order by 1
		--
		select a.ProductID
				,sum(a.SALESAMOUNT) SALESAMOUNT
				,dense_rank() over(partition by a.PRODUCTID order by a.MODIFIEDDATE) [ranking]
				,a.MODIFIEDDATE
		into #t2
		from #t1 a
		group by a.ProductID
				,a.MODIFIEDDATE
		order by 1
		--
		select b.ProductID
				,b.SALESAMOUNT
				,isnull(b.SALESAMOUNT-(select c.SALESAMOUNT from #t2 c where c.[ranking] = b.[ranking] - 1 and b.ProductID = c.ProductID),b.SALESAMOUNT) NETSALESAMOUNT
				,b.MODIFIEDDATE
		from #t2 b
		order by 1
		--
		
	end
--
exec Change_Date_pr '06.12.11'
exec Change_Date_rank_pr '06.12.11'
--

/*3. დაწერეთ პროცედურა, რომელსაც გადავცემთ 2 პარამეტრს : YEAR და CALLCOUNT; CALLCOUNT იყოს OUTPUT პარამეტრი; 
პროცედურამ დაგვიბრუნოს [ADVENTUREWORKSDW2017].[DBO].[FACTCALLCENTER] ცხრილიდან წელი და CALL ველის ჯამური რაოდენობა 
ვაჩვენოთ როგორ ვიყენებთ OUTPUT მნიშვნელობიან პარამეტრს: გამოიტანეთ OUTPUT პარამეტრის მნიშვნელობა RESULTSET-შიც და MESSAGE-ში (4 ქულა) */
--
drop proc if exists test_pr
--
create or alter proc test_pr(
							@YEAR int
							,@CALLCOUNT int out
							)
	as
	begin
		--
		select year(fc.[Date]) [YEAR]
				,count(*) [Call_Count]
		from [ADVENTUREWORKSDW2017].[DBO].[FACTCALLCENTER] fc
		where year(fc.[Date]) = @YEAR
		group by year(fc.[date])
		--
		set @CALLCOUNT = (
						select count(*) [Call_Count]
						from [ADVENTUREWORKSDW2017].[DBO].[FACTCALLCENTER] fc
						where year(fc.[Date]) = @YEAR
						group by year(fc.[date])
						)
		print  @CALLCOUNT
		--
	end
--	

declare @count int
exec test_pr 2014,@count out
select @count [Call_Count]