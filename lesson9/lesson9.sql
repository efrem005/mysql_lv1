/* Практическое задание по теме “Транзакции, переменные, представления” */

/*
В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных.
Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.
 */

START TRANSACTION;
INSERT INTO sample.users SELECT id, name, birthday_at, created_at, updated_at FROM shop.users WHERE id = 1;
COMMIT;

/*
Создайте представление, которое выводит название name товарной позиции из
таблицы products и соответствующее название каталога name из таблицы catalogs.
 */

CREATE OR REPLACE VIEW Products_view (Products_id, Products_name, Catalogs_name) AS
SELECT
       p.id AS Products_id,
       p.name AS Products_name,
       c.name AS Catalogs_name
FROM
     products AS p
         LEFT JOIN catalogs AS c ON p.catalog_id = c.id;

SELECT Products_id, Products_name, Catalogs_name FROM Products_view;

/*
(по желанию) Пусть имеется таблица с календарным полем created_at.
В ней размещены разряженые календарные записи за август 2018 года '2018-08-01', '2016-08-04', '2018-08-16' и 2018-08-17.
Составьте запрос, который выводит полный список дат за август, выставляя в соседнем поле значение 1,
если дата присутствует в исходном таблице и 0, если она отсутствует.
 */



/*
(по желанию) Пусть имеется любая таблица с календарным полем created_at.
Создайте запрос, который удаляет устаревшие записи из таблицы, оставляя только 5 самых свежих записей.
 */




/* Практическое задание по теме “Администрирование MySQL” (эта тема изучается по вашему желанию) */

/*
Создайте двух пользователей которые имеют доступ к базе данных shop.
Первому пользователю shop_read должны быть доступны только запросы на чтение данных,
второму пользователю shop — любые операции в пределах базы данных shop.
 */

DROP USER IF EXISTS 'shop_read'@'localhost';
CREATE USER 'shop_read'@'localhost' IDENTIFIED WITH sha256_password BY '123456';
GRANT SELECT ON shop.* TO 'shop_read'@'localhost';

DROP USER IF EXISTS 'shop'@'localhost';
CREATE USER 'shop'@'localhost' IDENTIFIED WITH sha256_password BY '123456';
GRANT ALL ON shop.* TO 'shop'@'localhost';



/*
(по желанию) Пусть имеется таблица accounts содержащая три столбца
id, name, password, содержащие первичный ключ, имя пользователя и его пароль.
Создайте представление username таблицы accounts, предоставляющий доступ к столбца id и name.
Создайте пользователя user_read, который бы не имел доступа к таблице accounts,
однако, мог бы извлекать записи из представления username.
 */



/* Практическое задание по теме “Хранимые процедуры и функции, триггеры" */

/*
Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток.
С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с 12:00 до 18:00
функция должна возвращать фразу "Добрый день", с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".
 */

DROP PROCEDURE IF EXISTS hello;
DELIMITER //
CREATE PROCEDURE hello()
BEGIN
    CASE
        WHEN CURDATE() BETWEEN '06:00:00' AND '12:00:00' THEN
            SELECT 'Доброе утро';
        WHEN CURDATE() BETWEEN '12:00:00' AND '18:00:00' THEN
            SELECT 'Добрый день';
        WHEN CURDATE() BETWEEN '18:00:00' AND '00:00:00' THEN
            SELECT 'Добрый вечер';
        ELSE
            SELECT 'Доброй ночи';
    END CASE;
end //
DELIMITER ;

CALL hello();

/*
В таблице products есть два текстовых поля: name с названием товара и description с его описанием.
Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема.
Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены.
При попытке присвоить полям NULL-значение необходимо отменить операцию.
 */

DROP TRIGGER IF EXISTS isNull;
DELIMITER //
CREATE TRIGGER isNull BEFORE INSERT ON products FOR EACH ROW
    BEGIN
        IF(ISNULL(NEW.name) || ISNULL(NEW.description)) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'is Null';
        END IF;
    END //
DELIMITER ;

INSERT INTO products (name, description, price, catalog_id)
VALUES ('INTEL Xeon E-2134', NULL, 9320, 9);

/*
(по желанию) Напишите хранимую функцию для вычисления произвольного числа Фибоначчи.
Числами Фибоначчи называется последовательность в которой число равно сумме двух предыдущих чисел.
Вызов функции FIBONACCI(10) должен возвращать число 55.
 */

