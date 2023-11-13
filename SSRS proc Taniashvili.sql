--გამოიყენეთ ცხრილი [AdventureWorksDW2017].[dbo].[FactFinance] და დაწერეთ პროცედურა,  რომელსაც პარამეტრად გადავცემთ 2 თარიღს : StartDate და EndDate , ასევე DepartmentGroupKey რომელიც შეიძლება გადავცეთ რამოდენიმე (მაგ: 1,2,3) 
--პროცედურის დასაბრუნებელი ველები :  
-- [Date], 
-- [AccountKey], 
-- [Amount], 
-- [OrganizationKey], 
-- [OrganizationName], 
-- [DepartmentGroupKey], 
-- [DepartmentGroupName] 
--ყველა ველი შეიძლება არ იყოს აღნიშნულ ცხრილში, ამიტომ გამოიყენეთ საჭირო dimention ცხრილები (5 ქულა) 
--
use AdventureWorksDW2017
--
create or alter function FnSplitParameterVals(
											@List varchar(20)
							     			,@SplitOn nvarchar(5)
											)  
returns @RtnValue table 
				(

					Id int identity(1,1),
					Value char(1)
				) 
		as  
begin
	--
	while (Charindex(@SplitOn,@List)>0)
		begin 
			--
			insert Into @RtnValue (value)
			select
			value = ltrim(rtrim(substring(@List,1,charindex(@SplitOn,@List)-1))) 
			set @List = Substring(@List,charindex(@SplitOn,@List)+len(@SplitOn),len(@List))
			--
		end 
	--
	insert into @RtnValue (Value)
	select value = ltrim(rtrim(@List))
	return
	--
end
--
--select ff.[Date] 
--	  ,ff.[AccountKey]
--	  ,ff.[Amount]
--	  ,ff.[OrganizationKey]
--	  ,do.[OrganizationName]
--	  ,ff.[DepartmentGroupKey]
--	  ,dd.[DepartmentGroupName] 
--from [AdventureWorksDW2017].[dbo].[FactFinance] ff
--	join [AdventureWorksDW2017].[dbo].[DimOrganization] do
--		on ff.OrganizationKey = do.OrganizationKey
--	join [AdventureWorksDW2017].[dbo].[DimDepartmentGroup] dd
--		on ff.DepartmentGroupKey = dd.DepartmentGroupKey

--
--select *
--from [AdventureWorksDW2017].[dbo].[FactFinance]
----
--drop proc SSRS_test
--
create or alter proc SSRS_test(
								@StartDate date,
								@EndDate date,
								@DepartmentGroupKey varchar(20)
								)
	as
begin
	--
	select ff.[Date] 
	  ,ff.[AccountKey]
	  ,ff.[Amount]
	  ,ff.[OrganizationKey]
	  ,do.[OrganizationName]
	  ,ff.[DepartmentGroupKey]
	  ,dd.[DepartmentGroupName] 
	from [AdventureWorksDW2017].[dbo].[FactFinance] ff
		join [AdventureWorksDW2017].[dbo].[DimOrganization] do
			on ff.OrganizationKey = do.OrganizationKey
		join [AdventureWorksDW2017].[dbo].[DimDepartmentGroup] dd
			on ff.DepartmentGroupKey = dd.DepartmentGroupKey
	where ff.Date between @StartDate and @EndDate
			and dd.DepartmentGroupKey in (select value from [dbo].[FnSplitParameterVals](@DepartmentGroupKey,','))
	order by ff.DepartmentGroupKey, ff.OrganizationKey
	--
end
--

exec  SSRS_test '2010-12-29','2011-12-29', '1,2,3,4'