-- a) Find the titles of all books by Pratchett that cost less than $10
SELECT title FROM BOOK
WHERE authors LIKE "%Pratchett%" AND price < 10

-- b) Give all the titles and their dates of purchase made by a single customer
SELECT BOOK.title, PURCHASE_HISTORY.`datetime`
from PURCHASE_HISTORY
LEFT join BOOK on BOOK.ISBN = PURCHASE_HISTORY.ISBN
WHERE PURCHASE_HISTORY.user_id = 17243

-- c) Find the titles and ISBNs for all books with less than 5 copies in stock
SELECT BOOK.ISBN, BOOK.title from BOOK
LEFT JOIN STORAGE ON STORAGE.ISBN
WHERE STORAGE.amount < 5

-- d) Give all the customers who purchased a book by Pratchett and the titles of Pratchett books they purchased
SELECT PURCHASE_HISTORY.user_id, BOOK.title
FROM PURCHASE_HISTORY
LEFT JOIN BOOK ON PURCHASE_HISTORY.ISBN = BOOK.isbn
WHERE BOOK.title LIKE "%Pratchett%"

-- e) Find the total number of books purchased by a single customer 

SELECT count(quantity) as total_quantity
from PURCHASE_HISTORY
GROUP by user_id
HAVING user_id = 17243

-- f) Find the customer who has purchased the most books and the total number of books they have purchased

SELECT user_id, max(total_quantity) FROM
(
	SELECT user_id, count(quantity) as total_quantity
	from PURCHASE_HISTORY
	GROUP by user_id
	order by total_quantity DESC
)









