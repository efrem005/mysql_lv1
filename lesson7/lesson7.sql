/*
Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.
 */

USE shop;

-- Через SELECT
SELECT
    (SELECT name FROM users WHERE id = orders.user_id) AS 'USER_NAME',
    count(*) AS 'ORDER_COUNT'
FROM
    orders
GROUP BY user_id;

-- Через JOIN
SELECT
    u.name AS 'USER_NAME',
    COUNT(*) AS 'ORDER_COUNT'
FROM
    users AS u
        JOIN orders o ON u.id = o.user_id
GROUP BY u.name;


-- Через JOIN вывод названия товара количества и цены (по тренировался)
SELECT user.id   AS user_id,
       user.name AS user_name,
       ord.id    AS order_id,
       p.name AS product_name,
       op.total AS 'count',
       p.price AS price,
       (p.price * op.total) AS amount
FROM
     users AS user
         RIGHT JOIN orders AS ord ON user.id = ord.user_id
         LEFT JOIN orders_products AS op ON ord.id = op.order_id
         LEFT JOIN products AS p ON op.product_id = p.id;

/*
   Выведите список товаров products и разделов catalogs, который соответствует товару.
 */

USE shop;

-- через SELECT --
SELECT
    id,
    name,
    price,
    (SELECT id FROM catalogs WHERE id = products.catalog_id) AS cat_id,
    (SELECT name FROM catalogs WHERE id = products.catalog_id) AS catalog
FROM
    products;

-- через JOIN --
SELECT prod.id,
       prod.name,
       prod.price,
       cat.id   AS cat_id,
       cat.name AS catalog
FROM
     products AS prod
         LEFT JOIN catalogs AS cat ON prod.catalog_id = cat.id;

/*
(по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name).
Поля from, to и label содержат английские названия городов, поле name — русское.
Выведите список рейсов flights с русскими названиями городов.
 */

-- Через SELECT
SELECT id AS flight_id,
       (SELECT name FROM cities WHERE label = flights.from) AS flight_from,
       (SELECT name FROM cities WHERE label = flights.to)   AS flight_to
FROM flights
ORDER BY flight_id;

-- Через JOIN
SELECT id AS flight_id,
       citi1.name AS flight_from,
       citi2.name AS flight_to
FROM
    flights AS fl
        JOIN cities citi1 ON citi1.label = fl.`from`
        JOIN cities citi2 ON citi2.label = fl.`to`
ORDER BY flight_id;
