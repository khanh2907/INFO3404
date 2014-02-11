/* 
 *  INFO3404 DB Tuning Assignment, 2012 sem2
 *
 * the following is the workload_trace.sql script that contains examples
 * of all transactions run agains AuctionDB. 
 *
 * Note: This is a trace of a potential execution of all parts of the AuctionDB application.
 * This means that the there are no condition statements or loops anymore, but just a
 * sequential list of SQL queries with specific values as submitted by the application
 * to PostgreSQL during one example execution.
 * For the transaction logic and indications where the variables normally are, please see
 * the 'AuctionDB Schema and Workload.pdf' document.
 *
 * Execute this script in a shell using 'psql':
 * (replacing 'abcd1234' with your unikey)
 *    psql -h postgres.it.usyd.edu.au -U abcd1234 -d abcd1234 -f workload-trace.sql
 *
 * To get a summary of the execution costs, either use the provided 'TraceReport.sql'
 * stored procedure code, or the Unix shell scripts 'summary' and 'sum' (available in eLearning).
 *   psql -f workload-trace.sql >query_plans.txt
 *   ./summary <query_plans.txt  >query_costs.txt
 *   ./sum <query_costs.txt
 *
 */ 

/* T0 - Authenticate a User */
/*      (this is an example of the first sub-query of many other transactions) */
EXPLAIN VERBOSE
  SELECT id  FROM Users WHERE nickname='user54321' AND password='password54321';


/* T1 - Browse Regions */
BEGIN TRANSACTION;
   EXPLAIN VERBOSE
     SELECT * FROM Regions;
COMMIT;


/* T2 - Browse Categories */
BEGIN TRANSACTION;
   EXPLAIN VERBOSE
     SELECT * FROM Categories;   
COMMIT;


/* T3 - Search Items By Category */
BEGIN TRANSACTION;
   EXPLAIN VERBOSE
     SELECT id, name, initial_price, max_bid, nb_of_bids, end_date
       FROM Items
      WHERE category=7 AND end_date>=NOW() 
      LIMIT 25 OFFSET 0;
COMMIT;


/* T4 - Search Items By Region */
BEGIN TRANSACTION;
   EXPLAIN VERBOSE
     SELECT I.id, I.name, initial_price, max_bid, nb_of_bids, end_date
       FROM Items I, Users U 
      WHERE category=14 AND seller=U.id AND U.region=6 AND end_date>=NOW() 
      LIMIT 25 OFFSET 0;
COMMIT;


/* T5 - Search Items By Name */
BEGIN TRANSACTION;
   EXPLAIN VERBOSE
     SELECT id, name, initial_price, max_bid, nb_of_bids, end_date
       FROM Items 
      WHERE category=4 AND name LIKE 'RUBiS%' AND end_date>=NOW() 
      LIMIT 25 OFFSET 50;
COMMIT;


/* T6 - View User Info */
BEGIN TRANSACTION;
   EXPLAIN VERBOSE
     SELECT * FROM Users WHERE id=3271;
   EXPLAIN VERBOSE
     SELECT * FROM Comments WHERE to_user_id=3271;
      EXPLAIN VERBOSE
      SELECT nickname FROM Users WHERE id=2535;
      EXPLAIN VERBOSE
      SELECT nickname FROM Users WHERE id=88816;
      EXPLAIN VERBOSE
      SELECT nickname FROM Users WHERE id=72992;
      EXPLAIN VERBOSE
      SELECT nickname FROM Users WHERE id=69238;
      EXPLAIN VERBOSE
      SELECT nickname FROM Users WHERE id=55991;
COMMIT;


/* T7 - View Item */
BEGIN TRANSACTION;
   EXPLAIN VERBOSE
     SELECT * FROM Items WHERE id=32768;
   EXPLAIN VERBOSE
     SELECT MAX(bid) FROM Bids WHERE item_id=32768;
   EXPLAIN VERBOSE
     SELECT bid,qty  FROM Bids WHERE item_id=32768 ORDER BY bid DESC LIMIT 8;
   EXPLAIN VERBOSE
     SELECT COUNT(*) FROM Bids WHERE item_id=32768;
   EXPLAIN VERBOSE
      SELECT nickname FROM Users WHERE id=73955;
COMMIT;


/* T8 - View Bid History */
BEGIN TRANSACTION;
   EXPLAIN VERBOSE
      SELECT name FROM Items WHERE id=4068;
   EXPLAIN VERBOSE
      SELECT * FROM Bids WHERE item_id=4068 ORDER BY date DESC;
   EXPLAIN VERBOSE
      SELECT nickname FROM Users WHERE id=16884;
   EXPLAIN VERBOSE
      SELECT nickname FROM Users WHERE id=63014;
   EXPLAIN VERBOSE
      SELECT nickname FROM Users WHERE id=83945;
   EXPLAIN VERBOSE
      SELECT nickname FROM Users WHERE id=43910;
   EXPLAIN VERBOSE
      SELECT nickname FROM Users WHERE id=81863;
   EXPLAIN VERBOSE
      SELECT nickname FROM Users WHERE id=92512;
   EXPLAIN VERBOSE
      SELECT nickname FROM Users WHERE id=59759;
   EXPLAIN VERBOSE
      SELECT nickname FROM Users WHERE id=46794;
   EXPLAIN VERBOSE
      SELECT nickname FROM Users WHERE id=67244;
   EXPLAIN VERBOSE
      SELECT nickname FROM Users WHERE id=99560;
COMMIT;



/* T9 - Register User */
BEGIN TRANSACTION;
   EXPLAIN VERBOSE
      SELECT * FROM Regions WHERE name='NY--New York';
   EXPLAIN VERBOSE
      SELECT * FROM Users WHERE nickname='john123';
   EXPLAIN VERBOSE
      INSERT INTO Users(firstname, lastname, nickname, password, email, rating, balance, creation_date, region) 
             VALUES ('John', 'Lennon', 'john123', 'password123', 'john@apple.uk', 0, 0, NOW(), 40);
   EXPLAIN VERBOSE
      SELECT * FROM Users WHERE nickname='john123';
COMMIT;



/* T10 - Sell Item */
BEGIN TRANSACTION;
   EXPLAIN VERBOSE
   INSERT INTO Items(name, description, initial_price, quantity, reserve_price, buy_now, nb_of_bids, max_bid, start_date, end_date, seller, category) VALUES ('Test', 'No description', 1, 4, 2, 3, 0, 0, '2012-09-17 09:40:39', '2012-09-22 09:40:39', 2, 12);
COMMIT;


/* T11 - Buy Now */
/* consists of two parts: */
/*  (1) selects some data to present pre-filled input screen; */
/*  (2) after user input, updates corresponding item and enters new Buy Now entry */
BEGIN TRANSACTION;
   EXPLAIN VERBOSE
      SELECT id FROM Users WHERE nickname='user99999' AND password='password99999';
   EXPLAIN VERBOSE
      SELECT * FROM Items WHERE id=30084 AND buy_now>0;
   EXPLAIN VERBOSE
      SELECT nickname FROM Users WHERE id=766;
COMMIT;
/* get user input */
BEGIN TRANSACTION;
   EXPLAIN VERBOSE
      SELECT COUNT(id) FROM Bids WHERE item_id=30084;
   EXPLAIN VERBOSE
      SELECT quantity FROM Items WHERE id=30084;
   EXPLAIN VERBOSE
      UPDATE Items SET quantity=4 WHERE id=30084;
   EXPLAIN VERBOSE
      INSERT INTO Buy_Now(buyer_id,item_id,qty,date) VALUES (99999, 30084, 1, NOW());
COMMIT;


/* T12 - Put Bid */
/* consists of two parts: */
/*  (1) selects some data to present pre-filled input screen; */
/*  (2) after user input, updates corresponding item and enters new bid */
BEGIN TRANSACTION;
   EXPLAIN VERBOSE
      SELECT id  FROM Users WHERE nickname='user4711' AND password='password4711';
   EXPLAIN VERBOSE
      SELECT * FROM Items WHERE items.id=99;
   EXPLAIN VERBOSE
      SELECT MAX(bid) AS bid FROM Bids WHERE item_id=99;
   EXPLAIN VERBOSE
      SELECT bid,qty FROM Bids WHERE item_id=99 ORDER BY bid DESC LIMIT 1;
   EXPLAIN VERBOSE
      SELECT COUNT(*) AS bid FROM Bids WHERE item_id=99;
   EXPLAIN VERBOSE
      SELECT nickname FROM Users WHERE id=35775;
COMMIT;
/* show input form and get user input */
BEGIN TRANSACTION;
   EXPLAIN VERBOSE
      SELECT max_bid FROM Items WHERE id=99;
   EXPLAIN VERBOSE
      UPDATE Items SET max_bid=3500 WHERE id=99;
   EXPLAIN VERBOSE
      INSERT INTO Bids(user_id, item_id, qty, bid, max_bid, date) VALUES (4711, 99, 1, 3500, 4000, NOW());
   EXPLAIN VERBOSE
      UPDATE items SET nb_of_bids=nb_of_bids+1 WHERE id=99;
COMMIT;


/* T13 - Put Comment */
/* consists of two parts: */
/*  (1) selects some data to fill input screen; */
/*  (2) after user input, updates corresponding user and enters new comment */
EXPLAIN VERBOSE
   SELECT id FROM Users WHERE nickname='user75000' AND password='password75000';
BEGIN TRANSACTION;
   EXPLAIN VERBOSE
      SELECT * FROM Items WHERE id=15612;
   EXPLAIN VERBOSE
      SELECT * FROM Users WHERE id=79266;
COMMIT;
/* show input form and get user input */
BEGIN TRANSACTION;
   EXPLAIN VERBOSE
      SELECT rating FROM Users WHERE id=79266;
   EXPLAIN VERBOSE
      UPDATE Users SET rating=rating+3 WHERE id=79266;
   EXPLAIN VERBOSE
      INSERT INTO Comments(from_user_id, to_user_id, item_id, rating, date, comment) VALUES (75000, 79266, 1, 0, '2012-09-17 00:20:57', 'nothing to be said'); 
COMMIT;


/* T14 - About Me */
/* fills a screen with various information about currently logged-in user */
BEGIN TRANSACTION;
   EXPLAIN VERBOSE
      SELECT id FROM Users WHERE nickname='user290' AND password='password290';
   EXPLAIN VERBOSE
      SELECT * FROM Users WHERE id=290;
   EXPLAIN VERBOSE
      SELECT item_id, bids.max_bid FROM Bids, Items WHERE bids.user_id=290 AND bids.item_id=items.id AND items.end_date>=NOW() GROUP BY item_id,bids.max_bid;
      EXPLAIN VERBOSE
      SELECT * FROM Items WHERE id=45786;
      EXPLAIN VERBOSE
      SELECT nickname FROM Users WHERE id=90352;
      EXPLAIN VERBOSE
      SELECT * FROM Items WHERE id=38511;
      EXPLAIN VERBOSE
      SELECT nickname FROM Users WHERE id=48604;
      EXPLAIN VERBOSE
      SELECT * FROM Items WHERE id=19812;
      EXPLAIN VERBOSE
      SELECT nickname FROM Users WHERE id=83102;
      EXPLAIN VERBOSE
      SELECT * FROM Items WHERE id=25197;
      EXPLAIN VERBOSE
      SELECT nickname FROM Users WHERE id=91576;
   EXPLAIN VERBOSE
      SELECT * FROM Buy_Now WHERE buyer_id=290 AND (NOW() - buy_now.date)<=INTERVAL '30 DAYS';
      EXPLAIN VERBOSE
      SELECT * FROM Items WHERE id=32915;
      EXPLAIN VERBOSE
      SELECT nickname FROM Users WHERE id=8746;
   EXPLAIN VERBOSE
      SELECT * FROM Items WHERE seller=290 AND end_date>=NOW();
   EXPLAIN VERBOSE
      SELECT * FROM Items WHERE seller=290 AND (NOW() - end_date) < INTERVAL '30 DAYS';
   EXPLAIN VERBOSE
      SELECT * FROM Comments WHERE to_user_id=290;
      EXPLAIN VERBOSE
      SELECT nickname FROM Users WHERE id=37576;
COMMIT;


/* Analytical Queries */

/* T15 - Find Popular Items */
BEGIN TRANSACTION;
   EXPLAIN VERBOSE
     SELECT I.id, I.name, I.end_date, COUNT(B.id)
       FROM Items I, Bids B
      WHERE I.id = B.item_id
        AND I.end_date > CURRENT_DATE
      GROUP BY I.id, I.name, I.end_date
     HAVING COUNT(B.id) > 15
      ORDER BY 4 DESC, 3, 1
      LIMIT 20; 
COMMIT;

/* T16 - Find Popular Categories */
BEGIN TRANSACTION;
   EXPLAIN VERBOSE
     SELECT C.name, COUNT(DISTINCT I.id) AS NumItems, COUNT(B.id)
       FROM Categories C, Items I, Bids B
      WHERE C.id = I.category
        AND I.id = B.item_id
      GROUP BY C.name
     ORDER BY 2 DESC, 3 DESC;
COMMIT;


/* T17 - Items that will finish soon */
BEGIN TRANSACTION;
   EXPLAIN VERBOSE
     SELECT * FROM Items WHERE end_date <= (NOW() - INTERVAL '1 hour') ORDER BY end_date ASC;
COMMIT;


/* T18 - User Analysis 1: Top buyers in a given region */
BEGIN TRANSACTION;
  EXPLAIN VERBOSE
    SELECT U.id, U.rating, COUNT(B.item_id) AS numBought, COUNT(C.id) AS numComments
     FROM Users U, Buy_Now B, Comments C
    WHERE U.id = B.buyer_id
      AND U.id = C.to_user_id
      AND U.region = 10
    GROUP BY U.id, U.rating
    ORDER BY 2 DESC, 3 DESC, 4 DESC;

  EXPLAIN VERBOSE
   SELECT U.id, U.rating, COUNT(DISTINCT B.item_id) AS numBids, COUNT(C.id) AS numComments
     FROM Users U, Bids B, Items I, Comments C
    WHERE U.id = B.user_id
      AND U.id = C.to_user_id
      AND I.id = B.item_id
      AND I.end_date < NOW()
      AND U.region = 10
    GROUP BY U.id, U.rating
    ORDER BY 2 DESC, 3 DESC, 4 DESC;
COMMIT;


/* T19 - User Analysis 2: Top-10 Sellers  */
BEGIN TRANSACTION;
   EXPLAIN VERBOSE
 SELECT U.id, U.firstname, U.lastname, U.rating, 
          COUNT(DISTINCT I.id) AS SoldItems, 
          MAX(extract(day from (CURRENT_DATE - start_date))) AS DaysSince1stSell, 
          COUNT(DISTINCT N.item_id) AS NumBoughtNow, 
          COUNT(DISTINCT B.id)      AS NumBids, 
          COUNT(DISTINCT C.id)      AS NumComments 
    FROM Users U LEFT OUTER JOIN Buy_Now N   ON (U.id=N.buyer_id)
                 LEFT OUTER JOIN Bids B      ON (U.id = B.user_id)
                 LEFT OUTER JOIN Items I     ON (U.id = I.seller)
                 LEFT OUTER JOIN Comments C  ON (U.id = to_user_id)
    GROUP BY U.id, U.firstname, U.lastname, U.rating
    ORDER BY 5 DESC, 4 DESC, 7 DESC, 8 DESC, 9 DESC
    LIMIT 10;     

COMMIT;
