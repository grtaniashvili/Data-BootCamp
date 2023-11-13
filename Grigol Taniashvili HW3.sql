/*1. შექმენით ცხრილი Clients , შემდეგი ველებით : 


CleintID მთელი ტიპის, ავტომატურად გენერირებადი,საწყისი მნიშვნელობა 1-დან იწყება და ყოველი ახალი კლიენტის ჩამატებისას, იზრდება 1-ით;
PersonalID პირადი ნომრისთვის განკუთვნილი, არანულოვანი;
FullName სახელი და გვარი, შეიცავს unicode-საც
MobilePhone - მoბილურის ნომრები, შეიძლება შევიყვანოთ + ნიშანიც; 
BirthDate- დაბადების თარიღი
GenderID  ( მნიშვნელობა : 1/ 0)
MobileNetworkTypeID - მთელი ტიპი (1,2,3,4,5,6 ) 

 გაითვალისწინეთ, ცხრილში კლიენტის აიდი და პირადი ნომერი ერთად  უნიკალურია; (2 ქულა) */
 --
 use AdventureWorks2017
 --
CREATE TABLE dbo.Clients
	(
	ClientID int NOT NULL IDENTITY (1, 1),
	PersonalID varchar(11) NOT NULL,
	FullName nvarchar(50),
	MobilePhone varchar(13),
	BirthDate date,
	GenderID bit,
	MobileNetworkTypeID int
	)
--
ALTER TABLE dbo.Clients 
ADD CONSTRAINT PK_Clients_1 PRIMARY KEY CLUSTERED 
	(
	ClientID,
	PersonalID
	) 





/*2. შექმენით ცხრილი Gender; საჭირო ველები:
CenderID უნიკალური, იღებს მხოლოდ და მხოლოდ 2 მნიშვნელობას : 1 და 0 ; დაადეთ შეზღუდვა, აღნიშნული ლოგიკით
Gender - ტექსტური

ცხრილში, როცა CenderID=1  Gender-ში უნდა ეწეროს Female , ხოლო 0 - ზე Male; 
(2 ქულა) */
 --
 use AdventureWorks2017
 --
 create table dbo.Gender (
         GenderID bit not null,
		 Gender varchar(6)
		 )
--
alter table dbo.Gender
add constraint PK_Gender primary key ( GenderID )
--
insert into Gender
values (
		1
		,'Female'
		)
		,
		(
		0
		,'Male'
		)
--


/*3. შექმენით ცხრილი MobileNetworkType : 
MobileNetworkTypeID - მთელი ტიპის,უნიკალური, ავტომატურად გენერირებადი, საწყისი მნიშვნელობა 1 დან იწყება და ყოველი ახალი ჩანაწერის დამატებისას 1 ით იზრდება;

MobileNetworkTypeName - ტექსტური, შეიცავს unicode-საც; (

მაგ.:  მაგთი, ბილაინი, ჯეოსელი; )


 (2 ქულა)*/
 --
 use AdventureWorks2017
 --
 create table MobileNetworkType(
				
				MobileNetworkTypeID int not null IDENTITY (1, 1)
				,MobileNetworkTypeName nvarchar(10)
				)
--
alter table MobileNetworkType
add constraint PK_MobileNetworkType primary key(MobileNetworkTypeID)
--

/*4. შეავსეთ ზემოთ აღნიშნული ცხრილები მონაცემებით; 2-3 ჩანაწერი საკმარისია;
გააკეთეთ ცხრილებს შორის კავშირები 

 PrimaryKey და ForeignKey გამოყენებით;

(4 ქულა)

p.s. გამოიყენეთ ლექცებზე ახსნილი თემები; 
ასევე, გთხოვთ 1 query-ში მოათავსოთ დავალება.
კითხვები აქვე დაპოსტეთ და ყველა წაიკითხავს. თუ რამე გაუგებარია ან ორაზროვანი მკითხეთ მოურიდებლად. */

 --
 use AdventureWorks2017
 --

 insert into MobileNetworkType (MobileNetworkTypeName)
 values ('Magti'),('Geoseli'),('Bilaini'),('Bani'),('Bali')
 --
 insert into Clients(
		   PersonalID
          ,FullName
		  ,MobilePhone
	      ,BirthDate
	      ,GenderID
	      ,MobileNetworkTypeID)
values (
       '12345678922'
	   ,'asd asd'
	   ,'+99393939'
	   ,'01-01-1994'
	   ,1
	   ,1
	   ),
	   (
       '1234567892'
	   ,'asd aswd'
	   ,'+99393939'
	   ,'01-01-1996'
	   ,1
	   ,3
	   ),
	   (
       '1234568922'
	   ,'asqqd asd'
	   ,'+99393939'
	   ,'01-01-1993'
	   ,0
	   ,4
	   ),
	   (
       '12345672'
	   ,'asd asd'
	   ,'+993939319'
	   ,'01-01-1991'
	   ,1
	   ,2
	   )

--

alter table clients
add constraint FK_clients_1 foreign key (GenderID) references Gender (GenderID)

--
alter table clients
add constraint FK_clients_2 foreign key (MobileNetworkTypeID) references MobileNetworkType (MobileNetworkTypeID)
--
