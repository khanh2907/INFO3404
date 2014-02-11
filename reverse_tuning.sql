/*DROP PRIMARY KEYS TO ALL TABLES*/
ALTER TABLE bids DROP CONSTRAINT bids_pkey;
ALTER TABLE buy_now DROP CONSTRAINT buy_now_pkey;
ALTER TABLE categories DROP CONSTRAINT categories_pkey;
ALTER TABLE comments DROP CONSTRAINT comments_pkey;
ALTER TABLE items DROP CONSTRAINT items_pkey;
ALTER TABLE regions DROP CONSTRAINT regions_pkey;
ALTER TABLE users DROP CONSTRAINT users_pkey;

DROP INDEX users_nickname_index;
DROP INDEX items_category_index;
DROP INDEX items_end_date_index;
DROP INDEX comments_to_user_id_index;
DROP INDEX bids_item_id_index;
DROP INDEX items_seller_index;
DROP INDEX categories_name_index;