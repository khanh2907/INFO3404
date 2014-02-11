/* 	ORIGINAL:
		totalcosts = 897389.34
*/

/*ADD PRIMARY KEYS TO ALL TABLES
	AFTER:
		totalcosts = 682685.19
*/
ALTER TABLE bids ADD PRIMARY KEY (id);
ALTER TABLE buy_now ADD PRIMARY KEY (id);
ALTER TABLE categories ADD PRIMARY KEY (id);
ALTER TABLE comments ADD PRIMARY KEY (id);
ALTER TABLE items ADD PRIMARY KEY (id);
ALTER TABLE regions ADD PRIMARY KEY (id);
ALTER TABLE users ADD PRIMARY KEY (id);

/*ADD INDEX
	AFTER:
		totalcosts = 
*/
CREATE INDEX users_nickname_index ON Users(nickname); -- for T1

CREATE INDEX items_category_index ON Items(category); -- GOOD
CREATE INDEX items_end_date_index ON Items(end_date); -- GOOD
CREATE INDEX items_seller_index ON Items(seller);

CREATE INDEX comments_to_user_id_index ON Comments(to_user_id); -- GOOD

CREATE INDEX bids_item_id_index ON Bids(item_id); -- GOOD 
CREATE INDEX bids_user_id ON Bids(user_id);

CREATE INDEX users_rating_index ON Users(rating DESC);
i
CREATE INDEX categories_name_index ON Categories(name);

/*ADD FOREIGN  KEYS
	AFTER:
		totalcosts = s
*/
CREATE INDEX covering_index1 on users (id, firstname, lastname, rating desc)

create index items_cat_id_index on Items (category, id)

create index user_region_id_rating on Users (reigon, id, rating);