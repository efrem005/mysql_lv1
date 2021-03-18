-- 1. Установите СУБД MySQL. Создайте в домашней директории файл .my.cnf, задав в нем логин и пароль, который указывался при установке.
-- Установил Mysql 8.0, создал фаил my.cnf с содержимым:
-- [mysql]
-- user=root
-- password=root
-- теперь mysql не запрашивает логин и пароль
-- и запускается из любой деректории командой mysql

-- 2. Создайте базу данных example, разместите в ней таблицу users, состоящую из двух столбцов, числового id и строкового name.

CREATE DATABASE example;

USE example;

CREATE TABLE users (
  id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
  name VARCHAR(100) NOT NULL
);

-- 3. Создайте дамп базы данных example из предыдущего задания, разверните содержимое дампа в новую базу данных sample.

-- cmd -- mysqldump example > example.sql
CREATE DATABASE sample;
-- cmd -- mysql sample < example.sql

-- 4. (по желанию) Ознакомьтесь более подробно с документацией утилиты mysqldump.
-- Создайте дамп единственной таблицы help_keyword базы данных mysql.
-- Причем добейтесь того, чтобы дамп содержал только первые 100 строк таблицы.

-- cmd -- mysqldump --where="1 limit 100" mysql help_keyword > dump_help_keyword.sql
