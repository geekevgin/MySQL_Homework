use vk;

-- -- 1. Пусть задан некоторый пользователь. Из всех друзей этого пользователя найдите человека, 
-- который больше всех общался с нашим пользователем

select from_user_id,
	(select concat(firstname, ' ', lastname) from users where id = m.from_user_id) as name,
	count(*) as sent_mes
from messages m 
join friend_requests fr on m.from_user_id = fr.initiator_user_id and m.to_user_id = fr.target_user_id 
where fr.status = 'approved'
group by m.from_user_id 
order by sent_mes desc 
limit 1;

--  2. Подсчитать общее количество лайков, которые получили пользователи младше 11 лет.
select 
	count(*) as num_likes
from users u 
left join profiles p on u.id = p.user_id 
left join likes l on l.user_id = u.id 
where timestampdiff(year, birthday, now()) < 11
order by u.id desc;

-- 3.Определить кто больше поставил лайков (всего): мужчины или женщины. 

select case(gender)
	when 'm' then 'male'
	when 'f' then 'female'
	end as 'more',
	count(*) as num_likes
from profiles p 
join likes l on l.user_id = p.user_id 
group by gender 
order by num_likes desc;