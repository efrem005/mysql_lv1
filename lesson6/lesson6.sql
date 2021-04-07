/*
Пусть задан некоторый пользователь. Из всех друзей этого пользователя найдите человека,
который больше всех общался с нашим пользователем.
*/

SELECT
    count(*) AS 'count_messages',
    friend_id
FROM
     (SELECT body, to_user_id AS friend_id FROM messages WHERE from_user_id = 1
     UNION
     SELECT body, from_user_id AS user_friend_id FROM messages WHERE to_user_id = 1) as search

WHERE friend_id IN (SELECT initiator_user_id FROM friend_requests WHERE status = 'approved'
                    UNION
                    SELECT target_user_id FROM friend_requests WHERE status = 'approved')
GROUP BY friend_id
ORDER BY count_messages DESC
LIMIT 1;

/*
Подсчитать общее количество лайков, которые получили пользователи младше 10 лет.
*/

SELECT COUNT(*) AS 'COUNT'
FROM likes
WHERE TIMESTAMPDIFF(YEAR,
    (SELECT birthday FROM profiles WHERE user_id = likes.media_id),
    NOW()) < 10;

/*
Определить кто больше поставил лайков (всего): мужчины или женщины.
*/

SELECT
    gender AS 'GENDER',
    count(*) AS 'LIKE'
FROM
    (SELECT user_id AS USER,
        (SELECT CASE (gender)
            WHEN 'm' THEN 'мужской'
            WHEN 'f' THEN 'женский'
            ELSE 'нет'
        END as gender
        FROM profiles
        WHERE user_id = user
        ) AS gender
    FROM likes
    ) AS likes_gender_count
GROUP BY gender;