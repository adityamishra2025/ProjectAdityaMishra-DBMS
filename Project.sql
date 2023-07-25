CREATE DATABASE project;
SHOW DATABASES;
USE project;

DROP TABLE IF EXISTS goldusers_signup;
CREATE TABLE goldusers_signup (
  userid INTEGER,
  gold_signup_date DATE
);

INSERT INTO goldusers_signup (userid, gold_signup_date) 
VALUES 
  (1, '2017-09-22'),
  (3, '2017-04-21');

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  userid INTEGER,
  signup_date DATE
);

INSERT INTO users (userid, signup_date) 
VALUES 
  (1, '2014-09-02'),
  (2, '2015-01-15'),
  (3, '2014-04-11');

DROP TABLE IF EXISTS sales;
CREATE TABLE sales (
  userid INTEGER,
  created_date DATE,
  product_id INTEGER
);

INSERT INTO sales (userid, created_date, product_id) 
VALUES 
  (1, '2017-04-19', 2),
  (3, '2019-12-18', 1),
  (2, '2020-07-20', 3),
  (1, '2019-10-23', 2),
  (1, '2018-03-19', 3),
  (3, '2016-12-20', 2),
  (1, '2016-11-09', 1),
  (1, '2016-05-20', 3),
  (2, '2017-09-24', 1),
  (1, '2017-03-11', 2),
  (1, '2016-03-11', 1),
  (3, '2016-11-10', 1),
  (3, '2017-12-07', 2),
  (3, '2016-12-15', 2),
  (2, '2017-11-08', 2),
  (2, '2018-09-10', 3);

DROP TABLE IF EXISTS product;
CREATE TABLE product (
  product_id INTEGER,
  product_name TEXT,
  price INTEGER
);

INSERT INTO product (product_id, product_name, price) 
VALUES 
  (1, 'p1', 980),
  (2, 'p2', 870),
  (3, 'p3', 330);

SELECT * FROM sales;
SELECT * FROM product;
SELECT * FROM goldusers_signup;
SELECT * FROM users;


-- Q1. What is total amount each customer spends on buying items?
select s.userid, sum(p.price)
from sales as s
inner join product as p
on s.product_id = p.product_id
group by s.userid;


-- Q2. How many days each customer visits the store?
select userid, count(distinct created_date) distinct_days 
from sales 
group by userid;


-- Q3. What was th 1st product purchased by each customer?
select * from
(select *, rank() over(partition by userid order by created_date) rnk from sales) a where rnk = 1;


-- Q4. What is most purchased item and how many times it was purchased by all customers?
select userid, count(product_id) from sales where product_id = 
(select product_id from sales
group by product_id order by count(product_id) desc )
group by userid;
-- select top 1 product_id from sales
-- group by product_id order by count(product_id) desc;    use limit instead


-- Q5. Which product was most popular to each customer?
select *from
(select * , rank() over (partition by userid order by cnt desc) rnk from
(select userid, product_id, count(product_id) cnt from sales
group by userid, product_id)a)b
where rnk = 1;


-- Q6. Which product was 1st bought by customer when they becom member/alter
select * from  
(select c.*, rank() over (partition by userid order by created_date) rnk from
(select a.userid, a.created_date, a.product_id, b.gold_signup_date
from sales as a
inner join goldusers_signup as b
on a.userid = b.userid
and created_date >= gold_signup_date) c)d
where rnk = 1;  


-- Q7. Which item was purchased just before customer become a member?
select * from  
(select c.*, rank() over (partition by userid order by created_date desc) rnk from
(select a.userid, a.created_date, a.product_id, b.gold_signup_date
from sales as a
inner join goldusers_signup as b
on a.userid = b.userid
and created_date <= gold_signup_date) c)d
where rnk = 1;  


-- Q8. What is the total arders and amount spent for each member before they became a member?

















