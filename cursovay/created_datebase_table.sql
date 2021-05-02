DROP DATABASE IF EXISTS `kinopoisk`;
CREATE DATABASE `kinopoisk`;

USE `kinopoisk`;

-- Создаем таблицу пользователя
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
	id SERIAL PRIMARY KEY,
	firstname VARCHAR(100) NOT NULL COMMENT 'Имя',
	lastname VARCHAR(100) NOT NULL COMMENT 'Фамилия',
	email VARCHAR(100) UNIQUE COMMENT '@mail',
	password_hash VARCHAR(100) COMMENT 'Пароль',
    is_deleted  bit default 0,

	index users_name_IDX (firstname, lastname)
);

-- Создаем таблицу профиль пользователя
DROP TABLE IF EXISTS `profiles`;
CREATE TABLE `profiles` (
	user_id SERIAL PRIMARY KEY,
	gender CHAR(1) COMMENT 'Пол',
	birthday DATE COMMENT 'День рождения',
	country_id BIGINT UNSIGNED NOT NULL COMMENT 'Страна',
	city_id BIGINT UNSIGNED NOT NULL COMMENT 'Город',
	description TEXT COMMENT 'О себе',
	interests TEXT COMMENT 'Интересы',
	phone   BIGINT UNSIGNED COMMENT 'номер телефона',
	created_at DATETIME DEFAULT NOW() COMMENT 'Дата создания'
);

-- Создаем таблицу друзей
DROP TABLE IF EXISTS `friend_requests`;
CREATE TABLE `friend_requests` (
	initiator_user_id BIGINT UNSIGNED NOT NULL,
	target_user_id BIGINT UNSIGNED NOT NULL,
	`status` ENUM('requested', 'approved', 'declined', 'unfriended') COMMENT 'статусы',
	requested_at DATETIME DEFAULT NOW() COMMENT 'Время запроса',
	updated_at DATETIME ON UPDATE NOW() COMMENT 'Время подтверждения',

	PRIMARY KEY (initiator_user_id, target_user_id),
	INDEX friend_requests_name_IDX (initiator_user_id, target_user_id)
);
-- Создадим связь с таблицей "friend_requests"
ALTER TABLE friend_requests
    ADD CONSTRAINT friend_requests_fk_1
        FOREIGN KEY (initiator_user_id) REFERENCES users(id)
        ON DELETE CASCADE,
    ADD CONSTRAINT friend_requests_fk_2
        FOREIGN KEY (target_user_id) REFERENCES users(id)
        ON DELETE CASCADE;

-- Создаем таблицу сообщений
DROP TABLE IF EXISTS `messages`;
CREATE TABLE `messages` (
	from_user_id BIGINT UNSIGNED NOT NULL COMMENT 'Кто написал',
	to_user_id BIGINT UNSIGNED NOT NULL COMMENT 'Кому написал',
	body TEXT COMMENT 'Текст сообщения',
	created_at DATETIME DEFAULT NOW() COMMENT 'Время отправки сообщения',

    PRIMARY KEY (from_user_id, to_user_id),
    INDEX messages_name_IDX (from_user_id, to_user_id)
);
-- Создадим связь с таблицей "messages"
ALTER TABLE messages
    ADD CONSTRAINT messages_fk_1
    FOREIGN KEY (from_user_id) REFERENCES users(id)
    ON DELETE CASCADE,
    ADD CONSTRAINT messages_fk_2
    FOREIGN KEY (to_user_id) REFERENCES users(id)
    ON DELETE CASCADE;

-- Создаем таблицу оценок фильмов и комментарии
DROP TABLE IF EXISTS `reviews_media`;
CREATE TABLE `reviews_media` (
	id SERIAL PRIMARY KEY,
	user_id BIGINT UNSIGNED NOT null COMMENT 'Какой пользователь',
	media_id BIGINT UNSIGNED NOT null COMMENT 'Какое видео',
	stars ENUM('1','2','3','4','5') COMMENT 'Оценка',
	body TEXT COMMENT 'Комментарий к фильму',
	created_at DATETIME DEFAULT NOW() COMMENT 'Время'
);
-- Создадим связь с таблицей "reviews_media"
ALTER TABLE reviews_media
    ADD CONSTRAINT reviews_media_fk_1
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE CASCADE;

-- Создам таблицу год выпуска фильма
DROP TABLE IF EXISTS `years`;
CREATE TABLE `years` (
	id SERIAL PRIMARY KEY,
	`year` YEAR COMMENT 'год выпуска',

	INDEX years_name_IDX (year)
);

-- Создам таблицу Категории к медиа
DROP TABLE IF EXISTS `categories`;
CREATE TABLE `categories` (
    id SERIAL PRIMARY KEY,
    `category` VARCHAR(100),

    INDEX categories_name_IDX (category)
);

-- Создам таблицу "страна производства кино"
DROP TABLE IF EXISTS `countries`;
CREATE TABLE `countries` (
	id SERIAL PRIMARY KEY,
	country VARCHAR(100)
);

-- Создадим таблицу города
DROP TABLE IF EXISTS `cities`;
CREATE TABLE `cities` (
	id SERIAL PRIMARY KEY,
	city VARCHAR(100)
);

-- Создадим связь с таблицей "profiles"
ALTER TABLE profiles
ADD CONSTRAINT profiles_fk_1
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE CASCADE,
ADD CONSTRAINT profiles_fk_2
	FOREIGN KEY (city_id) REFERENCES cities(id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
ADD CONSTRAINT profiles_fk_3
    FOREIGN KEY (country_id) REFERENCES countries(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE;

-- Создадим таблицу фильмов
DROP TABLE IF EXISTS `media`;
CREATE TABLE `media` (
	id SERIAL PRIMARY KEY,
	title VARCHAR(100) NOT NULL,
	description TEXT,
	`size` INT,
    metadata JSON,
    category_id BIGINT UNSIGNED NOT NULL,
	country_id BIGINT UNSIGNED NOT NULL,
	year_id BIGINT UNSIGNED NOT NULL,
	created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    INDEX media_name_IDX (id, title, category_id, country_id, year_id)
);
-- Создадим связь с таблицей "media"
ALTER TABLE media
ADD CONSTRAINT media_fk_1
	FOREIGN KEY (country_id) REFERENCES countries(id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
ADD CONSTRAINT media_fk_2
	FOREIGN KEY (year_id) REFERENCES years(id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
ADD CONSTRAINT media_fk_3
	FOREIGN KEY (category_id) REFERENCES categories(id)
	ON DELETE CASCADE
	ON UPDATE CASCADE;

-- Создадим связь с таблицей "reviews_media"
ALTER TABLE reviews_media
ADD CONSTRAINT reviews_media_view
    FOREIGN KEY (media_id) REFERENCES media(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE;

-- Создаем таблицу актеры / режиссёры
DROP TABLE IF EXISTS `actors_and_directors`;
CREATE TABLE `actors_and_directors` (
	id SERIAL primary key,
	firstname VARCHAR(100) NOT NULL,
	lastname VARCHAR(100) NOT NULL,
	birthday DATE,
	country_id BIGINT UNSIGNED NOT NULL,
	media_id BIGINT UNSIGNED NOT NULL,
	city_id BIGINT UNSIGNED NOT NULL,
	status ENUM('actor', 'director'),

	INDEX actors_and_directors_IDX (media_id, firstname, lastname, country_id, city_id)
);
-- Создадим связь с таблицей "actors_and_directors"
ALTER TABLE actors_and_directors
ADD CONSTRAINT actors_and_directors_fk_1
	FOREIGN KEY (country_id) REFERENCES countries(id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
ADD CONSTRAINT actors_and_directors_fk_2
	FOREIGN KEY (city_id) REFERENCES cities(id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
ADD CONSTRAINT actors_and_directors_fk_3
	FOREIGN KEY (media_id) REFERENCES media(id)
	ON DELETE CASCADE
	ON UPDATE CASCADE;

-- Создание таблицы Избранные фильмы пользователя
DROP TABLE IF EXISTS favorites;
CREATE TABLE favorites (
    user_id BIGINT UNSIGNED NOT NULL,
    media_id BIGINT UNSIGNED NOT NULL,

    PRIMARY KEY (user_id, media_id)
);
-- Создадим связь с таблицей "favorites"
ALTER TABLE `favorites`
    ADD CONSTRAINT favorites_users_fk_1
        FOREIGN KEY (user_id) REFERENCES users(id)
            ON DELETE CASCADE,
    ADD CONSTRAINT favorites_media_fk_2
        FOREIGN KEY (media_id) REFERENCES media(id)
            ON DELETE CASCADE;

-- Создадим таблицу новостей
DROP TABLE IF EXISTS `news`;
CREATE TABLE `news` (
	id SERIAL PRIMARY KEY,
	title VARCHAR(100) NOT NULL,
	description TEXT,
	created_at DATE
);

-- Создадим таблицу комментариев для новостей
DROP TABLE IF EXISTS comments;
CREATE TABLE comments (
	id SERIAL PRIMARY KEY,
	user_id BIGINT UNSIGNED NOT NULL,
	news_id BIGINT UNSIGNED NOT NULL,
	comment TEXT,
	created_at DATE
);
-- Создадим связь с таблицей "comments"
ALTER TABLE comments
ADD CONSTRAINT comments_fk_1
	FOREIGN KEY (news_id) REFERENCES news(id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
ADD CONSTRAINT comments_fk_2
	FOREIGN KEY (user_id) REFERENCES users(id)
	ON DELETE CASCADE
	ON UPDATE CASCADE;

-- Таблица для сбора истории и логов
DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
    name_table VARCHAR(100),
    key_id BIGINT,
    value_name VARCHAR(100),
    created_at DATETIME
) ENGINE = ARCHIVE;