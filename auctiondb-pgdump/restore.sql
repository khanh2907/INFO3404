create temporary table pgdump_restore_path(p text);
--
-- NOTE:
--
-- File paths need to be edited. Search for $$PATH$$ and
-- replace it with the path to the directory containing
-- the extracted data files.
--
-- Edit the following to match the path where the
-- tar archive has been extracted.
--
insert into pgdump_restore_path values('/tmp');

--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = info3404_auctiondb, pg_catalog;

SET search_path = info3404_auctiondb, pg_catalog;

--
-- Data for Name: bids; Type: TABLE DATA; Schema: info3404_auctiondb; Owner: info2120_test
--

COPY bids (id, user_id, item_id, qty, bid, max_bid, date) FROM stdin;
\.
copy bids (id, user_id, item_id, qty, bid, max_bid, date)  from '$$PATH$$/3220.dat' ;
--
-- Data for Name: buy_now; Type: TABLE DATA; Schema: info3404_auctiondb; Owner: info2120_test
--

COPY buy_now (id, buyer_id, item_id, qty, date) FROM stdin;
\.
copy buy_now (id, buyer_id, item_id, qty, date)  from '$$PATH$$/3222.dat' ;
--
-- Data for Name: categories; Type: TABLE DATA; Schema: info3404_auctiondb; Owner: info2120_test
--

COPY categories (id, name) FROM stdin;
\.
copy categories (id, name)  from '$$PATH$$/3216.dat' ;
--
-- Data for Name: comments; Type: TABLE DATA; Schema: info3404_auctiondb; Owner: info2120_test
--

COPY comments (id, from_user_id, to_user_id, item_id, rating, date, comment) FROM stdin;
\.
copy comments (id, from_user_id, to_user_id, item_id, rating, date, comment)  from '$$PATH$$/3221.dat' ;
--
-- Data for Name: items; Type: TABLE DATA; Schema: info3404_auctiondb; Owner: info2120_test
--

COPY items (id, name, description, initial_price, quantity, reserve_price, buy_now, nb_of_bids, max_bid, start_date, end_date, seller, category) FROM stdin;
\.
copy items (id, name, description, initial_price, quantity, reserve_price, buy_now, nb_of_bids, max_bid, start_date, end_date, seller, category)  from '$$PATH$$/3219.dat' ;
--
-- Data for Name: regions; Type: TABLE DATA; Schema: info3404_auctiondb; Owner: info2120_test
--

COPY regions (id, name) FROM stdin;
\.
copy regions (id, name)  from '$$PATH$$/3217.dat' ;
--
-- Data for Name: users; Type: TABLE DATA; Schema: info3404_auctiondb; Owner: info2120_test
--

COPY users (id, firstname, lastname, nickname, password, email, rating, balance, creation_date, region) FROM stdin;
\.
copy users (id, firstname, lastname, nickname, password, email, rating, balance, creation_date, region)  from '$$PATH$$/3218.dat' ;
--
-- PostgreSQL database dump complete
--

