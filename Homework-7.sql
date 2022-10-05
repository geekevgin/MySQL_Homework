use shop; 

-- 1. Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.

select users.id, users.name from users
join orders 
on user_id = orders.user_id;

-- Выведите список товаров products и разделов catalogs, который соответствует товару.
select 
	p.name, p.price, c.name
from catalogs as cat_name
left join
	products as pr_name
on c.id = p.catalog_id; 

