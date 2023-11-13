/*
USE AdventureWorks2017
 
  1. გამოიყენეთ ცხრილი: [HumanResources].[Employee]  და დაწერეთ სელექთი: 
გვჭირდება, ისეთი თანამშრომლების სია,რომლებიც აიყვანეს სამსახურში 2007 წლის 1 იანვრიდან 2015 წლის 31 დეკემბრის ჩათვლით,
  ამავდროულად, ამ სიმრავლეში არ გვჭირდება ისეთი თანამშრომლები, რომელიც აიყვანეს 2008 წლის იანვარში;
  მათი პოზიცია უნდა მენეჯერული, ანუ პოზიციის დასახელება უნდა შეიცავდეს "Manager" სიმბოლოებს;


  გამოსატანი ველები : BusinessEntityID, NationalIDNumber,LoginID,JobTitle,Gender,HireDate,ModifiedDate

  */
  --
  USE AdventureWorks2017
  --
  select h.BusinessEntityID
         ,h.NationalIDNumber
		 ,h.LoginID
		 ,h.JobTitle
		 ,h.Gender
		 ,h.HireDate
		 ,h.ModifiedDate
  from [HumanResources].[Employee] h
  where h.HireDate between '2007-01-01' and '2015-12-31'
        and h.HireDate not between '2008-01-01' and '2008-01-31'
		and h.JobTitle like '%Manager%'

/*  2. ამ სიმრავლეს დაამატეთ ერთი ველი : EmployeeName, რომელსაც ექნება NULL მნიშვნელობა. */
 --
 USE AdventureWorks2017
 --
  select h.BusinessEntityID
         ,h.NationalIDNumber
		 ,h.LoginID
		 ,h.JobTitle
		 ,h.Gender
		 ,h.HireDate
		 ,h.ModifiedDate
		 ,null EmployeeName
  from [HumanResources].[Employee] h
  where h.HireDate between '2007-01-01' and '2015-12-31'
        and h.HireDate not between '2008-01-01' and '2008-01-31'
		and h.JobTitle like '%Manager%'
--

  /* 3. შექმენით ცხრილი Temp.Managers;
  ველები :  BusinessEntityID მთელი ტიპი, არანულოვანი,
  PersonalID პირადი ნომერი,
  LoginID ტექსტური, შეიცავს სხვადასხვა სიმბოლოებს,
  JobTitle ტექსტური ,
  Gender შეიცავს მხოლოდ 1 სიმბოლოს : M / F ,
  HireDate თარიღი,
  ModifiedDate თარიღი და დრო ,
  EmployeeName ტექსტური, არ შეიცავს Unicode-ს, default მნიშვნელობა 'Unknown' */

  --
  use AdventureWorks2017
  --
  create schema Temp authorization dbo
  --
  create table Temp.Managers(BusinessEntityID real not null
                             ,PersonalID varchar(20)
							 ,LoginID text
							 ,JobTitle text
							 ,Gender char(1)
							 ,HireDate date
							 ,ModifiedDate datetime2
							 ,EmployeeName varchar default 'Unknown'
							 )
							
--

 /* 3. ჩაწერეთ 1 ამოცანის სელექთის შედეგი აღნიშნულ ცხრილში. */
 --
 use AdventureWorks2017
 --
 insert into Temp.Managers
	select h.BusinessEntityID
			,h.NationalIDNumber
			,h.LoginID
			,h.JobTitle
			,h.Gender
			,h.HireDate
			,h.ModifiedDate
			,null EmployeeName
	from [HumanResources].[Employee] h
	where h.HireDate between '2007-01-01' and '2015-12-31'
		and h.HireDate not between '2008-01-01' and '2008-01-31'
		and h.JobTitle like '%Manager%'
	--
  /* 4. წაშალე ცხრილიდან თანამშრომელი, რომლის NationalIDNumber არის 30845 და 24756624 და 141165819 */
  --
  use AdventureWorks2017
  --
  delete from Temp.Managers
  where PersonalID in (30845,24756624,141165819)
  --
  /* 5. დააკონვერტირეთ EmployeeName ველის ტიპი, ისეთ ტიპად , სადაც ჩაიწერება სახელი ქართული სიმბოლოებით. */
   --
   use AdventureWorks2017
   --
   select convert(nvarchar,[EmployeeName]) as EmployeeNameGeo
   from Temp.Managers
   --
 /* 6. შეუცვალე თანამშრომელს სახელი, რომლის NationalIDNumber = 24756624 , დაარქვი რამე ქართულად */
  --
  use AdventureWorks2017
  --
  update Temp.Managers
  set EmployeeName = N'გრიგოლ'
  where PersonalID = 24756624
  --
  /* 7. დაასელექთეთ Temp.Managers ცხრილიდან ისეთი თანამშრომლები, რომელთა ModifiedDate არ უდრის 2014 წლის 30 ივნისს 


  გაითვალისწინეთ, სელექთში ყურადღება მიექცევა ალიასის გამოყენებას, შეზღუდვებს, ველის ტიპებს და ა.შ. 
  ანუ რაც გავიარეთ ლექციებზე, ეცადეთ ის ცოდნა გამოიყენოთ.
  კითხვებზე შეგიძლიათ აქვე დაპოსტოთ.
  გთხოვთ, დავალებები გამომიგზავნოთ თქვენი სახელი და გვარით, ორშაბათს 2 საათამდე. */
  --
  use AdventureWorks2017
  --
  select m.*
  from Temp.Managers m
  where m.ModifiedDate != '2014-05-30'

