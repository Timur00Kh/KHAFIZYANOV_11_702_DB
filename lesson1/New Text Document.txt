--lesson1
create table publisher(
	id serial primary key,
	name varchar(255),
	city VARCHAR(255)
);

CREATE TABLE book
(
    id serial,
    name varchar(255),
    author varchar(255),
    publisher_id int,
    FOREIGN KEY (publisher_id) REFERENCES publisher (id)
);

insert into publisher(name, city) VALUES ('АСТ', 'Москва'),
																				 ('Мнемозина','Москва'),
																				 ('Росмэн','Москва'),
																				 ('Новгород-книга','Краснодар');

insert into book(name, author, publisher_id) VALUES
																										('Война и мир', 'Толстой', 1),
																										('Анна Каренина', 'Толстой', 1),
																										('Воскресенье', 'Толстой', 2),
																										('Борис Годунов', 'Пушкин', 1),
																										('Доктор Живаго', 'Пастернак', 2),
																										('Пиковая Дама', 'Пушкин', 4);

select distinct b.author, p.name from book b inner join publisher p on b.publisher_id = p.id
where exists(SELECT 1 FROM book b2 where b2.author = 'Пушкин' and p.id = b2.publisher_id)
and not exists(SELECT 1 FROM book b3 where b3.author <> 'Пушкин' and p.id = b3.publisher_id);

SELECT p.name, count(publisher_id) as amount from book
full outer join publisher p on book.publisher_id = p.id
group by p.name order by amount desc LIMIT 10;


create table office (
	id serial primary key,
	name VARCHAR(50),
	emp_count int
);

CREATE table emp (
	id serial primary key,
	name VARCHAR(30),
	office_id bigint references office(id)
);