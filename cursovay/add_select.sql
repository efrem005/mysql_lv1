-- Получим топ 10 фильмов по рейтингу
SELECT
	m.title AS media_name,
	ROUND(AVG(rm.stars), 1) AS rating
FROM reviews_media AS rm
JOIN media AS m ON m.id = rm.media_id
GROUP BY m.id
ORDER BY rating DESC
LIMIT 10;

-- Получим на какие фильмы пользаватель оставил отзыв по id пользователя
SELECT
    CONCAT(u.firstname, ' ', u.lastname) AS user_name,
    m.title AS media_name,
    rm.stars AS stars
FROM users AS u
    JOIN reviews_media AS rm ON u.id = rm.user_id
    JOIN media AS m ON rm.media_id = m.id
WHERE u.id = 10;

-- Получаем самый популярный жанр
SELECT
    c.category AS category_name,
    ROUND(AVG(rm.stars), 1) AS rating
FROM reviews_media AS rm
JOIN media AS m ON rm.media_id = m.id
JOIN categories AS c ON m.category_id = c.id
GROUP BY m.id
ORDER BY rating DESC
LIMIT 10;

-- Поиск фильмов по странам
SELECT
    m.title,
    rm.stars
FROM media m
JOIN reviews_media rm ON m.id = rm.media_id
JOIN categories c ON M.CATEGORY_ID = C.ID
JOIN countries ct ON m.country_id = ct.id
WHERE ct.country = 'США';

-- Поиск фильмов по актерам (Sallie,Kyle,Evangeline,Karson,Jailyn) и.д
SELECT
    (SELECT title FROM media WHERE id =
                                   (SELECT media_id FROM actors_and_directors WHERE firstname = 'Karson')) AS media_name,
    CONCAT(firstname, ' ', lastname) AS actor_name
FROM actors_and_directors
WHERE firstname = 'Karson' && status = 'actor';


-- ТРИГГЕРЫ --

-- Триггер для сбора истории таблицы Users
DROP TRIGGER IF EXISTS logs_users;
DELIMITER //
CREATE TRIGGER logs_users AFTER INSERT ON users FOR EACH ROW
BEGIN
    INSERT INTO logs (name_table, key_id, value_name, created_at)
        VALUE ('users', NEW.id, NEW.email, NOW());
END //
DELIMITER ;

-- Процедура проверки друзей у пользователя
DROP PROCEDURE IF EXISTS user_friends;
DELIMITER //
CREATE PROCEDURE user_friends(user_id BIGINT)
BEGIN
    SELECT
        f1.target_user_id AS users_id,
        CONCAT(u2.lastname, ' ', u2.firstname) AS users_name,
        f1.status
    FROM users AS u1
    JOIN friend_requests AS f1 ON u1.id = f1.initiator_user_id
    JOIN users AS u2 ON f1.target_user_id = u2.id
    WHERE u1.id = user_id AND f1.status = 'approved';
END //

DELIMITER ;

-- вызов процедуры 'user_friends'
CALL user_friends(3);


