use shop;
-- 1. Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.
update users
set created_at = now() and updated_at = now()
;

-- 2. Таблица users была неудачно спроектирована. Необходимо преобразовать поля к типу DATETIME, сохранив введённые ранее значения.

alter table users modify column created_at varchar(150); -- преобразуем колонку в VARCHAR
alter table users modify column updated_at varchar(150); 

update users 
set created_at =  str_to_date(created_at, '%Y-%m-%d %H.%i.%s'), -- Из строки в дату
updated_at = str_to_date(updated_at,'%Y-%m-%d %H.%i.%s')

-- приведение типа данных колонок с VARCHAR на DATETIME
alter table users modify column created_at datetime;
alter table users modify column updated_at datetime;

update users
set created_at = date_format(created_at, '%Y-%m-%d %H.%i.%s'),
updated_at  = date_format(updated_at, '%Y-%m-%d %H.%i.%s')
;


-- 3 В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 0. 
-- если товар закончился и выше нуля, если на складе имеются запасы. 
-- Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value.
--  Однако нулевые запасы должны выводиться в конце, после всех записаей

select * from storehouse_products;
insert into storehouse_products 
(storehouse_id, product_id, value, created_at, updated_at)
values 
(2, 2, 8, now(), now()), 
(4, 4, 0, now(), now()),
(6, 6, 2, now(), now()),
(8, 8, 5, now(), now()), 
(10, 10, 1, now(), now());


select  * from storehouse_products order by value desc;

-- 1. Подсчитайте средний возраст пользователей в таблице users.
select round(avg((to_days(now()) - to_days(birthday_at)) / 365.25), 0) as average_age from users; 


-- 2. Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели.
-- Следует учесть, что необходимы дни недели текущего года, а не года рождения.

select 
substring(birthday_at, 6, 10) as a_day_and_a_week_of_the_birthday_of_the_year,
count(*) as number_of_birthday
from users 
group by a_day_and_a_week_of_the_birthday_of_the_year
order by number_of_birthday desc;



