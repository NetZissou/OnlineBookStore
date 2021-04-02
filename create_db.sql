-- !preview conn=DBI::dbConnect(RSQLite::SQLite())


CREATE TABLE CUSTOMER 
(Account_id integer not NULL,
name varchar(15),
phone_number integer,
PRIMARY key(account_id)
);

CREATE TABLE BOOK 
(ISBN varchar(20) not NULL,
  category varchar(15),
  title varchar(50) not NULL,
  price integer not NULL,
  authors varchar(30) not NULL,
  publisher_name varchar(30) not NULL,
  publication_date date,
  PRIMARY key(ISBN),
  FOREIGN key(publisher_name) REFERENCES PUBLISHER(name)
);

CREATE TABLE PUBLISHER 
(name varchar(20) not NULL,
  email varchar(20),
  phone integer,
  address varchar(50),
  PRIMARY key(name)
);

CREATE TABLE PURCHASE_HISTORY 
(user_id integer NOT NULL,
  ISBN varchar(20) NOT NULL,
  `datetime` datetime not NULL,
  transaction_id varchar(20) not NULL,
  quantity integer not NULL,
  PRIMARY key(user_id, ISBN, transaction_id),
  FOREIGN key(user_id) REFERENCES CUSTOMER(account_id),
  FOREIGN key(ISBN) REFERENCES BOOK(ISBN)
);

CREATE TABLE SHOPPING_CART 
(user_id integer NOT NULL,
  ISBN varchar(20) NOT NULL,
  quantity integer not NULL,
  PRIMARY key(user_id, ISBN),
  FOREIGN key(user_id) REFERENCES CUSTOMER(account_id),
  FOREIGN key(ISBN) REFERENCES BOOK(ISBN)
);

CREATE TABLE STORAGE 
(ISBN varchar(20) NOT NULL,
  w_id INTEGER not NULL,
  amount integer not NULL,
  PRIMARY key(w_id, ISBN),
  FOREIGN key(ISBN) REFERENCES BOOK(ISBN),
  FOREIGN key(w_id) REFERENCES WAREHOUSE(w_id)
);

CREATE TABLE WAREHOUSE
(w_id INTEGER not NULL,
  city varchar(15),
  address varchar(30),
  phone_number INTEGER,
  PRIMARY key(w_id)
);







