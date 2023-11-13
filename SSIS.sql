create table countries_ssis(
							ID int
							,CountrieCode nvarchar(2)
							,Country nvarchar(100)
							)

select *
from countries_ssis

select *
from countries_ssis_txt

select *
from countriesForSSIS

drop table countries_ssis
drop table countries_ssis_txt

create table countries_ssis_txt(
							ID int
							,CountrieCode nvarchar(2)
							,Country nvarchar(100)
							)
