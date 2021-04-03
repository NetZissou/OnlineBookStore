-- a)
SELECT title FROM BOOK
WHERE authors LIKE "%Pratchett%" AND price < 10

-- b) 
SELECT BOOK.title, PURCHASE_HISTORY.`datetime`
from PURCHASE_HISTORY
LEFT join BOOK on BOOK.ISBN = PURCHASE_HISTORY.ISBN
WHERE PURCHASE_HISTORY.user_id = 17243

-- c)
SELECT BOOK.ISBN, BOOK.title from BOOK
LEFT JOIN STORAGE ON STORAGE.ISBN
WHERE STORAGE.amount < 5

-- d) 
SELECT PURCHASE_HISTORY.user_id, BOOK.title
FROM PURCHASE_HISTORY
LEFT JOIN BOOK ON PURCHASE_HISTORY.ISBN = BOOK.isbn
WHERE BOOK.title LIKE "%Pratchett%"

-- e)

SELECT count(quantity) as total_quantity
from PURCHASE_HISTORY
GROUP by user_id
HAVING user_id = 17243

-- f)

SELECT user_id, max(total_quantity) FROM
(
	SELECT user_id, count(quantity) as total_quantity
	from PURCHASE_HISTORY
	GROUP by user_id
	order by total_quantity DESC
)









