drop table if exists catalogs;
create table catalogs(
  id int unsigned not null primary key,
  name varchar(255) comment 'название раздела'
) comment = 'разделы интернет - магазина';


