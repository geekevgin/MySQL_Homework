use hiv;
-- ЗАДАНИЕ 1.
-- БД БОЛЬНЫХ ВИЧ-ИНФЕКЦИЕЙ. ПОЗВОЛЯЕТ НАЙТИ ПАЦИЕНТОВ В ОДНОЙ СТАДИИ ЗАБОЛЕВАНИЯ, НАЙТИ КОНТАКТНЫХ БОЛЬНЫХ, ИЗУЧИТЬ КЛИНИЧЕСКОЕ ТЕЧЕНИЕ ЗАБОЛЕВАНИЯ,
-- НАЙТИ ЛЕЧАЩИХ ДОКТРОВ И БОЛЬНИЦЫ, В КОТОРЫХ ОНИ ПРИНИМАЮТ
-- НАЙТИ ПАЦИЕНТОВ ПО ПРИНИМАЮЩИМ ДОЗАМ ЛЕКАРСВТ И С ПОБОЧНЫМИ ЭФФЕКТАМИ ОТ ТЕРАПИИ

-- 1. -- посморим 5х пациентов, какая стадия заболевания и текующее состояние больничного листа
select 	
	firstname, 
	secondname, 
	lastname,
	(select status from hiv_stage hs where user_id = users.id) as stage,
	(select status from sick_pay sp where user_id = users.id) as sick_pay
from users
limit 5; 

-- 2. -- сгупируем и посчитаем жалобы с порядке убывания
select 
	count(id) as complaints,
	name AS complaints_description_name
from complaints c 
group by complaints_description_name
order by complaints desc
;

-- 3. -- -- сколько больничных листов у каждого пользователя?  
 select 
 	count(id) as number_of_sick_pay,
 (select firstname from users u where id = sp.user_id) as patient
from sick_pay sp 
group by user_id
order by patient asc;

-- 4. -- выбирем пациентов, чтобы узнать от кого они заразились и кого заразили

select user_id, from_user_id, to_user_id  from contagion_contact cc 
where from_user_id = 1 or to_user_id = 1;

-- 5. -- объеденим документы пациента и его контакты с другими больными

select * from complaints_type ct where user_id = 1
union 
select * from hiv_stage hs where user_id in(	
	select from_user_id from contagion_contact where to_user_id = 1
	union 
	select to_user_id from contagion_contact where from_user_id = 1
)
limit 1;

-- 6. -- подсчитываем докторов для пациентов
select 
	doctor_type_id
	, count(*)
from doctors d 
where doctor_type_id  in(
	select user_id from users where user_id = d.doctor_type_id 
)
group by doctor_type_id; 

-- 7. -- выведем пациентов, возраст, место работы, пол в стадии СПИДа с открытым больничным листом
select id, firstname, secondname, lastname, place_work, gender, 
    TIMESTAMPDIFF(year, birthday, now()) as age
  from users
where id in(
	  select user_id from hiv_stage where status = 'AIDS'
	  union
	  select user_id from sick_pay sp where status = 'opened'
);


-- Сложные запросы с использованием JOIN
-- 1. -- посчитаем количество контактов от пользователя
select
count(*) as number_contacts,
u.firstname as 'name',
u.lastname as 'surname'
from users u
join contagion_contact cc on u.id=cc.from_user_id 
group by u.id
order by number_contacts asc;

-- 2.-- посмотрим какой id доктора и сколько раз наблюдал пациента
select doctor_type_id, count(*) 
from doctors d 
join users u on d.doctor_type_id = u.id   
where u.id = 1;

-- 3. -- Посмотрим пациентов, которые передали вирус
select 
u.firstname,
u.lastname
from users u
left join contagion_contact cc on u.id=cc.from_user_id
order by cc.user_id;

-- 4. -- Выберем пользователя по номеру больницу и лечащему доктору
select  
	u.firstname, 
	u.lastname, 
	u.city,
	u.number_certificate 
from users u
join user_hospital uh on u.id=uh.user_id 
join doctors d on uh.hospital_user_id =d.doctor_type_id 
limit 5;

-- 5.-- Посмотрим какой доктор и в каком кабинете осматривал пользователя 1
select 
d.user_id, d.doctor_type_id, d.lastname, d.cabinet_number
  from doctors d 
  join users u on d.user_id = u.id     
  where d.user_id = 1;

-- 6. -- 
select  u.firstname, u.lastname, u.number_certificate 
from users u
join complaints_type ct ON u.id = ct.complaints_type_id 
where u.id = 1;
 
-- 7. -- количество жалоб у пациентов
select
count(*) as total_complaints,
firstname, lastname
from users u
join complaints_type ct on u.id  = ct.user_id
group by u.id 
order by total_complaints asc;

-- 8. -- Выборка пациентов в острой стадии ВИЧ - инфекции у которых был контакт 
select 
 hs.*
  from hiv_stage hs 
    join contagion_contact cc on hs.user_id = cc.from_user_id 
    join users u on cc.to_user_id  = u.id
  	and hs.status = 'acute HIV'
union 
select 
 hs.*
  from hiv_stage hs
    join contagion_contact cc on hs.user_id = cc.to_user_id 
    join users u on cc.from_user_id = u.id  
  	and hs.status = 'acute HIV';

-- 9. -- Количество больничных листов у пациента 
select  
	sp.id,
	count(*) as total_sp,
	concat(u.firstname, ' ', u.lastname) as patient
	from sick_pay sp 
	join doctors d on d.id = d.doctor_type_id 
	join users u on u.id = sp.user_id
where u.id=10
group by sp.id
order by total_sp asc;

-- 10. -- Количество принимаемых лекарственных препаратов у пациентов 

select u.firstname, u.lastname, count(*) as total_medicine
from users u 
join user_medicines um on u.id = um.user_id 
group by u.id 
order by total_medicine desc;

-- 11. -- Среднее количество больничных листов у пациентов
select avg(total_sick_pay) as average_sick_pay
from(
select u.firstname, u.lastname, count(*) as total_sick_pay
from users u
join sick_pay sp on u.id = sp.user_id 
group by u.id
order by total_sick_pay desc
) as list;

-- 12. -- 10 пациентов с самых большим количесвом закрытх больничных листов в стадии СПИДа
select 
	firstname, lastname,
	sp.status,
count(*) as stage_count
from users u
join sick_pay sp on u.id = sp.user_id  and status = 'closed'
join hiv_stage hs on sp.id = hs.user_id where hs.status = 'AIDS'
group by u.id
order by stage_count desc 
limit 10;

-- 13. -- количество  названий больниц в системе госпиталей

select 
count(*) as cnt,
h.name
from user_hospital uh 
join hospitals h on h.id = uh.hospital_user_id 
group by h.id 
order by cnt desc;


-- Хранимые Процедуры 
-- 1.
drop procedure if exists sp_patients
delimiter //
create procedure sp_patients(in for_user_id bigint)
begin
	-- пациенты из одного города
	select u1.id
	from users u1
	join users u2 on u1.city = u2.city
	where u1.id = for_user_id and u2.id <> for_user_id
    union 
-- состоят на учете в одной больнцы 
	select uh2.user_id from user_hospital uh1
	join user_hospital uh2 on uh1.hospital_user_id = uh2.hospital_user_id  
	where uh1.user_id = for_user_id and uh2.user_id <> for_user_id;

END//

delimiter ;

call sp_patients(1)

-- 2.
drop procedure if exists sp_doctors
delimiter //
create procedure sp_doctors(in for_user_id bigint)
begin
	-- врачи, ведущие прием в одном кабинете
	select d1.id
	from doctors d1
	join doctors d2 on d1.cabinet_number  = d2.cabinet_number 
	where d1.id = for_user_id and d2.id <> for_user_id
    union 
-- состоят в одной больнице и лечат одних пациентов
	SELECT d2.user_id FROM doctors d1
	JOIN doctors d2 ON d1.doctor_type_id  = d2.doctor_type_id 
	WHERE d2.user_id  = for_user_id AND d2.user_id <> for_user_id;
END//

delimiter ;

call sp_doctors(1)

-- представления
-- 1. -- пациент и его email с закрытым больничным листом
create or replace view hiv_patients
as 
select u.id, u.email 
from users u 
join sick_pay sp on u.id = sp.user_id 
where sp.status = 'closed'

select * from hiv_patients;

-- 2. -- список пациентов и номеров их страхового полюса, принимающие одни лекарства и находящиеся на лечение в больнице
create or replace view hiv_medicines
as
select u.id , u.number_certificate
from users u 
join user_medicines um on u.id = um.user_id 
union 
select u.id, u.number_certificate
from users u 
join user_hospital uh on u.id = uh.user_id;

select * from hiv_medicines;

-- 3. -- пациенты с дозировкой лекарства больше 507
create or replace view dose_medicine
as 
select u.id, u.firstname  
from users u
join user_medicines um on u.id = um.dose
where um.dose > 507;

select * from dose_medicine;





