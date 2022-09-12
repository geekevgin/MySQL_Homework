# 1.Установите СУБД MySQL. Создайте в домашней директории файл .my.cnf, задав в нем логин и пароль, который указывался при установке.
#СУБД MySQL установлено. Файл .my.cnf создан, но не получается его авторизировать. Приходится входить через -u и -p.

# 2. Создайте базу данных example, разместите в ней таблицу users, состоящую из двух столбцов, числового id и строкового name.
#Database была создана через командную строку и там же использовалось USE.

drop table if exists users;
create table users(
  id SERIAL primary key,
  name varchar(255)
) comment = 'Имя';


# 3. Создайте дамп базы данных example из предыдущего задания, разверните содержимое дампа в новую базу данных sample.

# create database и use через командную строку 

# mysqldump -u root -p example > sample.sql
# mysql -u root -p sample < sample.sql  
# mysql -u root -p
# SHOW DATABASES