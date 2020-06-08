-- JOINS

-- 1 Get all invoices where the unit_price on the invoice_line is greater than $0.99.
select * from invoice i
join invoice_line il on il.invoice_id = i.invoice_id
where il.unit_price > .99

-- 2 Get the invoice_date, customer first_name and last_name, and total from all invoices.
select invoice.invoice_date, invoice.total,
customer.first_name, customer.last_name from invoice i
join customer c on i.customer_id = c.customer_id;

-- 3 Get the customer first_name and last_name and the support rep's first_name and last_name from all customers.
-- Support reps are on the employee table.
select customer.first_name, customer.last_name,
employee.first_name, employee.last_name from customer c
join employee e on c.support_rep_id = e.employee_id;

-- 4 Get the album title and the artist name from all albums.
select album.title, artist.name
from album al
join artist ar on al.artist_id = ar.artist_id;

-- 5 Get all playlist_track track_ids where the playlist name is Music.
select track_id from playlist_track pt
join playlist p on p.playlist_id = pt.playlist_id
  where p.name = 'Music';

--  6 Get all track names for playlist_id 5.
select t.name from track t
join playlist_track pt on pt.track_id = t.track_id
where pt.playlist_id = 5

--  7 Get all track names and the playlist name that they're on ( 2 joins ).
select t.name, p.name from track t
join playlist_track pt
on pt.track_id = t.track_id
join playlist p
on p.playlist_id = pt.playlist_id;

-- 8 Get all track names and album titles that are the genre Alternative & Punk ( 2 joins ).
select t.name, a.title
from track t
join genre g on g.genre_id = t.genre_id
join album a on a.album_id = t.album_id
where g.genre_id = 4;

-- NESTED QUERIES

-- 1 Get all invoices where the unit_price on the invoice_line is greater than $0.99.
select * from invoice
where invoice_id in (select invoice_id
from invoice_line where unit_price > .99);

-- 2 Get all playlist tracks where the playlist name is Music.
select * from playlist_track
where playlist_id in (select playlist_id
from playlist where name = 'Music');

-- 3 Get all track names for playlist_id 5.
select name from track
where track_id in (select track_id from playlist_track
                   where playlist_id = 5);

-- 4 Get all tracks where the genre is Comedy.
select * from track
where genre_id in (select genre_id from genre
                   where name = 'Comedy');

-- 5 Get all tracks where the album is Fireball.
select * from track
where album_id in (select album_id from album
                   where title = 'Fireball');

-- 6 Get all tracks for the artist Queen ( 2 nested subqueries ).
select * from track
where album_id in (select album_id from album
                   where artist_id in (select artist_id from artist
                                       where name = 'Queen'));

-- UPDATING ROWS

-- 1 Find all customers with fax numbers and set those numbers to null.
update customer
set fax = null
where fax is not null;

-- 2 Find all customers with no company (null) and set their company to "Self".
update customer
set company = 'Self'
where company is null;

-- 3 Find the customer Julia Barnett and change her last name to Thompson.
update customer
set last_name = 'Thompson'
where first_name = 'Julia' and last_name = 'Barnett';

-- 4 Find the customer with this email luisrojas@yahoo.cl and change his support rep to 4.
update customer
set support_rep_id = 4
where email = 'luisrojas@yahoo.cl';

-- 5 Find all tracks that are the genre Metal and have no composer. Set the composer to "The darkness around us".
update track
set composer = 'The darkness around us'
where genre_id = (select genre_id from genre
                  where name = 'Metal')
                  and composer is null;

-- 6 Refresh your page to remove all database changes.

-- GROUP BY

-- 1 Find a count of how many tracks there are per genre. Display the genre name with the count.
select count (*), g.name
from track t
join genre g on g.genre_id = t.genre_id
group by g.name;

-- 2 Find a count of how many tracks are the "Pop" genre and how many tracks are the "Rock" genre.
select count (*), g.name
from track t
join genre g on g.genre_id = t.genre_id
where g.name = 'Pop' or g.name = 'Rock'
group by g.name;

-- 3 Find a list of all artists and how many albums they have.
select ar.name, count (*)
from album al
join artist ar on ar.artist_id = al.artist_id
group by ar.name;

-- DISTINCT

-- 1 From the track table find a unique list of all composers.
select distinct composer
from track;

-- 2 From the invoice table find a unique list of all billing_postal_codes.
select distinct billing_postal_code
from invoice;

-- 3 From the customer table find a unique list of all companys.
select distinct company
from customer;

-- DELETE ROWS

-- 1 Delete all 'bronze' entries from the table.
delete from practice_delete
where type = 'bronze';

-- 2 Delete all 'silver' entries from the table.
delete from practice_delete
where type = 'silver';

-- 3 Delete all entries whose value is equal to 150.
delete from practice_delete
where value = 150;

-- ECOMMERCE SIMULATION

-- Create 3 tables following the criteria in the summary.
-- users need a primary key, name, email.
create table users (
  user_id serial primary key,
  username varchar (30),
  email varchar (100)
  );

-- products need a primary key, name, and a price.
  create table products (
    product_id serial primary key,
    product_name varchar (50),
    price float (2)
    );

-- orders need a primary key and ref to product.
    create table orders (
      order_id serial primary key,
      products varchar (100),
      quantity integer
      );

-- Add some data to fill up each table (3 in each).
insert into users (
  username, email)
  values
  ('Meg', 'meg@meg.com'),
  ('Raef', 'raef@raef.com'),
  ('Leah', 'leah@leah.com');

  insert into products (
  product_name, price)
  values
  ('book', 25),
  ('video game', 60),
  ('pointe shoes', 135);

  insert into orders
  (products, quantity)
  values
  ('book', 7),
  ('video game', 3),
  ('point shoes', 1);

-- Get all products for the first order.
select products from orders
where order_id = 1;

-- Get all orders.
select * from orders;

-- Get the total cost of an order ( sum the price of all products on an order ).


-- Add a foreign key reference from orders to users.
alter table orders
add column users int references users(user_id);

-- Update the orders table to link a user to each order.
update orders
set users = 1
where order_id = 1;

update orders
set users = 3
where order_id = 2;

update orders set users = 2
where order_id = 3;

-- Get all orders for a user.
select * from orders
where users = 3;

-- Get how many orders each user has.
select users, count (*) from orders
where users = users
group by users;

