use vk;
-- 1. Пусть задан некоторый пользователь. Из всех друзей этого пользователя найдите человека, 
-- который больше всех общался с нашим пользователем

select 
	from_user_id,
	count(*) as sent
from messages 
where to_user_id = 1
and from_user_id in(
	select initiator_user_id from friend_requests
	where (target_user_id = 1 and status = 'approved')
	union
	select target_user_id from friend_requests 
	where (initiator_user_id = 1 and status = 'approved')
)
group by from_user_id 
order by sent desc;

-- 2. Подсчитать общее количество лайков, которые получили пользователи младше 11 лет.

select count(*) as 'like' from profiles where (year(now()) - year(birthday)) < 11;

-- 3. Определить кто больше поставил лайков (всего): мужчины или женщины.

SELECT 
  COUNT(*) as 'amount',
  gender,
  (SELECT gender FROM profiles where id=likes.user_id ) as 'gender'
FROM likes 
GROUP BY gender;
