create database if not exists WalmartDataBase;

create table if not exists Sales(
	invoice_id varchar(30) not null primary key,
    branch varchar(5) not null,
    city varchar(30) not null,
    customer_type varchar(30) not null,
    gender varchar(10) not null,
    product_line varchar(100) not null,
    unit_price decimal(10, 2) not null,
    quantity int not null,
    VAT float(6, 4) not null,
    total decimal(10, 2) not null,
    date datetime not null,
    time TIME not null,
    payment_method varchar(15) not null,
    cogs decimal(10, 2) not null,
    grass_margin_percentage float(11, 9),
    gross_income decimal(12, 4) not null,
    rating float(2, 1)
);



-- ------------------------------------------------------------------------------------------------------------------
-- -------------------- Feature Engineering ----------------------------------------------------

-- time_of_day

select
	time,
		(case
			when `time` between "00:00:00" and "12:00:00" then "Morning"
            when `time` between "12:01:00" and "16:00:00" then "Afternoon"
            else "Evening"
        end) as time_of_date
from sales; 

alter table sales add column  time_of_day varchar(20);

update sales
set time_of_day = (
	case
		when `time` between "00:00:00" and "12:00:00" then "Morning"
		when `time` between "12:01:00" and "16:00:00" then "Afternoon"
		else "Evening"
	end
);


-- day_name

select 
	date,
    dayname(date) as day_name
from sales;

alter table sales add column day_name varchar(10);

update sales
	set day_name = dayname(date);
    

-- month_name

select
	date,
		monthname(date) as month_name
from sales;

alter table sales add column month_name varchar(10);

update sales
	set month_name = monthname(date);

-- --------------------------------------------------------------------------------------------------

-- ---------------------------------- GENERIC Questions ---------------------------------------------

-- Q1. How many unique cities does the data have?
select 
	distinct city
from sales;

select 
	distinct branch
from sales;

-- Q2. In which city is each branch?

select
	distinct city, branch
from sales;

-- -------------------------------------------------------------------------------------------
-- ------------------------------- PRODUCT QUESTIONS -----------------------------------------

-- Q1. How many unique product lines does the data have?
select
	count(distinct product_line)
from sales;

-- Q2. What is the most common payment method?
select
	payment_method,
    count(payment_method) as frequency
from sales
group by payment_method
order by frequency desc;

-- Q3. What is the most selling product line?
select
	product_line,
	count(product_line) as count
from sales
group by product_line
order by count desc;

-- Q4. What is the total revenue by month?
select
	month_name,
    sum(total) as total_revenue
from sales
group by month_name
order by total_revenue desc;

-- Q5. What month had the largest COGS?
select
	month_name,
    sum(cogs) as total_cogs
from sales
group by month_name
order by total_cogs desc;

-- Q6. What product line had the largest revenue?
select
	product_line,
    sum(total) as revenue
from sales
group by product_line
order by revenue desc;

-- Q7. What is the city with the largest revenue?
select
	city,
    sum(total) as revenue
from sales
group by city
order by revenue desc;

-- Q8. What product line had the largest VAT?
select
	product_line,
    sum(VAT) as total_vat
from sales
group by product_line
order by total_vat desc;

-- Q9. Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
select
    avg(quantity) as avg_sale
from sales;

select
	product_line,
		case
			when avg(quantity) > 5.4995 then "good"
            else "Bad"
            end as Remarks
from sales
group by product_line;

-- Q10. Which branch sold more products than average product sold?
select
	branch,
    sum(quantity) as sold_qnty
from sales
group by branch
having sum(quantity) > (select avg(quantity) from sales);

-- Q11. What is the most common product line by gender?
select
	product_line,
    gender,
    count(gender) as count
from sales
group by product_line, gender
order by count desc;

-- Q12. What is the average rating of each product line?
select
	product_line,
    round(avg(rating), 2) as avg_rating
from sales
group by product_line
order by avg_rating desc;


-- ------------------------------------------------------------------------
-- --------------------------- SALES QUESTIONS ----------------------------

-- Q1. Number of sales made in each time of the day per weekday.
select
	time_of_day,
	count(time_of_day) as total_sales
from sales
where day_name = "Sunday"
group by time_of_day
order by total_sales desc;

-- Q2. Which of the customer types brings the most revenue?
select
	customer_type,
    sum(total) as revenue
from sales
group by customer_type
order by revenue desc;

-- Q3. Which city has the largest tax percent/ VAT (Value Added Tax)?
select
	city,
    avg(VAT) as avg_VAT
from sales
group by city
order by avg_VAT desc;

-- Q4. Which customer type pays the most in VAT?
select
	customer_type,
    avg(VAT) as VAT_pays 
from sales
group by customer_type
order by VAT_pays desc;


-- -----------------------------------------------------------------------
-- -------------------------- COSTOMER QUESTIONS -------------------------

-- Q1. How many unique customer types does the data have?
select
	count(distinct customer_type)
from sales;

-- Q2. How many unique payment methods does the data have?
select
	distinct payment_method
from sales;

-- Q3. What is the most common customer type?
select
	customer_type,
    count(customer_type) as most_common
from sales
group by customer_type
order by most_common desc;

-- Q4. Which customer type buys the most?
select
	customer_type,
    count(*)
from sales
group by customer_type;

-- Q5. What is the gender of most of the customers?
select
	gender,
    count(gender) as gen_cnt
from sales
group by gender
order by gen_cnt desc;

-- Q6. What is the gender distribution per branch?
select
	branch,
    count(gender)  as male
from sales
where gender = "Male"
group by branch;

select
	branch,
    count(gender)  as female
from sales
where gender = "Female"
group by branch;

-- Q7. Which time of the day do customers give most ratings?
select
	time_of_day,
    avg(rating) as most_rating
from sales
group by time_of_day
order by most_rating desc;

-- Q8. Which time of the day do customers give most ratings per branch?
select
	branch, time_of_day,
    avg(rating) as most_rating
from sales
group by branch, time_of_day
order by branch asc;

-- Q9. Which day of the week has the best avg ratings?
select
	day_name,
    avg(rating) as avg_rating
from sales
group by day_name
order by avg_rating desc;

-- Q10. Which day of the week has the best average ratings per branch?
select
	branch, day_name,
    avg(rating) as avg_rating
from sales
group by day_name, branch
order by avg_rating desc;