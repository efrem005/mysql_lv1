/* Задача 1
Написать cкрипт, добавляющий в БД vk, которую создали на 3 вебинаре, 3-4 новые таблицы (с перечнем полей, указанием индексов и внешних ключей).
по желанию: организовать все связи 1-1, 1-М, М-М
*/

-- использование базы
use vk;
-- создание таблицы видео каталога
DROP TABLE IF EXISTS video_albums;
CREATE TABLE video_albums (
    `id` SERIAL PRIMARY KEY,
    `name` VARCHAR(255) DEFAULT NULL,
    `user_id` BIGINT UNSIGNED DEFAULT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE
);

-- создание таблицы видео ролика
DROP TABLE IF EXISTS video;
CREATE TABLE video (
    id SERIAL PRIMARY KEY,
    `album_id` BIGINT UNSIGNED NOT NULL,
    `media_id` BIGINT UNSIGNED NOT NULL,

    FOREIGN KEY (album_id) REFERENCES video_albums(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (media_id) REFERENCES media(id) ON UPDATE CASCADE ON DELETE CASCADE
);

-- создание таблицы музыкальный Альбом
DROP TABLE IF EXISTS `album_music`;
CREATE TABLE `album_music` (
    album_id   SERIAL,
    album_name VARCHAR(50),
    PRIMARY KEY (album_id)
);

-- создание таблицы Исполнители
DROP TABLE IF EXISTS `performers_music`;
CREATE TABLE `performers_music` (
    performers_id   SERIAL,
    performers_name VARCHAR(50),
    PRIMARY KEY (performers_id)
);

-- создание таблицы Музыка
DROP TABLE IF EXISTS music;
CREATE TABLE music (
    id SERIAL PRIMARY KEY,
    track_name VARCHAR(50),
    duration VARCHAR(15),
    album_id BIGINT UNSIGNED NOT NULL,
    performers_id BIGINT UNSIGNED NOT NULL,
    added_user_id BIGINT UNSIGNED NOT NULL,
    created_at DATETIME DEFAULT NOW(),

    FOREIGN KEY (album_id) REFERENCES album_music(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (performers_id) REFERENCES performers_music(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (added_user_id) REFERENCES users(id),
    INDEX music_track_name(track_name)
);

-- создание таблицы для Добавление трека в избраное
DROP TABLE IF EXISTS my_play_list;
CREATE TABLE my_play_list (
                              id SERIAL PRIMARY KEY,
                              user_music_id BIGINT UNSIGNED,
                              my_music_id BIGINT UNSIGNED,

                              FOREIGN KEY (user_music_id) REFERENCES users(id),
                              FOREIGN KEY (my_music_id) REFERENCES music(id) ON UPDATE CASCADE ON DELETE CASCADE
);