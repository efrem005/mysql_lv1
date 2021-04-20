/* Практическое задание по теме “Оптимизация запросов” */

/*
Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users,
catalogs и products в таблицу logs помещается время и дата создания записи, название таблицы,
идентификатор первичного ключа и содержимое поля name.
 */

USE shop;

DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
    name_table VARCHAR(100),
    key_id BIGINT,
    value_name VARCHAR(100),
    created_at DATETIME
) ENGINE = ARCHIVE;

DROP TRIGGER IF EXISTS logs_users;
DELIMITER //
CREATE TRIGGER logs_users AFTER INSERT ON users FOR EACH ROW
BEGIN
    INSERT INTO logs (name_table, key_id, value_name, created_at)
        VALUE ('users', NEW.id, NEW.name, NOW());
END //
DELIMITER ;

DROP TRIGGER IF EXISTS logs_catalogs;
DELIMITER //
CREATE TRIGGER logs_catalogs AFTER INSERT ON catalogs FOR EACH ROW
    BEGIN
       INSERT INTO logs (name_table, key_id, value_name, created_at)
           VALUE ('catalogs', NEW.id, NEW.name, NOW());
    END //
DELIMITER ;

DROP TRIGGER IF EXISTS logs_products;
DELIMITER //
CREATE TRIGGER logs_products AFTER INSERT ON products FOR EACH ROW
BEGIN
    INSERT INTO logs (name_table, key_id, value_name, created_at)
        VALUE ('products', NEW.id, NEW.name, NOW());
END //
DELIMITER ;

INSERT INTO users (name, birthday_at)
VALUES ('Matilda', date(now()));

INSERT INTO catalogs (name)
VALUES ('Dell');

INSERT INTO products (name, description, price, catalog_id)
VALUES ('Intel Xeon E1660 V2', 'Процессор для серверов', 17420.00, 2);

SELECT name_table, key_id, value_name, created_at FROM logs;


/*
Создайте SQL-запрос, который помещает в таблицу users миллион записей.
 */

DROP TABLE IF EXISTS millions_users;
CREATE TABLE millions_users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    birthday_at DATE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

DROP PROCEDURE IF EXISTS insert_users;
delimiter //
CREATE PROCEDURE insert_users ()
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE COUNTER INT DEFAULT 1000000; -- :))))) если нервы железные !!!
    WHILE i < COUNTER DO
            INSERT INTO millions_users(name, birthday_at) VALUES (CONCAT('user_', i), NOW());
            SET i = i + 1;
    END WHILE;
END //
delimiter ;

CALL insert_users();

SELECT id, name, birthday_at, created_at, updated_at FROM millions_users;