create schema if not exists videoclub;

set schema 'videoclub';

create table if not exists member(
	id_member serial primary key,
	ID_passport VARCHAR(10) not null,
	name VARCHAR(25) not null,
	surname VARCHAR(60) not null,
	birthday DATE not null,
	phone VARCHAR(25) not null
);

create table if not exists address(
	id_member serial primary key,
	street VARCHAR(50) not null,
	number VARCHAR(6) not null,
	extension VARCHAR(10) not null,
	postal_code int not null
);

create table if not exists rental(
	id_rental serial primary key,
	pickup DATE not null,
	return DATE,
	id_stock int not null,
	id_member int not null
);

create table if not exists film(
	id_film serial primary key,
	title VARCHAR(60) not null,
	sinopsis VARCHAR(1000) not null,
	year INT CHECK (LENGTH(CAST(year AS VARCHAR)) = 4 and year>0 and year<=(extract(YEAR from now()))),
	id_genre int not null, 
	id_director int not null
);

create table if not exists stock(
	id_stock serial primary key,
	id_film int not null
);

create table if not exists genre(
	id_genre serial primary key,
	genre VARCHAR(20) not null
);

create table if not exists director(
	id_director serial primary key,
	director VARCHAR(20) not null);



alter table address
add constraint fk_member_address
foreign key (id_member)
references member(id_member);

alter table rental
add constraint fk_member_rental
foreign key (id_member)
references member(id_member);

alter table rental
add constraint fk_inventario_rental
foreign key (id_stock)
references stock(id_stock);

alter table stock
add constraint fk_film_stock
foreign key (id_film)
references film(id_film);

alter table film
add constraint fk_genre_film
foreign key (id_genre)
references genre(id_genre);

alter table film
add constraint fk_director_film
foreign key (id_director)
references director(id_director);


alter table director 
add constraint unique_director
unique (director);

alter table film 
add constraint unique_title
unique (title);

alter table genre  
add constraint unique_genre
unique (genre);

alter table "member"  
add constraint unique_id_passport
unique (id_passport);
