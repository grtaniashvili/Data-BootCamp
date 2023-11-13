/*1. გვაქვს შემდეგი ინფორმაცია :  
სტუდენტები : 
a. სტუდენტის უნიკალური იდენტიფიკატორი, ავტომატურად გენერირებადი b. სტუდენტის სახელი, 
c. სტუდენტის გვარი, 
d. პირადი ნომერი 
e. იმეილი 
საგნები : 
a. საგნის უნიკალური იდენტიფიკატორი, ავტომატურად გენერირებადი b. საგნის დასახელება, 
c. ქულა 
გაითვალისწინეთ, რომ 1 საგანს შეიძლება სწავლობდეს რამოდენიმე სტუდენტი და ასევე 1  სტუდენტი შეიძლება სწავლობდეს რამოდენიმე საგანს. 
გადაანაწილეთ ზემოთ არნიშნული ინფორმაცია ცხრილებში ნორმალიზაციის დაცვით ,  გაუწერეთ კავშირები და შეავსეთ ცხრილები ინფორმაციით (რამოდენიმე ჩანაწერი საკმარისია) . 
5 ქულა. */
--
use AdventureWorks2017
--
create table Students(StudentID int identity(1,1) Primary Key
					,StudentName varchar(15)
					,StudentSurname varchar(25)
					,PersonalID varchar(11) not null unique
					,StudentEmail varchar(50) 
					)
--
/* ან შეიძლება ერთად დავადოთ პრაიმარი ქი StudentID ს და PersonalID ის მაგრამ წინა გზა უფრო ოპტიმალური მგონია.
alter table Students
add constraint PK_Students primary key (StudentID,PersonalID)
*/
create table Subjects(SubjectID int identity(1,1) primary key
					,SubjectName varchar(20) not null unique
					,Mark tinyint
					)
--
create table StudentsData(StudentID int  
						,SubjectID int
						)
/*აქ იდეაში StudentID და SubjectID მეორადი გასაღებებია

alter table StudentsData
add constraint FK_StudentsData_1 foreign key (StudentID) references Students(StudentID)
--
alter table StudentsData
add constraint FK_StudentsData_2 foreign key (SubjectID) references Subjects(SubjectID) */
--
insert into Students(StudentName 
					,StudentSurname
					,PersonalID 
					,StudentEmail 
					)
values('Grigol'
	  ,'Taniashvii'
	  ,'1212344'
	  ,'asdas@mail.net'
	  ),
	  ('Givi'
	  ,'Papava'
	  ,'343434'
	  ,'asdas@mail.net'
	  ),
	  ('Natia'
	  ,'Devdariani'
	  ,'121234234'
	  ,'fsfd@mail.ge'
	  ),
	  ('Teo'
	  ,'Kala'
	  ,'2333466'
	  ,'sdde@gmail.com'
	  ),
	  ('Grigol'
	  ,'Papava'
	  ,'3467889'
	  ,'asd44as@mail.net'
	  )
--
insert into Subjects(SubjectName, Mark)
values('Georgian', 100)
	,('English', 90)
	,('Math', 59)
	,('History', 72)
	,('Physics', 75)
--
insert into StudentsData(StudentID
						,SubjectID
						)
values(1,1),(1,5),(2,6),(1,2),(5,3),(1,3),(2,3)
--


/*2. გამოიყენეთ ბაზა [AdventureWorks2017] და აღნიშნული ცხრილები :  
 [AdventureWorks2017].[HumanResources].[Employee] 
[AdventureWorks2017].[HumanResources].[EmployeeDepartmentHistory] 
[AdventureWorks2017].[HumanResources].[Department] 
ამ ცხრილებიდან დაწერეთ სელექთი, რომელიც დააბრუნებს ინფორმაციას თანამშრომლების შესახებ, რომლებიც აიყვანეს სამსახურში 2019 წლის 14  იანვრიდან ,,Sales and Marketing” ჯგუფში.  
სელექთში გამოსატანი ველები :  
[BusinessEntityID], [NationalIDNumber], [JobTitle] ,[BirthDate] ,[Gender],[HireDate] , Name (იგივე DepartmentName)  
5 ქულა
*/
--
use AdventureWorks2017
--
select e.BusinessEntityID
	,e.NationalIDNumber
	,e.JobTitle
	,e.BirthDate
	,e.Gender
	,e.HireDate
	,d.[Name] DepartmentName
From [HumanResources].[Employee] e
join [HumanResources].[EmployeeDepartmentHistory] h
on e.BusinessEntityID = h.BusinessEntityID
join [HumanResources].[Department] d
on h.DepartmentID = d.DepartmentID 
where e.HireDate >= '2009-01-14'
     and d.DepartmentID IN (3,4)

