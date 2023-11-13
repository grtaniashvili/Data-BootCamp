
create or alter proc Change_Date_pr_1(
									@STARTDATE date
									,@ENDDATE date = '06.30.14'
									)
		as
	begin
		select a.ProductID
		,sum(a.SALESAMOUNT) SALESAMOUNT
		,sum(a.SALESAMOUNT)-lag(sum(a.SALESAMOUNT),1,0) over(partition by a.PRODUCTID order by a.MODIFIEDDATE) NETSALESAMOUNT
		,a.MODIFIEDDATE
from (select sod.PRODUCTID
				,SUM(sod.ORDERQTY)*sod.UNITPRICE SALESAMOUNT
				,dbo.Last_Day_Month(sod.MODIFIEDDATE) MODIFIEDDATE
		from [ADVENTUREWORKS2017].[SALES].[SALESORDERDETAIL] sod
		where sod.ModifiedDate between @STARTDATE  and @ENDDATE
		group by PRODUCTID
				,UNITPRICE
				,dbo.Last_Day_Month(sod.MODIFIEDDATE)
		) a
group by a.ProductID
				,a.MODIFIEDDATE
		order by 1

	end

