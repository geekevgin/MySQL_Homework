drop table if exists catalogs;
create table catalogs(
  id SERIAL primary key,
  name varchar(255) comment 'название раздела',
  unique unique_name(name(10))
) comment = 'разделы интернет - магазина';

insert into catalogs values (null, 'Процессоры');
insert into catalogs (id, name) values (null, 'мат.платы');
insert into catalogs values (default, 'Видеокарты');

delete from catalogs;

select id, name from catalogs;

drop table if exists users;
create table users(
  id serial primary key,
  name varchar(255) comment 'имя покупателя',
  birthday_at date comment 'дата рождения',
  created_at datetime default current_timestamp, 
  updated_at datetime default current_timestamp on update current_timestamp
) comment = 'покуппатели';

insert into users (id, name, birthday_at) values (1, 'hello', '1987-02-08');
SELECT * FROM users;

drop table if exists products;
create table products(
  id serial primary key,
  name varchar(255) comment 'название',
  description text comment 'описание',
  price decimal (11, 2) comment 'цена',
  catalog_id int unsigned,
  created_at datetime default current_timestamp,
  updated_at datetime default current_timestamp on update current_timestamp,
  key index_of_catalog_id(catalog_id)
) comment = 'товарные позиции';

drop table if exists orders_products;
create table orders_products(
  id serial primary key,
  order_id int unsigned,
  product_id int unsigned, 
  total int unsigned default 1 comment 'количество заказанных товаров',
  created_at datetime default current_timestamp,  
  updated_at datetime default current_timestamp on update current_timestamp
) comment = 'состав заказа';

drop table if exists orders;
create table orders(
  id serial primary key,
  user_id int unsigned,
  created_at datetime default current_timestamp,  
  updated_at datetime default current_timestamp on update current_timestamp, 
  key index_of_user_id(user_id)
) comment = 'заказы';

drop table if exists discounts;
create table discounts(
  id serial primary key,
  user_id int unsigned,
  product_id int unsigned, 
  discount float unsigned comment 'скидка от 0.0 до 1.0',
  started_at datetime,
  finished_at datetime,
  created_at datetime default current_timestamp,
  updated_at datetime default current_timestamp on update current_timestamp, 
  key index_of_user_id(user_id),
  key index_of_product_id(product_id)
) comment = 'скидки';

drop table if exists storehouse;
create table storehouse(
  id serial primary key,
  name varchar(255) comment 'название',
  created_at datetime default current_timestamp,
  updated_at datetime default current_timestamp on update current_timestamp
) comment = 'склады';


drop table if exists storehouse_products;
create table storehouse_products(
  id serial primary key,
  storehouse_id int unsigned,
  product_id int unsigned, 
  value int unsigned comment 'запас товарной позиции на складе',
  created_at datetime default current_timestamp,
  updated_at datetime default current_timestamp on update current_timestamp
) comment = 'запасы на складе';

