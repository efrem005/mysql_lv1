/* Пусть в таблице users поля created_at и updated_at оказались незаполненными.
Заполните их текущими датой и временем.
 */

USE shop;

DROP TABLE IF EXISTS users;
CREATE TABLE users
(
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(255),
    birthday_at DATE,
    created_at  DATETIME,
    updated_at  DATETIME
);

INSERT INTO users (name, birthday_at)
VALUES ('eum', '1977-03-09'),
       ('ea', '2015-06-15'),
       ('harum', '1993-09-16'),
       ('cupiditate', '1985-06-10'),
       ('omnis', '2005-12-02'),
       ('magni', '1997-01-09'),
       ('impedit', '1998-09-10'),
       ('ducimus', '2015-03-28'),
       ('doloremque', '1981-03-25'),
       ('dicta', '2021-01-08');


UPDATE users
SET created_at = NOW(),
    updated_at = NOW()
WHERE updated_at IS NULL
  AND created_at IS NULL;

SELECT id, name, birthday_at, created_at, updated_at
FROM users;

/*
Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы
типом VARCHAR и в них долгое время помещались значения в формате 20.10.2017 8:10.
Необходимо преобразовать поля к типу DATETIME, сохранив введённые ранее значения.
 */

USE shop;

DROP TABLE IF EXISTS users;
CREATE TABLE users
(
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(255),
    birthday_at DATE,
    created_at  VARCHAR(255),
    updated_at  VARCHAR(255)
);

INSERT INTO users (name, birthday_at, created_at, updated_at)
VALUES ('iure', '1972-01-10', '1980-12-11 09:15', '1987-08-22 07:33'),
       ('voluptatum', '1993-05-28', '1995-04-26 07:12', '2005-01-01 23:32'),
       ('et', '1987-05-18', '1970-06-27 01:23', '1972-02-22 07:51'),
       ('dolor', '2012-06-05', '2006-03-25 15:23', '1970-02-04 22:01'),
       ('et', '2014-04-05', '2019-10-10 15:05', '1984-06-12 16:57'),
       ('veniam', '1996-02-24', '1994-09-22 21:28', '2005-07-02 07:45'),
       ('amet', '1999-05-22', '2011-09-22 18:21', '2002-06-08 04:30'),
       ('similique', '2009-09-30', '1978-09-03 20:51', '1988-02-08 04:24'),
       ('nostrum', '2007-04-25', '1974-04-12 14:29', '2001-07-13 17:20'),
       ('praesentium', '1978-04-23', '2017-10-11 23:16', '2013-04-27 20:18'),
       ('ea', '1996-01-13', '2011-12-05 02:10', '1985-04-26 18:35'),
       ('ut', '2009-03-30', '2008-08-11 17:40', '2006-06-13 13:12'),
       ('enim', '1978-10-16', '2019-12-19 15:02', '1986-10-19 06:32'),
       ('pariatur', '2009-08-14', '2008-11-02 21:45', '1970-05-20 08:53'),
       ('eaque', '1976-09-16', '2014-06-11 19:42', '2016-06-29 02:55'),
       ('quaerat', '2004-01-20', '1999-06-28 20:18', '2005-11-19 15:20'),
       ('nulla', '1994-10-31', '2003-01-23 00:33', '2013-03-09 21:11'),
       ('sit', '1977-06-27', '1980-05-23 00:44', '2017-02-07 23:58'),
       ('sint', '1998-08-23', '1997-04-18 18:51', '1974-12-10 07:21'),
       ('ipsam', '2000-03-24', '1990-05-11 23:49', '1978-08-13 04:06');

ALTER TABLE users
    MODIFY created_at DATETIME,
    MODIFY updated_at DATETIME;


/*
В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 0,
если товар закончился и выше нуля, если на складе имеются запасы. Необходимо отсортировать записи таким образом,
чтобы они выводились в порядке увеличения значения value. Однако нулевые запасы должны выводиться в конце, после всех
 */

DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products
(
    id            SERIAL PRIMARY KEY,
    storehouse_id INT UNSIGNED,
    product_id    INT UNSIGNED,
    value         INT UNSIGNED COMMENT 'Запас товарной позиции на складе',
    created_at    DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at    DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Запасы на складе';

INSERT INTO storehouses_products (storehouse_id, product_id, value)
VALUES (14, 8, 6),
       (5, 6, 24),
       (2, 8, 0),
       (13, 7, 8),
       (1, 1, 19),
       (3, 8, 2),
       (1, 1, 1),
       (1, 8, 0),
       (11, 12, 7),
       (9, 3, 22),
       (12, 4, 0),
       (13, 4, 20),
       (8, 1, 3),
       (1, 7, 9),
       (4, 11, 15),
       (14, 2, 0),
       (8, 10, 14),
       (9, 7, 5),
       (7, 18, 1),
       (11, 17, 9),
       (6, 10, 10),
       (3, 8, 0),
       (9, 17, 3),
       (12, 15, 19),
       (7, 9, 6),
       (5, 10, 8),
       (9, 20, 0),
       (8, 11, 9),
       (1, 2, 16),
       (15, 7, 8);

SELECT id, storehouse_id, product_id, value
FROM storehouses_products
ORDER BY value DESC;

/*
(по желанию) Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае.
Месяцы заданы в виде списка английских названий (may, august)
 */

SELECT name, birthday_at
FROM users
WHERE DATE_FORMAT(birthday_at, '%M') IN ('may', 'august');

/*
(по желанию) Из таблицы catalogs извлекаются записи при помощи запроса. SELECT * FROM catalogs WHERE id IN (5, 1, 2);
Отсортируйте записи в порядке, заданном в списке IN.
 */

SELECT id, name
FROM catalogs
WHERE id IN (5, 1, 2)
ORDER BY FIELD(id, 5, 1, 2);

/*
 Подсчитайте средний возраст пользователей в таблице users.
*/

SELECT ROUND(AVG(TIMESTAMPDIFF(YEAR, birthday_at, NOW())), 0) AS age
FROM users;
-- если не округлять то получается почти 25 (24.95)   )))

/*
Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели.
Следует учесть, что необходимы дни недели текущего года, а не года рождения.
*/

SELECT DAYNAME(CONCAT(YEAR(NOW()), '-', DATE_FORMAT(birthday_at, '%m-%d'))) AS week_day, COUNT(*) AS birthday
FROM users
GROUP BY week_day
ORDER BY birthday DESC;
-- сдесь долго мучился не сходилось но потом дошло что нужно было сегодняшний год подставить заместо года рождения

/*
(по желанию) Подсчитайте произведение чисел в столбце таблицы.
 */

SELECT sum(price) AS 'SUM' FROM products;