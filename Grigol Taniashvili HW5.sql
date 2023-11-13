/*1. შექმენით ლოკალურად 2 დროებითი ცხრილი, შემდეგი პირობებით : შევამოწმოთ, თუ
არსებული სახელით ცხრილი უკვე არსებობს, query-ს ყოველი ახალი გაშვებისას,
წაშალოს და ახლიდან შექმნას : Table_1, Table_2
 Table_1 ლოგიკა :
o დაასელექთეთ AdventureWorksDW2017.dbo.FactFinance ცხრილი ორი
თარიღის 20120731 და 20130731 მდგომარეობით , სადაც ორგანიზაცია არის
გერმანია (ფილტრად გამოიყენეთ შესაბამისი OrganizationKey) და შედეგი
შეინახეთ Table_1 ცხრილში;

 Table_2 ლოგიკა :
o AdventureWorksDW2017.dbo.FactFinance ცხრილი მხოლოდ 20130731 -ის
მდგომარეობით,
o ორგანიზაცია არის გერმანია და საფრანგეთი, შეინახეთ ცხრილში Table_2.
(2 ქ .) */
--
use AdventureWorksDW2017
--
drop table if exists #Table_1
drop table if exists #Table_2
--
select f.*
into #Table_1
from FactFinance f
where f.OrganizationKey = 12
      and f.Date in ('20120731','20130731') 
--
select f.*
into #Table_2
from FactFinance f
where f.OrganizationKey in (11,12)
	  and f.Date = '20130731'
--

/*2. გააერთიანეთ ეს ორი დროებითი ცხრილი ერთმანეთთან ისე, რომ შედეგში მივიღოთ
უნიკალური ჩანაწერები; (2 ქ.)*/
--
select *
from #Table_1
union
select *
from #Table_2
--

/*3. დააკავშირეთ 1 დავალებაში შექმნილი დროებითი ცხრილები, ისე, რომ პირველი
ცხრილიდან დატოვოთ მხოლოდ ისეთი ჩანაწერები, რაც მეორე ცხრილში არ გვაქვს;
join-ის გარეშე
(2 ქ.)*/
--
select *
from #Table_1
except
select *
from #Table_2
--
/*4. დააკავშირეთ 1 დავალებაში შექმნილი დროებითი ცხრილები, ისე, რომ შედეგში
მივიღოთ ჩანაწერები, რომლებიც ორივე ცხრილს აქვს საერთო;( join-ის გარეშე) (2 ქ .)*/
--
select *
from #Table_1
intersect
select *
from #Table_2
--
/*5. გამოიყენეთ, წინა დავალებაზე შექმნილი ცხრილები: dbo.Students და dbo.Subjects
გამოიყენეთ დააკავშირეთ ეს ორი ცხრილი ერთმანეთთან ისე, რომ შესრულდეს პირობა:
თითოეული სტუდენტი სწავლობს ყველა საგანს ( რაც საგნების ცხრილში გვაქვს
ჩაინსერტებული ). დაწერეთ მხოლოდ select და ცხრილში არ შეიტანოთ ცვლილება .
(2 ქ)*/
--
use AdventureWorks2017
--
select *
from Students st
cross join Subjects sb
--