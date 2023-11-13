/*1. მოცემულია @Text ცვლადი, სადაც შენახულია ტექსტური მნიშვნელობა:
DECLARE @Text VARCHAR(100) = 'ABCE590-=ACED'
ყველა ქვემოთ ჩამოთვლილი პუნქტი, დაწერეთ ისე, რომ სკრიპტის გაშვებისას, შევძლოთ
ნახვა, რომ აღნიშნული კოდი მუშაობს.გამოიყენეთ მხოლოდ ფუნქციები და ამ ფუნქციებში
მოქცეული @Text ცვლადი, არ გამოიყენოთ მზა ტექსტი.
პირდაპირ პასუხები არ მიიღება, ვწერთ ყველაფერს კოდით.
a. დაწერეთ,95 ASCII კოდის შესაბამისი სიმბოლო (1 ქულა)
b. ჩასვით და გააერთიანეთ 95 ASCII კოდის შესაბამისი სიმბოლო მოცემულ ტექტში ისე,
რომ ეს სიმბოლო მოხვდეს C-სა და E სიმბოლოებს შორის. (5 ქულა)
c. დააბრუნეთ c დავალებაში მიღებული ტექსტის ზომა. (2 ქულა)
d. დააბრუნეთ, მეხსიერების რამდენი უჯრაა გამოყოფილი c დავალებაში მიღებული
ტექსტისთვის,(2 ქულა)*/
--
DECLARE @Text VARCHAR(100) = 'ABCE590-=ACED'
begin 
--a
select char(95) [Symbol]
--b
select CONCAT_WS(char(95),SUBSTRING(@Text,1,CHARINDEX('C',@Text)),SUBSTRING(@Text,CHARINDEX('E',@Text),len(@Text))) [Insert Symbol]
--c
select len(CONCAT_WS(char(95),SUBSTRING(@Text,1,CHARINDEX('C',@Text)),SUBSTRING(@Text,CHARINDEX('E',@Text),len(@Text)))) [Text Size]
--d
select DATALENGTH(CONCAT_WS(char(95),SUBSTRING(@Text,1,CHARINDEX('C',@Text)),SUBSTRING(@Text,CHARINDEX('E',@Text),len(@Text)))) [Data Length]

end
/*2. გამოიყენეთ ცხრილი dbo.DimCustomer ცხრილი AdventureWorksDW2017 ბაზიდან;
a. დააბრუნეთ ისეთი Customer-ები, რომელთა სახელის ბოლო 2 სიმბოლო არის „an“ და ასევე, 
emailAddress ის მნიშვნელობებში მეორე სიმბოლო იყოს O , ფილტრი აღნისნულ სიმბოლოზე
დაადეთ ისე, რომ, წამოიღოს როგორც დიდი სიმბოლოებით დაწერილი იმეილი, ასევე პატარა; 
(or -ით არ დაწეროთ). (3 ქულა)
b. დააჯამეთ YearlyIncome ველი EnglishAducation, FrenchEducation, EnglishOccupation ჭრილებში, 
ისე, რომ შევძლოთ ვნახოთ, როგორც მთლიანი ჯამური თანხა, ასევე ყველანაირ ჭრილში, 
შეინახეთ შედეგი დროებით ცხრილში. (3 ქულა) 
c. გამოიყენეთ დროებითი ცხრილი და FrenchEducation ველიდან თითოეული როუს დონეზე
აჩვენეთ მერამდენე სიმბოლოა + ნიშანი, წაშლაც და სიმბოლოს მოძებნაც ერთდროულად უნდა
ითვლებოდეს ჩადგმული ფუნქციებით, დაარქვით გამოყვანილ ველს სახელი (4 ქულა)*/
--
use AdventureWorksDW2017
--a
select *
from DimCustomer dc
where right(dc.FirstName,2) = 'an' 
      and ascii(substring(dc.EmailAddress,2,1)) in (79,111) 
--b
drop table if exists #Table_1
--
select dc.EnglishEducation
       ,dc.FrenchEducation
	   ,dc.EnglishOccupation
	   ,sum(dc.YearlyIncome) [Sum YearlyIncome]
into #Table_1
from DimCustomer dc
group by cube(dc.EnglishEducation, dc.FrenchEducation, dc.EnglishOccupation)
--c
select dc.FrenchEducation
	  ,CHARINDEX('+',dc.FrenchEducation) [+ position]
from #Table_1 dc
--