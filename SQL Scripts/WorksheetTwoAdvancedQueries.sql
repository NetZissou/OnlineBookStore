-- a) ====================================================
SELECT PURCHASE_HISTORY.user_id, 
BOOK.price * PURCHASE_HISTORY.quantity AS total_dollars
from PURCHASE_HISTORY
LEFT JOIN BOOK on BOOK.isbn = PURCHASE_HISTORY.isbn
GROUP by user_id 

-- b) ====================================================
CREATE view agg_user_purchase as 
SELECT PURCHASE_HISTORY.user_id, 
BOOK.price * PURCHASE_HISTORY.quantity AS total_dollars
from PURCHASE_HISTORY
LEFT JOIN BOOK on BOOK.isbn = PURCHASE_HISTORY.isbn
GROUP by user_id

SELECT Account_id, phone_number
FROM CUSTOMER
WHERE Account_id in (
	SELECT user_id from agg_user_purchase
  	WHERE agg_user_purchase.total_dollars > (SELECT AVG(total_dollars) from agg_user_purchase)
)

-- c) ====================================================

SELECT BOOK.ISBN, BOOK.title, 
count(PURCHASE_HISTORY.quantity) as total_sold
FROM PURCHASE_HISTORY
LEFT JOIN BOOK on BOOK.ISBN = PURCHASE_HISTORY.ISBN
GROUP BY BOOK.ISBN
ORDER BY total_sold desc

-- d) ====================================================

SELECT BOOK.ISBN, BOOK.title, 
SUM(PURCHASE_HISTORY.quantity * BOOK.price) as total_dollars
FROM PURCHASE_HISTORY
LEFT JOIN BOOK on BOOK.ISBN = PURCHASE_HISTORY.ISBN
GROUP BY BOOK.ISBN
ORDER BY total_dollars desc


-- e) ====================================================

CREATE view agg_book_quantity as 
SELECT BOOK.ISBN, BOOK.title, BOOK.authors,
count(PURCHASE_HISTORY.quantity) as total_sold
FROM PURCHASE_HISTORY
LEFT JOIN BOOK on BOOK.ISBN = PURCHASE_HISTORY.ISBN
GROUP BY BOOK.ISBN
ORDER BY total_sold desc


SELECT authors 
FROM agg_book_quantity
WHERE total_sold IN (
	SELECT max(total_sold) FROM agg_book_quantity
)

-- f) ====================================================

CREATE view agg_book_dollars as 
SELECT BOOK.ISBN, BOOK.title, BOOK.authors,
SUM(PURCHASE_HISTORY.quantity * BOOK.price) as total_dollars
FROM PURCHASE_HISTORY
LEFT JOIN BOOK on BOOK.ISBN = PURCHASE_HISTORY.ISBN
GROUP BY BOOK.ISBN
ORDER BY total_dollars desc

SELECT authors 
FROM agg_book_dollars
WHERE total_dollars in (
	SELECT max(total_dollars) FROM agg_book_dollars
)

-- g) ====================================================

SELECT CUSTOMER.Account_id, CUSTOMER.name, CUSTOMER.phone_number
FROM CUSTOMER
WHERE Account_id IN (
	SELECT user_id 
  	FROM PURCHASE_HISTORY 
  	LEFT JOIN BOOK ON BOOK.ISBN = PURCHASE_HISTORY.ISBN
  	WHERE authors IN (
    	SELECT authors 
		FROM agg_book_dollars
		WHERE total_dollars IN (
		SELECT max(total_dollars) FROM agg_book_dollars
		)
    )
)

-- h) ====================================================

SELECT BOOK.authors
FROM PURCHASE_HISTORY
left JOIN BOOK on BOOK.ISBN = PURCHASE_HISTORY.ISBN 
where user_id in (
	SELECT Account_id
	FROM CUSTOMER
	WHERE Account_id in (
		SELECT user_id from agg_user_purchase
  		WHERE agg_user_purchase.total_dollars > (SELECT AVG(total_dollars) from agg_user_purchase)
	)
)























