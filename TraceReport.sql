/*
 * TraceReport.sql script for DB Tuning assignment of INFO3404 sem2  (AuctionDB scenario)
 * Authors: Bryn Jeffries (core code) and Uwe Roehm (queries)
 *
 * Note: This is a trace of a potential execution of all parts of the AuctionDB application.
 * This means that the workload is 'linearised' in here: there are no condition statements
 * or loops anymore, but just a sequential list of SQL queries with specific values as 
 * submitted by the application to PostgreSQL during one example execution.
 * For the transaction logic and indications where the variables normally are, please see
 * the 'AuctionDB Schema and Workload.pdf' document.
 *
 * Usage:
 *   <install the two given stored procedures; then:>
 *   SELECT * FROM tracereport();
 *   SELECT SUM(maxcost) AS TotalCosts FROM tracereport();
 */
CREATE OR REPLACE FUNCTION info3404_auctiondb.estimate_cost(IN query text, 
OUT startup numeric,
OUT totalcost numeric, 
OUT planrows numeric, 
OUT planwidth numeric)
AS
$BODY$
DECLARE
    query_explain  text;
    explanation       xml;
    nsarray text[][];
BEGIN
nsarray := ARRAY[ARRAY['x', 'http://www.postgresql.org/2009/explain']];
query_explain :=e'EXPLAIN(FORMAT XML) ' || query;
EXECUTE query_explain INTO explanation;
startup := (xpath('/x:explain/x:Query/x:Plan/x:Startup-Cost/text()', explanation, nsarray))[1];
totalcost := (xpath('/x:explain/x:Query/x:Plan/x:Total-Cost/text()', explanation, nsarray))[1];
planrows := (xpath('/x:explain/x:Query/x:Plan/x:Plan-Rows/text()', explanation, nsarray))[1];
planwidth := (xpath('/x:explain/x:Query/x:Plan/x:Plan-Width/text()', explanation, nsarray))[1];
RETURN;
END;
$BODY$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION info3404_auctiondb.tracereport(OUT query text, OUT maxcost numeric)
  RETURNS setof record AS
$BODY$
DECLARE
queries text[][] DEFAULT ARRAY
   [
/* T0 - Authenticate User */
    ['T0a', e'SELECT id  FROM Users WHERE nickname=\'user54321\' AND password=\'password54321\''],
/* T1 - Browse Regions */
    ['T1a', e'SELECT * FROM Regions'],
/* T2 - Browse Categories */
    ['T2a', e'SELECT * FROM Categories'],
/* T3 - Search Items By Category */
    ['T3a', e'SELECT id, name, initial_price, max_bid, nb_of_bids, end_date FROM Items WHERE category=7 AND end_date>=NOW() LIMIT 25 OFFSET 0'],
/* T4 - Search Items By Region */
    ['T4a', e'SELECT I.id, I.name, initial_price, max_bid, nb_of_bids, end_date FROM Items I, Users U WHERE category=14 AND seller=U.id AND U.region=6 AND end_date>=NOW() LIMIT 25 OFFSET 0'],
/* T5 - Search Items By Name */
    ['T5a', e'SELECT id, name, initial_price, max_bid, nb_of_bids, end_date FROM Items WHERE category=4 AND name LIKE \'RUBiS%\' AND end_date>=NOW() LIMIT 25 OFFSET 50'],
/* T6 - View User Info */
    ['T6a', e'SELECT * FROM Users WHERE id=3271'],
    ['T6b', e'SELECT * FROM Comments WHERE to_user_id=3271'],
    ['T6c', e'SELECT nickname FROM Users WHERE id=2535'],
    ['T6d', e'SELECT nickname FROM Users WHERE id=88816'],
    ['T6e', e'SELECT nickname FROM Users WHERE id=72992'],
    ['T6f', e'SELECT nickname FROM Users WHERE id=69238'],
    ['T6g', e'SELECT nickname FROM Users WHERE id=55991'],
/* T7 - View Item */
    ['T7a', e'SELECT * FROM Items WHERE id=32768'],
    ['T7b', e'SELECT MAX(bid) FROM Bids WHERE item_id=32768'],
    ['T7c', e'SELECT bid,qty  FROM Bids WHERE item_id=32768 ORDER BY bid DESC LIMIT 8'],
    ['T7d', e'SELECT COUNT(*) FROM Bids WHERE item_id=32768'],
    ['T7e', e'SELECT nickname FROM Users WHERE id=73955'],
/* T8 - View Bid History */
    ['T8a', e'SELECT name FROM Items WHERE id=4068'],
    ['T8b', e'SELECT * FROM Bids WHERE item_id=4068 ORDER BY date DESC'],
    ['T8c', e'SELECT nickname FROM Users WHERE id=16884'],
    ['T8d', e'SELECT nickname FROM Users WHERE id=63014'],
    ['T8e', e'SELECT nickname FROM Users WHERE id=83945'],
    ['T8f', e'SELECT nickname FROM Users WHERE id=43910'],
    ['T8g', e'SELECT nickname FROM Users WHERE id=81863'],
    ['T8h', e'SELECT nickname FROM Users WHERE id=92512'],
    ['T8i', e'SELECT nickname FROM Users WHERE id=59759'],
    ['T8j', e'SELECT nickname FROM Users WHERE id=46794'],
    ['T8k', e'SELECT nickname FROM Users WHERE id=67244'],
    ['T8l', e'SELECT nickname FROM Users WHERE id=99560'],
/* T9 - Register User */
    ['T9a', e'SELECT * FROM Regions WHERE name=\'NY--New York\''],
    ['T9b', e'SELECT * FROM Users WHERE nickname=\'john123\''],
    ['T9c', e'INSERT INTO Users(firstname, lastname, nickname, password, email, rating, balance, creation_date, region) VALUES (\'John\', \'Lennon\', \'john123\', \'password123\', \'john@apple.uk\', 0, 0, NOW(), 40)'],
    ['T9d', e'SELECT * FROM Users WHERE nickname=\'john123\''],
/* T10 - Sell Item */
    ['T10a', e'INSERT INTO Items(name, description, initial_price, quantity, reserve_price, buy_now, nb_of_bids, max_bid, start_date, end_date, seller, category) VALUES (\'Test\', \'No description\', 1, 4, 2, 3, 0, 0, \'2012-09-17 09:40:39\', \'2012-09-22 09:40:39\', 2, 12)'],
/* T11 - Buy Now */
    ['T11a', e'SELECT id FROM Users WHERE nickname=\'user99999\' AND password=\'password99999\''],
    ['T11b', e'SELECT * FROM Items WHERE id=30084 AND buy_now>0'],
    ['T11c', e'SELECT nickname FROM Users WHERE id=766'],
    ['T11d', e'SELECT COUNT(id) FROM Bids WHERE item_id=30084'],
    ['T11e', e'SELECT quantity FROM Items WHERE id=30084'],
    ['T11f', e'UPDATE Items SET quantity=4 WHERE id=30084'],
    ['T11g', e'INSERT INTO Buy_Now(buyer_id,item_id,qty,date) VALUES (99999, 30084, 1, NOW())'],
/* T12 - Put Bid */
    ['T12a', e'SELECT id  FROM Users WHERE nickname=\'user4711\' AND password=\'password4711\''],
    ['T12b', e'SELECT * FROM Items WHERE items.id=99'],
    ['T12c', e'SELECT MAX(bid) AS bid FROM Bids WHERE item_id=99'],
    ['T12d', e'SELECT bid,qty FROM Bids WHERE item_id=99 ORDER BY bid DESC LIMIT 1'],
    ['T12e', e'SELECT COUNT(*) AS bid FROM Bids WHERE item_id=99'],
    ['T12f', e'SELECT nickname FROM Users WHERE id=35775'],
    ['T12g', e'SELECT max_bid FROM Items WHERE id=99'],
    ['T12h', e'UPDATE Items SET max_bid=3500 WHERE id=99'],
    ['T12i', e'INSERT INTO Bids(user_id, item_id, qty, bid, max_bid, date) VALUES (4711, 99, 1, 3500, 4000, NOW())'],
    ['T12j', e'UPDATE items SET nb_of_bids=nb_of_bids+1 WHERE id=99'],
/* T13 - Put Comment */
    ['T13a', e'SELECT id FROM Users WHERE nickname=\'user75000\' AND password=\'password75000\''],
    ['T13b', e'SELECT * FROM Items WHERE id=15612'],
    ['T13c', e'SELECT * FROM Users WHERE id=79266'],
    ['T13d', e'SELECT rating FROM Users WHERE id=79266'],
    ['T13e', e'UPDATE Users SET rating=rating+3 WHERE id=79266'],
    ['T13f', e'INSERT INTO Comments(from_user_id, to_user_id, item_id, rating, date, comment) VALUES (75000, 79266, 1, 0, \'2012-09-17 00:20:57\', \'nothing to be said\')'],
/* T14 - About Me */
    ['T14a', e'SELECT id FROM Users WHERE nickname=\'user290\' AND password=\'password290\''],
    ['T14b', e'SELECT * FROM Users WHERE id=290'],
    ['T14c', e'SELECT item_id, bids.max_bid FROM Bids, Items WHERE bids.user_id=290 AND bids.item_id=items.id AND items.end_date>=NOW() GROUP BY item_id,bids.max_bid'],
    ['T14d', e'SELECT * FROM Items WHERE id=45786'],
    ['T14e', e'SELECT nickname FROM Users WHERE id=90352'],
    ['T14f', e'SELECT * FROM Items WHERE id=38511'],
    ['T14g', e'SELECT nickname FROM Users WHERE id=48604'],
    ['T14h', e'SELECT * FROM Items WHERE id=19812'],
    ['T14i', e'SELECT nickname FROM Users WHERE id=83102'],
    ['T14j', e'SELECT * FROM Items WHERE id=25197'],
    ['T14k', e'SELECT nickname FROM Users WHERE id=91576'],
    ['T14l', e'SELECT * FROM Buy_Now WHERE buyer_id=290 AND (NOW() - buy_now.date)<=INTERVAL \'30 DAYS\''],
    ['T14m', e'SELECT * FROM Items WHERE id=32915'],
    ['T14n', e'SELECT nickname FROM Users WHERE id=8746'],
    ['T14o', e'SELECT * FROM Items WHERE seller=290 AND end_date>=NOW()'],
    ['T14p', e'SELECT * FROM Items WHERE seller=290 AND (NOW() - end_date) < INTERVAL \'30 DAYS\''],
    ['T14q', e'SELECT * FROM Comments WHERE to_user_id=29'],
    ['T14r', e'SELECT nickname FROM Users WHERE id=37576'],
/* T15 - Find Popular Items */
    ['T15a', e'SELECT I.id, I.name, I.end_date, COUNT(B.id) FROM Items I, Bids B WHERE I.id = B.item_id AND I.end_date > CURRENT_DATE GROUP BY I.id, I.name, I.end_date HAVING COUNT(B.id) > 15 ORDER BY 4 DESC, 3, 1 LIMIT 20'],
/* T16 - Find Popular Categories */
    ['T16a', e'SELECT C.name, COUNT(DISTINCT I.id) AS NumItems, COUNT(B.id) FROM Categories C, Items I, Bids B WHERE C.id = I.category AND I.id = B.item_id GROUP BY C.name ORDER BY 2 DESC, 3 DESC'],
/* T17 - Items that will finish soon */
    ['T17a', e'SELECT * FROM Items WHERE end_date <= (NOW() - INTERVAL \'1 hour\') ORDER BY end_date ASC'],
/* T18 - User Analysis 1: Top buyers in a given region */
    ['T18a', e'SELECT U.id, U.rating, COUNT(B.item_id) AS numBought, COUNT(C.id) AS numComments FROM Users U, Buy_Now B, Comments C WHERE U.id = B.buyer_id AND U.id = C.to_user_id AND U.region = 10 GROUP BY U.id, U.rating ORDER BY 2 DESC, 3 DESC, 4 DESC'],
    ['T18b', e'SELECT U.id, U.rating, COUNT(DISTINCT B.item_id) AS numBids, COUNT(C.id) AS numComments FROM Users U, Bids B, Items I, Comments C WHERE U.id = B.user_id AND U.id = C.to_user_id AND I.id = B.item_id AND I.end_date < NOW() AND U.region = 10 GROUP BY U.id, U.rating ORDER BY 2 DESC, 3 DESC, 4 DESC'],
/* T19 - User Analysis 2: Top-10 Sellers  */
    ['T19a', e'SELECT U.id, U.firstname, U.lastname, U.rating,  COUNT(DISTINCT I.id) AS SoldItems,  MAX(extract(day from (CURRENT_DATE - start_date))) AS DaysSince1stSell,  COUNT(DISTINCT N.item_id) AS NumBoughtNow,  COUNT(DISTINCT B.id)      AS NumBids,  COUNT(DISTINCT C.id)      AS NumComments FROM Users U LEFT OUTER JOIN Buy_Now N   ON (U.id=N.buyer_id) LEFT OUTER JOIN Bids B      ON (U.id = B.user_id) LEFT OUTER JOIN Items I     ON (U.id = I.seller) LEFT OUTER JOIN Comments C  ON (U.id = to_user_id) GROUP BY U.id, U.firstname, U.lastname, U.rating ORDER BY 5 DESC, 4 DESC, 7 DESC, 8 DESC, 9 DESC LIMIT 10']
	];
BEGIN
FOR i IN array_lower(queries,1) .. array_upper(queries,1) LOOP
	RETURN QUERY SELECT queries[i][1], totalcost FROM estimate_cost(queries[i][2]);
END LOOP;
RETURN;
END
$BODY$
LANGUAGE plpgsql;


