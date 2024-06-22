

/*
    If the customer not buy in one month, its become in churn!
    I need at leat one buy of the customer to next month to not become in churn
*/
create or replace table tasty_bytes.analytics.customer_churn as 
with filter_orders as (
    select distinct
        order_id,
        customer_id
    from tasty_bytes.raw_pos.order_header
    where customer_id is not null
      and order_ts < '2022-10-01'   -- last month before the last month of purchase in dataset
      and order_ts >= '2022-01-01'
),
flag_customer_buy AS (
    select 
        customer_id,
        MIN(order_ts) AS flag_ts
    from tasty_bytes.raw_pos.order_header
    where customer_id is not null
      and order_ts >= '2022-10-01' -- check if customer buy in the next month to flag churn
      and order_ts < '2022-11-01'
    group by 1
),
customer_history_features as (
    select 
        h.customer_id,
        sum(h.order_amount) as ltv,
        sum(h.order_amount) / count(h.order_id) as avg_ticket,
        count(distinct h.location_id) as quantity_unique_location,
        count(distinct h.truck_id) as quantity_unique_trucks
    from tasty_bytes.raw_pos.order_header h
    inner join filter_orders f on h.order_id = f.order_id and h.customer_id = f.customer_id
    group by 1
),
customer_detail_features as (
    select 
        f.customer_id,
        sum(d.quantity) as total_quantity_products,
        min(d.quantity) as min_quantity_products,
        max(d.quantity) as max_quantity_products,
        sum(d.unit_price) as total_unit_price,
        min(d.unit_price) as min_unit_price,
        max(d.unit_price) as max_unit_price
    from tasty_bytes.raw_pos.order_detail d
    inner join filter_orders f on d.order_id = f.order_id
    group by 1
)
select 
    c.customer_id,
    c.ltv,
    c.avg_ticket,
    c.quantity_unique_location,
    c.quantity_unique_trucks,
    d.total_quantity_products,
    d.min_quantity_products,
    d.max_quantity_products,
    d.total_unit_price,
    d.min_unit_price,
    d.max_unit_price,
    case when f.flag_ts is null then 1 else 0 end as churn
from customer_history_features c
left join customer_detail_features d on c.customer_id = d.customer_id
left join flag_customer_buy f on c.customer_id = f.customer_id
;

-- unbalance dataset
select 
    churn,
    count(*) as count_churn,
from tasty_bytes.analytics.customer_churn
group by 1;

select
    sum(case when churn = 1 then 1 else 0 end) / count(*) as pct_churn
from tasty_bytes.analytics.customer_churn;




