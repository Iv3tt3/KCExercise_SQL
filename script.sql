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



insert into member (id_passport, "name", surname, birthday, phone)
select distinct tv.dni, tv.nombre, concat(apellido_1, ' ', apellido_2) apellidos, cast(tv.fecha_nacimiento as date), tv.telefono 
from tmp_videoclub tv ;

insert into address (id_member, street, number, extension, postal_code)
select distinct m.id_member, tv.calle, tv.numero, concat(piso, ' ', letra) exten, cast(tv.codigo_postal as INT)
from tmp_videoclub tv 
inner join "member" m on id_passport = tv.dni;

insert into director (director)
select distinct director 
from tmp_videoclub tv ;

insert into genre (genre)
select distinct genero 
from tmp_videoclub tv ;

insert into film (title, sinopsis, year, id_genre, id_director)
select distinct tv.titulo, tv.sinopsis, tv.anyo, g.id_genre, d.id_director 
from tmp_videoclub tv 
inner join genre g on genre = tv.genero
inner join director d on d.director = tv.director
;

insert into stock (id_stock, id_film)
select distinct tv.id_copia, f.id_film 
from tmp_videoclub tv
inner join film f on title = tv.titulo;

insert into rental (pickup, return, id_stock, id_member)
select cast(tv.fecha_alquiler as date), cast(tv.fecha_devolucion as date), tv.id_copia, m.id_member  
from tmp_videoclub tv
inner join "member" m on id_passport = tv.dni;

-- QUERY1: Check available films for renting:

select distinct s.id_stock, f.title, f.sinopsis, f.year, g.genre, d.director
from stock s 
inner join rental r on r.id_stock = s.id_stock
inner join film f on f.id_film = s.id_film
inner join genre g on g.id_genre = f.id_genre
inner join director d on d.id_director = f.id_director 
where s.id_stock not in (
	select r.id_stock 
	from rental r
	where "return" is null
	)
;

-- QUERY2: Check members favourite genre 

-- This option returns only one favourite genre, even member has the same amount of films consumed from two different genre

select id_member, max(concat(num_genre, '-', genre)) as favourite
from(
	select r.id_member, count(g.genre) as num_genre, g.genre
	from rental r
	inner join stock s on s.id_stock = r.id_stock 
	inner join film f on f.id_film = s.id_film 
	inner join genre g on g.id_genre = f.id_genre 
	group by r.id_member, g.genre
	) as sub1
group by id_member
;

-- This option returns genres rented by a member with the same maximum rental count per genre, thus it can be more than one favourite genre per member

select sub1.id_member, concat(num_genre, '-', genre) as favourite
from (
    select r.id_member, count(g.genre) as num_genre, g.genre
	from rental r
	inner join stock s on s.id_stock = r.id_stock 
	inner join film f on f.id_film = s.id_film 
	inner join genre g on g.id_genre = f.id_genre 
	group by r.id_member, g.genre
	) as sub1
	inner join(
	    select id_member, max(num_genre) as MAXnum_genre
	    from (
	        select r.id_member, count(g.genre) as num_genre
	        from rental r
	        inner join stock s on s.id_stock = r.id_stock 
			inner join film f on f.id_film = s.id_film 
			inner join genre g on g.id_genre = f.id_genre 
			group by r.id_member, g.genre
	    ) as sub2
    group by sub2.id_member
) as sub on sub1.id_member = sub.id_member and sub1.num_genre = sub.MAXnum_genre;