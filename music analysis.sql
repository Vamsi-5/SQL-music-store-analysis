-- Viewing all the tables;
SELECT * FROM album;
SELECT * FROM artist; 
SELECT * FROM customer;
SELECT * FROM employee;
SELECT * FROM genre; 
SELECT * FROM invoice;
SELECT * FROM invoice_line; 
SELECT * FROM media_type;
SELECT * FROM playlist;
SELECT * FROM playlist_track;
SELECT * FROM track;

-- Who is the senior most employee based on job title
SELECT * FROM employee ORDER BY levels DESC LIMIT 1;

-- Which country has most invoices 
SELECT billing_country,COUNT(invoice_id) FROM invoice GROUP BY billing_country ORDER BY COUNT(invoice_id) DESC LIMIT 1;

-- What are top 3 values of invoices
SELECT * FROM invoice ORDER BY total DESC LIMIT 3;

-- Write the query that returns the city name and highest number of invoice totals
SELECT billing_city,SUM(total) FROM invoice GROUP BY billing_city ORDER BY SUM(total) DESC; 

-- Write a query that returns the person who spent the most money
SELECT C.first_name,C.last_name,SUM(I.total) FROM customer AS C INNER JOIN invoice AS I ON C.customer_id = I.customer_id GROUP BY C.first_name,C.last_name ORDER BY SUM(total) DESC LIMIT 1;

-- Write a query to return email,first name,last name,genre,of all rock music listeners. Return list by alphabetically ordered by email starting with A.
SELECT DISTINCT C.first_name,C.last_name,C.email FROM customer AS C INNER JOIN invoice AS I1 ON C.customer_id = I1.customer_id
INNER JOIN invoice_line AS I2 ON I1.invoice_id = I2.invoice_id INNER JOIN Track AS T ON I2.track_id = I2.track_id
INNER JOIN Genre AS G ON T.genre_id = G.genre_id WHERE G.name =  'Rock' ORDER BY C.email ASC;

-- Write a query to return artist name and total track count of all top 10 rock bands
SELECT A1.artist_id,A1.name,COUNT(A1.artist_id) FROM track AS T INNER JOIN album AS A2 ON T.album_id=A2.album_id
INNER JOIN artist AS A1 ON A1.artist_id = A2.artist_id
INNER JOIN genre AS G ON G.genre_id = T.genre_id WHERE G.name LIKE 'Rock'
GROUP BY A1.artist_id,A1.name ORDER BY COUNT(A1.artist_id) DESC LIMIT 10;

-- Return song names that have song length more than average song length. Return name,milliseconds for each track. Order by the length with longest one listed first.
SELECT name,milliseconds FROM track WHERE milliseconds > (SELECT AVG(milliseconds) FROM track) ORDER BY milliseconds DESC;

-- Find how much amount spent by each customer on artists. Return customer name,artist name, total spent
SELECT C.first_name,C.last_name,A2.name,SUM(I2.unit_price*I2.quantity) FROM Customer AS C INNER JOIN Invoice AS I1 ON C.customer_id = I1 .customer_id
INNER JOIN invoice_line AS I2 ON I1.invoice_id = I2.invoice_id INNER JOIN Track AS T ON I2.track_id=T.track_id
INNER JOIN Album AS A1 ON T.album_id = A1.album_id INNER JOIN artist AS A2 ON A1.artist_id = A2.artist_id GROUP BY C.first_name,C.last_name,A2.name
ORDER BY SUM(I2.unit_price*I2.quantity) DESC;

-- Write a query to see which genre is most popular in which country. Genre that is most popular will be the most sold one.
SELECT I1.billing_country,G.name,COUNT(I2.quantity), ROW_NUMBER() OVER(PARTITION BY I1.billing_country ORDER BY COUNT(I2.quantity) DESC) FROM Invoice AS I1 INNER JOIN Invoice_line AS I2 ON I1.invoice_id=I2.invoice_id
INNER JOIN Track AS T ON I2.track_id = T.track_id INNER JOIN genre AS G ON T.genre_id = G.genre_id
GROUP BY I1.billing_country,G.name ORDER BY I1.billing_country ASC, COUNT(I2.quantity) DESC;
