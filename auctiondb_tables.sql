/* RuBIS Benchmark Tables, INFO3404 DB Tuning Assignment, 2012sem2*/

/* clean up eventually already existing tables */
/* NOTE A: If you run this script the first time, ignore any errors! */
/* NOTE B: If you are running this script in your own PostgreSQL installation */
/*         then you must adjust the user name in the last line! */

BEGIN TRANSACTION;


DROP SCHEMA IF EXISTS INFO3404_AuctionDB CASCADE;

CREATE SCHEMA INFO3404_AuctionDB 

/* Categories table */
CREATE TABLE Categories (
   id   SERIAL NOT NULL,
   name VARCHAR(50)
)
GRANT ALL ON Categories TO public

/* Regions Table */
CREATE TABLE Regions (
   id   SERIAL NOT NULL,
   name VARCHAR(25)
)
GRANT ALL ON Regions TO public

/* Users table */
CREATE TABLE Users (
   id            SERIAL NOT NULL,
   firstname     VARCHAR(20),
   lastname      VARCHAR(20),
   nickname      VARCHAR(20) NOT NULL, -- nicknames are unique(!)
   password      VARCHAR(20) NOT NULL,
   email         VARCHAR(50) NOT NULL,
   rating        INTEGER,
   balance       FLOAT,
   creation_date TIMESTAMP,
   region        INTEGER NOT NULL
)
GRANT ALL ON Users TO public

/* Items table */
CREATE TABLE Items (
   id            SERIAL NOT NULL,
   name          VARCHAR(100),
   description   TEXT,
   initial_price FLOAT   NOT NULL,
   quantity      INTEGER NOT NULL,
   reserve_price FLOAT   DEFAULT 0,
   buy_now       FLOAT   DEFAULT 0,
   nb_of_bids    INTEGER DEFAULT 0,
   max_bid       FLOAT   DEFAULT 0,
   start_date    TIMESTAMP,
   end_date      TIMESTAMP,
   seller        INTEGER NOT NULL,
   category      INTEGER NOT NULL
)
GRANT ALL ON Items TO public

/* Bids table */
CREATE TABLE Bids (
   id      SERIAL  NOT NULL,
   user_id INTEGER NOT NULL,
   item_id INTEGER NOT NULL,
   qty     INTEGER NOT NULL,
   bid     FLOAT   NOT NULL,
   max_bid FLOAT   NOT NULL,
   date    TIMESTAMP
)
GRANT ALL ON Bids TO public

/* Comments table */
CREATE TABLE Comments (
   id           SERIAL  NOT NULL,
   from_user_id INTEGER NOT NULL,
   to_user_id   INTEGER NOT NULL,
   item_id      INTEGER NOT NULL,
   rating       INTEGER,
   date         TIMESTAMP,
   comment      TEXT
)
GRANT ALL ON Comments TO public

/* Buy_Now table */	
CREATE TABLE Buy_Now (
   id       SERIAL  NOT NULL,
   buyer_id INTEGER NOT NULL,
   item_id  INTEGER NOT NULL,
   qty      INTEGER NOT NULL,
   date     TIMESTAMP
)
GRANT ALL ON Buy_Now TO public;

COMMIT;


/* IMPORTANT - 'abcd1234' MUST BE CHANGED To YOUR PostgreSQL user name! */ 
ALTER USER kngu2907 SET search_path TO INFO3404_AuctionDB,"$user",public;

/* run this MANUALLY after creating table data! */
-- VACUUM ANALYZE;




