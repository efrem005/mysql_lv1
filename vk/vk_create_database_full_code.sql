DROP DATABASE IF EXISTS vk;
CREATE DATABASE vk;

USE vk;

DROP TABLE IF EXISTS users;
CREATE TABLE users
(
    id            SERIAL PRIMARY KEY,
    firstname     VARCHAR(100),
    lastname      VARCHAR(100) COMMENT 'Фамилия',
    email         VARCHAR(120) UNIQUE,
    password_hash VARCHAR(100),
    phone         BIGINT UNSIGNED,
    is_deleted    bit default 0,
    INDEX users_firstname_lastname_idx (lastname, firstname)
);

-- 1-1

DROP TABLE IF EXISTS `profiles`;
CREATE TABLE `profiles`
(
    user_id    SERIAL PRIMARY KEY,
    gender     CHAR(1),
    birthday   DATE,
    photo_id   BIGINT UNSIGNED NULL,
    created_at DATETIME DEFAULT NOW(),
    hometown   VARCHAR(100)
);

ALTER TABLE `profiles`
    ADD CONSTRAINT fk_user_id
        FOREIGN KEY (user_id) REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE;


-- 1-M

DROP TABLE IF EXISTS `messages`;
CREATE TABLE `messages`
(
    id           SERIAL PRIMARY KEY,
    from_user_id BIGINT UNSIGNED NOT NULL,
    to_user_id   BIGINT UNSIGNED NOT NULL,
    body         TEXT,
    created_at   DATETIME DEFAULT NOW(),
    FOREIGN KEY (from_user_id) REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (to_user_id) REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE
);

-- 1-M

DROP TABLE IF EXISTS `friend_requests`;
CREATE TABLE `friend_requests`
(
    initiator_user_id BIGINT UNSIGNED                                                              NOT NULL,
    target_user_id    BIGINT UNSIGNED                                                              NOT NULL,
    `status`          ENUM ('requested', 'approved', 'declined', 'unfriended') DEFAULT 'requested' NULL,
    requested_at      DATETIME                                                 DEFAULT NOW(),
    updated_id        DATETIME ON UPDATE NOW(),

    PRIMARY KEY (initiator_user_id, target_user_id),
    FOREIGN KEY (initiator_user_id) REFERENCES users (id),
    FOREIGN KEY (target_user_id) REFERENCES users (id)
);

-- M-M

DROP TABLE IF EXISTS `communities`;
CREATE TABLE `communities`
(
    id            SERIAL PRIMARY KEY,
    name          VARCHAR(150),
    admin_user_id BIGINT UNSIGNED,

    INDEX communities_name_idx (name),
    FOREIGN KEY (admin_user_id) REFERENCES users (id) ON UPDATE CASCADE ON DELETE SET NULL
);

-- M-M

DROP TABLE IF EXISTS `users_communities`;
CREATE TABLE `users_communities`
(
    user_id      BIGINT UNSIGNED NOT NULL,
    community_id BIGINT UNSIGNED NOT NULL,

    PRIMARY KEY (user_id, community_id),
    FOREIGN KEY (user_id) REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (community_id) REFERENCES communities (id) ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types
(
    id         SERIAL PRIMARY KEY,
    name       VARCHAR(255),
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS media;
CREATE TABLE media
(
    id            SERIAL PRIMARY KEY,
    user_id       BIGINT UNSIGNED NOT NULL,
    body          text,
    filename      VARCHAR(255),
    `size`        INT,
    metadata      JSON,
    media_type_id BIGINT UNSIGNED,
    created_at    DATETIME DEFAULT NOW(),
    updated_at    DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users (id),
    FOREIGN KEY (media_type_id) REFERENCES media_types (id) ON UPDATE CASCADE ON DELETE SET NULL
);

DROP TABLE IF EXISTS likes;
CREATE TABLE likes
(
    id         SERIAL PRIMARY KEY,
    user_id    BIGINT UNSIGNED NOT NULL,
    media_id   BIGINT UNSIGNED NOT NULL,
    created_at DATETIME DEFAULT NOW(),

    FOREIGN KEY (user_id) REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (media_id) REFERENCES media (id) ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE IF EXISTS photo_albums;
CREATE TABLE photo_albums
(
    `id`      SERIAL,
    `name`    VARCHAR(255)    DEFAULT NULL,
    `user_id` BIGINT UNSIGNED DEFAULT NULL,

    FOREIGN KEY (user_id) REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY (`id`)
);

DROP TABLE IF EXISTS photo;
CREATE TABLE photo
(
    id         SERIAL PRIMARY KEY,
    `album_id` BIGINT UNSIGNED NOT NULL,
    `media_id` BIGINT UNSIGNED NOT NULL,

    FOREIGN KEY (album_id) REFERENCES photo_albums (id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (media_id) REFERENCES media (id) ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE IF EXISTS video_albums;
CREATE TABLE video_albums
(
    `id`      SERIAL PRIMARY KEY,
    `name`    VARCHAR(255)    DEFAULT NULL,
    `user_id` BIGINT UNSIGNED DEFAULT NULL,

    FOREIGN KEY (user_id) REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE IF EXISTS video;
CREATE TABLE video
(
    id         SERIAL PRIMARY KEY,
    `album_id` BIGINT UNSIGNED NOT NULL,
    `media_id` BIGINT UNSIGNED NOT NULL,

    FOREIGN KEY (album_id) REFERENCES video_albums (id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (media_id) REFERENCES media (id) ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE IF EXISTS album_music;
CREATE TABLE album_music
(
    id         SERIAL,
    album_name VARCHAR(50),
    PRIMARY KEY (id)
);

DROP TABLE IF EXISTS performers_music;
CREATE TABLE performers_music
(
    id              SERIAL,
    performers_name VARCHAR(50),
    PRIMARY KEY (id)
);

DROP TABLE IF EXISTS my_play_list;
CREATE TABLE my_play_list
(
    id            SERIAL PRIMARY KEY,
    user_music_id BIGINT UNSIGNED,
    my_music_id   BIGINT UNSIGNED,

    FOREIGN KEY (user_music_id) REFERENCES users (id),
    FOREIGN KEY (my_music_id) REFERENCES music (id) ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE IF EXISTS music;
CREATE TABLE music
(
    id            SERIAL PRIMARY KEY,
    track_name    VARCHAR(50),
    duration      VARCHAR(15),
    album_id      BIGINT UNSIGNED NOT NULL,
    performers_id BIGINT UNSIGNED NOT NULL,
    added_user_id BIGINT UNSIGNED NOT NULL,
    created_at    DATETIME DEFAULT NOW(),

    FOREIGN KEY (album_id) REFERENCES album_music (id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (performers_id) REFERENCES performers_music (id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (added_user_id) REFERENCES users (id),
    INDEX music_track_name (track_name)
);