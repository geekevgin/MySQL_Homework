drop database if exists hiv;
create database hiv;
use hiv;

drop table if exists users;
create table users(
id serial primary key,
firstname varchar (100) not null comment 'имя',
secondname varchar(100) not null comment 'отчество',
lastname varchar (100) not null comment 'фамилия',
gender CHAR(1),
birthday DATE,
email varchar(100) unique,
phone bigint unsigned,
country varchar(100),
city varchar(100),
adress varchar(100),
number_passport bigint unsigned,
number_certificate bigint unsigned,
place_work varchar(100),
description_user text, 
is_deleted bit default b'0',
index users_firstname_secondname_lastname_idx(firstname, secondname, lastname)
);

drop table if exists sick_pay;
create table sick_pay(
id serial primary key,
user_id bigint unsigned not null,
created_at datetime default now(),
updated_at datetime default now(),
description text, 
status enum('opened', 'in process', 'closed')
);


alter table sick_pay add constraint fk_user_id 
foreign key (user_id) references users(id) on update cascade on delete cascade;

drop table if exists hospital_number;
create table hospital_number(
id serial primary key,
name varchar(255),
hospital_number bigint unsigned, 
checked_in datetime default now(),
checked_out datetime default current_timestamp on update current_timestamp
);

drop table if exists hospital;
create table hospital(
id serial primary key,
hospital_type_id bigint unsigned,
user_id bigint unsigned not null,
body text,
checked_in datetime default now(),
checked_out datetime default current_timestamp on update current_timestamp,

foreign key (user_id) references users(id) on update cascade on delete cascade,
foreign key (hospital_type_id) references hospital_number(id) on update cascade on delete  set null
);

drop table if exists doctors;
create table doctors(
id serial primary key,

user_id bigint unsigned not null,
doctor_type_id bigint unsigned, 
firstname varchar (100) not null comment 'имя',
secondname varchar(100) not null comment 'отчество',
lastname varchar (100) not null comment 'фамилия',
speciality varchar(100) not null,
cabinet_number bigint unsigned,

foreign key  (user_id) references users(id)  on update cascade on delete cascade,
foreign key (doctor_type_id) references hospital_number(id) on update cascade on delete  set null
);

drop table if exists hiv_stage;
create table hiv_stage(
id serial primary key,
user_id bigint unsigned not null,
description text, 
status enum('acute HIV', 'chronic HIV', 'AIDS')
);


alter table hiv_stage add constraint hv_user_id 
foreign key (user_id) references users(id) on update cascade on delete cascade;



drop table if exists complaints;
create table complaints(
id serial primary key,
name varchar(255),
complaints_description varchar(255)
);

drop table if exists complaints_type;
create table complaints_type(
id serial primary key,
complaints_type_id bigint unsigned,
user_id bigint unsigned not null,
body text,

foreign key (user_id) references users(id) on update cascade on delete cascade,
foreign key (complaints_type_id) references complaints(id) on update cascade on delete set null
);

drop table if exists contagion_contact;
create table contagion_contact(
user_id serial primary key,
from_user_id bigint unsigned, 
to_user_id bigint unsigned,
description_of_contacts TEXT,
created_at datetime default now(),

foreign key (from_user_id) references users(id) on update cascade on delete cascade,
foreign key (to_user_id) references users(id) on update cascade on delete set null
);

drop table if exists medicines;
create table medicines(
id serial primary key,
medicines_user_id bigint unsigned,
name varchar (150),
body text,
INDEX medicines_name_idx(name),
foreign key (medicines_user_id) references users(id) on update cascade on delete set null
);

drop table if exists user_medicines;
create table user_medicines(
user_id bigint unsigned not null,
medicines_id bigint unsigned not null, 
side_effect text,
dose bigint unsigned not null,
primary key (user_id, medicines_id),
foreign key (user_id) references users(id) on update cascade on delete cascade,
foreign key (medicines_id) references medicines(id) on update cascade on delete cascade
);
