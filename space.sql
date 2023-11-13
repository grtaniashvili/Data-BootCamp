--გვაქვს კლიენტების ცხრილი   CLIENTS, რომელიც  შედგება შემდეგი ველებისგან:
--1.	FIRST_NAME   varchar(50) (null) (კლიენტის სახელი , ტექსტური ტიპის - დასაშვები რაოდენობა 50) 
--2.	LAST_NAME varchar(50)  (null) (კლიენტის გვარი , ტექსტური ტიპის - დასაშვები რაოდენობა 50) 
--3.	PERSONAL_ID varchar(11) (null) (კლიენტის პირადი ნომერი, ტექსტური ტიპის - დასაშვები რაოდენობა 11)
--
use Space
--
create table Clients(
					First_Name varchar(50) null
					,Last_Name varchar(50) null
					,Personal_ID varchar(11) null
					)
--
insert into Clients
values(
		'Grigol'
		,'Taniashvili'
		,'sdhsjkdfh'
		)
		,
		(
		'Teo'
		,'Ianshvili'
		,'sdf3434'
		)
		,
		(
		'Mari'
		,'Gagua'
		,'23134234'
		)
		,
		(
		'Anna'
		,'Papava'
		,'sdhs333h'
		)
		,
		(
		'Teona'
		,'Nanuashvili'
		,'234567'
		)
--
--
--1.	კლიენტების ცხრილიდან ამოიღეთ ყველა ის ჩანაწერი, რომლის პირადი ნომერი არ შედგება ციფრებისგან და სიგრძე ნაკლებია 11 სიმბოლოზე.
--
select c.*
from Clients c
where c.Personal_ID not like  '%[0-9]%' -- patindex('%[0-9]%',c.Personal_ID) = 0
	 and len(c.Personal_ID) < 11
--
--2.	კლიენტების ცხრილიდან ამოიღეთ ყველა ის ჩანაწერი, რომლის გვარი მთავრდება „შვილი“- ზე და გვარში ასო „ი“ გვხდება ზუსტად 3 ჯერ . მაგალითად : „იაშვილი“ 
--
select c.*
from Clients c
where c.Last_Name like '%shvili'
	  and len(c.Last_Name) - len(replace(c.Last_Name,'i','')) = 3

--
--3.	დავუშვათ მოცემულა ყველა მოქალაქის პირადი ნომრების ცხრილი(ნუმერაცია არ არის თანმიმდევრული). ახალ დაბადებული მოქალაქისთვის დააგენერიეთ ახალი პირადი ნომერი და დაამატეთ ცხრილში. (საჭიროა აღმოვაჩინოთ ერთი ცალი პირადი ნომერი რომელიც არ არის ჩვენს ცხრილში და ისე დავამატოთ)
--
insert into Clients(Personal_ID)
values(1),(2),(4),(5),(7),(8)
--

create or alter proc AddNewCliant(
									 @First_Name varchar(50) 
									,@Last_Name varchar(50) 
				
									)
as
begin
	--
	drop table if exists #t
	--
	select convert(int,c.Personal_ID) ID
		  --,convert(int,lag(convert(int,c.Personal_ID),1,0) over(order by convert(int,c.Personal_ID))) LAG_ID
		  ,convert(int,c.Personal_ID) - convert(int,lag(convert(int,c.Personal_ID),1,0) over(order by convert(int,c.Personal_ID))) DIFF_ID
	into #t
	from clients c
	where upper(c.Personal_ID) not like '%[A-Z]%'
	order by convert(int,c.Personal_ID)
	--

	insert into Clients
	values(@First_Name
		   ,@Last_Name
		   ,(select top 1  c.ID - c.DIFF_ID + 1
			from #t c
			where c.DIFF_ID > 1)
			)
	--

end
--
exec AddNewCliant 'TTT', 'asdasd'
--
--4.	დაწერეთ ფუნქცია რომელიც დააბრუნებს პიროვნების ასაკს. Param @Date datetime - კლიენტის დაბადების თარიღი Return @age int - ასაკი 
--
create or alter function GetAge(
								@bday datetime
								)
returns int
	as
begin
	return DATEDIFF(Day,@bday,getdate())/365.242199
end
--
select dbo.GetAge('12-10-1994')
--
--5.	შექმენით ობიექტები სადაც იქნება ინფორმაცია თანამშრომლებზე და მათ დაქვემდებარებულებზე. 
--•	დაწერეთ ფუნქცია რომელიც დათვლის დაქვემდებარებაში არსებულ ყველა თანამშრომელს იერარქია >> დირექტორი> დირექტორის მოადგილეები> განყოფილების უფროსები> ჯგუფის უფროსები> სპეციალისტები. 
--Param @EmployeeId int 
--Return @NumOfSubs int
--ამ დავალებაში საჭიროა აიდებით გაწერა სხვადასხვა ცხრილში ვინ ვისი უფროსია, ანუ პიროვნებას დავამატებთ ველს manager id  მაგალითად და გავუწერთ
--მისი უფროსის აიდს, შემდეგ ქაუნთით გადათვლი ვის რამდენი ბოსი ყავს

--6.	დავუშვათ მოცემულია სამუშაო საათების და დასვენების დღეების ცხრილები. დაწერეთ ფუნქცია, რომელსაც გადაეცემა პარამეტრები: 
--•	თარიღი(datetime)
--•	წუთები(int)
--•	გაითვალისწინოს თუ არა დასვენების დღე(Boolean)
--•	გაითვალისწინოს თუ არა სამუშაო საათები(Boolean)
--ფუნქციამ უნდა დააბრუნოს დრო(datetime)
--	მიზანია გადაცემულ თარიღს დავუმატოთ წუთები სამუშაო საათების და დასვენების დღეების გათვალისწინებით. 
--მაგალითად ფუნქციას თუ გადაეცემა: ('2021-10-01 17:00:00', 240, 1 , 1 ) (პარასკევი საღამო), 
--და სამუშაო საათები არის 10:00-დან 19:00-მდე და ასევე მომდევნო ორშაბათი არის დასვენების დღე და 
--ამასთანავე შაბათ-კვირა არასამუშაო დღეებია. პასუხად უნდა მივიღოთ ('2021-10-05 12:00:00')
--
select 240 - (19*60 - datename(HOUR,'2021-10-01 17:00:00')*60 - datename(MINUTE,'2021-10-01 17:00:00')) + 15*60
select dateadd(MINUTE,103330,GETDATE())
--
create or alter function ff(
                                                                             @Date datetime
                                                                             ,@Min int
                                                                             ,@HD bit
                                                                             ,@WH bit
                                                                             )
returns datetime
as
begin
    declare @t int , @t1 int = 0
 
    if @WH = 1
        begin
            set @t1 = 60*15 
        end
    if datename(weekday,@Date) = 'Friday'
            begin
                if @min > (19*60 - datename(HOUR,@Date)*60 - datename(MINUTE,@Date))
                    begin
                                if @HD = 1
                                            set @t = @min + 3*24*60 + @t1
                                else 
                                            set @t =  @Min + 2*24*60 +@t1
                    end
				else 
                    begin 
                                set @t =  @Min
                    end
            end
    else 
                begin
                    if @min > (19*60 - datename(HOUR,@Date)*60 - datename(MINUTE,@Date))
                            begin
                                if @HD = 1
								 set @t = @Min + 24*60 +@t1
                                else 
                                 set @t =  @Min +@t1
                            end
                    else 
                            begin
                            set @t =  @Min
                            end
                end
 
                return dateadd(MINUTE,@t,@Date)
end

--
select dbo.ff('2021-10-01 17:00:00', 240, 1 , 1 )
