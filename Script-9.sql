use shop;

-- “Транзакции, переменные, представления”
 
-- 1. В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. 
-- Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.

start transaction;
insert into sample.users select id from shop.users where id = 1
delete from shop.users where id = 1
commit; 

-- 2. Создайте представление, 
-- которое выводит название name товарной позиции из таблицы products и соответствующее название каталога name из таблицы catalogs.

create  view product_name_and_catalog_name (product_name, catalog_name) as select
p.name as product_name,
c.name as catalog_name
from products p
join catalogs c on p.catalog_id = c.id;

select product_name, catalog_name  from product_name_and_catalog_name;

-- “Хранимые процедуры и функции, триггеры"


-- 1. Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток. 
-- С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", 
-- с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".-- 

drop procedure if exists hello;
delimiter //
create procedure hello()
begin 
declare time_now int;
	set time_now = hour(now());	
	if (time_now between '06:00:00' and '12:00:00') then 
		select 'Доброе утро';
	elseif (time_now between '12:00:00' and '18:00:00') then 
		select 'Добрый день';
	elseif (time_now between '18:00:00' and '00:00:00') then 
		select 'Добрый вечер';
	else
		select 'Доброй ночи';
	end if;
end //
call hello();


-- 2. В таблице products есть два текстовых поля: name с названием товара и description с его описанием. 
-- Допустимо присутствие обоих полей или одно из них. 
-- Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема. 
-- Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. 
-- При попытке присвоить полям NULL-значение необходимо отменить операцию.

delete trigger if exists trigger_shop
delimiter //
create trigger trigger_shop before insert on products
for each row
begin
	if (isnull(new.name)) then 
		set new.name = 'no_name';
	end if;
	if (isnull(new.desription)) then
		set new.desription = 'no_description';
	end if;
end //
delimiter ;

