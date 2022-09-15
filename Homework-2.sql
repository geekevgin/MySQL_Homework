drop database if exists vk;
create database vk;
use vk;

drop table if exists users;
create table users(
id serial primary key,
firstname varchar (100) comment 'имя',
lastname varchar (100) comment 'фамилия',
email varchar(100) unique,
password_hash varchar (100),
phone bigint unsigned,
is_deleted bit default b'0',
INDEX users_firstname_lastname_idx(firstname, lastname)
);

drop table if exists profile;
create table profile(
user_id serial primary key,
gender char (1),
birthday date, 
photo_id bigint unsigned,
created_at DATETIME DEFAULT NOW(),
hometown VARCHAR(100)
);

ALTER TABLE profile ADD CONSTRAINT fk_user_id
FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE;

drop table if exists messages;
create table messages(
user_id serial primary key,
from_user_id bigint unsigned not null, 
to_user_id bigint unsigned not null,
body TEXT,
created_at datetime default now(),

FOREIGN KEY (from_user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (to_user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE
);

drop table if exists friend_requests;
create table friend_requests(
initiator_user_id bigint unsigned not null, 
target_user_id bigint unsigned not null, 
status enum('requested', 'approved', 'declined', 'unfriended'),
requested_at datetime default now(),
updated_at datetime default now(), 

PRIMARY KEY (initiator_user_id, target_user_id),
FOREIGN KEY (initiator_user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (target_user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE
);

drop table if exists communities;
create table communities(
id serial primary key,
name varchar (150),
admin_user_id bigint unsigned,
INDEX communities_name_idx(name),
FOREIGN KEY (admin_user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE SET NULL
);

drop table if exists user_communities;
create table user_communities(
user_id bigint unsigned not null,
community_id bigint unsigned not null, 
PRIMARY KEY (user_id, community_id), -- чтобы не было 2 записей о пользователе и сообществе
FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (community_id) REFERENCES communities(id) ON UPDATE CASCADE ON DELETE CASCADE
);


DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types(
id SERIAL PRIMARY KEY,
name VARCHAR(255),
created_at DATETIME DEFAULT NOW(),
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS media;
CREATE TABLE media(
id SERIAL PRIMARY KEY,
media_type_id BIGINT UNSIGNED,
user_id BIGINT UNSIGNED NOT NULL,
body text,
filename VARCHAR(255),
 `size` INT,
metadata JSON,
created_at DATETIME DEFAULT NOW(),
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (media_type_id) REFERENCES media_types(id) ON UPDATE CASCADE ON DELETE SET NULL
);

DROP TABLE IF EXISTS likes;
CREATE TABLE likes(
id SERIAL PRIMARY KEY,
user_id BIGINT UNSIGNED NOT NULL,
media_id BIGINT UNSIGNED NOT NULL,
created_at DATETIME DEFAULT NOW(),
FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (media_id) REFERENCES media(id) ON UPDATE CASCADE ON DELETE CASCADE

);

DROP TABLE IF EXISTS `photo_albums`;
CREATE TABLE `photo_albums` (
`id` SERIAL,
`name` varchar(255) DEFAULT NULL,
 `user_id` BIGINT UNSIGNED DEFAULT NULL,

FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE SET NULL,
PRIMARY KEY (`id`)
);

DROP TABLE IF EXISTS `photos`;
CREATE TABLE `photos` (
id SERIAL PRIMARY KEY,
`album_id` BIGINT UNSIGNED NOT NULL,
`media_id` BIGINT UNSIGNED NOT NULL,

FOREIGN KEY (album_id) REFERENCES photo_albums(id) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (media_id) REFERENCES media(id) ON UPDATE CASCADE ON DELETE CASCADE
);

ALTER TABLE profile ADD CONSTRAINT fk_photo_id
FOREIGN KEY (photo_id) REFERENCES photos(id) ON UPDATE CASCADE ON DELETE SET NULL;

#ДОМАШНЕЕ ЗАДАНИЕ 
#Написать cкрипт, добавляющий в БД vk, которую создали на 3 вебинаре, 3-4 новые таблицы

#  Связь 1-М
DROP TABLE IF EXISTS bookmark_types;
CREATE TABLE bookmark_types(
id SERIAL PRIMARY KEY,
name VARCHAR(255),
created_at DATETIME DEFAULT NOW(),
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP

);

DROP TABLE IF EXISTS bookmark;
CREATE TABLE bookmark(
id SERIAL PRIMARY KEY,
bookmark_type_id BIGINT UNSIGNED,
user_id BIGINT UNSIGNED NOT NULL,
body text,
filename VARCHAR(255),
created_at DATETIME DEFAULT NOW(),
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (bookmark_type_id) REFERENCES bookmark_types(id) ON UPDATE CASCADE ON DELETE SET NULL
);

# связь 1-1
drop table if exists activity;
create table activity(
user_id serial primary key,
status_activity enum('Online', 'Offline'), 
created_at DATETIME DEFAULT NOW(),
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
FOREIGN KEY fk_user_id(user_id) REFERENCES users(id)
);

# 1 -M
drop table if exists status;
create table status(
men_user_id bigint unsigned not null, 
lady_user_id bigint unsigned not null,
status_relationship enum('steady_relationship', 'married', 'divorced', 'alone'),
updated_at datetime default now(), 

PRIMARY KEY (men_user_id, lady_user_id),
FOREIGN KEY (men_user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (lady_user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE
);

