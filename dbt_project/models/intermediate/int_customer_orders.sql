with orders as (select * from {{ ref('int_orders_enriched') }}),
customers as (select * from {{ ref('stg_customers') }}),
stats as (
    select
        customer_id,
        count(order_id) as total_orders,
        min(order_purchase_date) as first_order_date,
        max(order_purchase_date) as last_order_date,
        sum(total_order_value) as total_spend,
        avg(total_order_value) as avg_order_value,
        avg(review_score) as avg_review_score,
        avg(delivery_days) as avg_delivery_days,
        sum(case when delivered_on_time = 1 then 1 else 0 end) as on_time_deliveries,
        sum(case when review_sentiment = 'negative' then 1 else 0 end) as negative_reviews,
        sum(case when review_sentiment = 'positive' then 1 else 0 end) as positive_reviews
    from orders group by customer_id
)
select
    c.customer_unique_id, c.customer_city, c.customer_state,
    s.total_orders, s.first_order_date, s.last_order_date,
    s.total_spend, s.avg_order_value, s.avg_review_score,
    s.avg_delivery_days, s.on_time_deliveries, s.negative_reviews, s.positive_reviews,
    datediff('day', s.first_order_date, s.last_order_date) as customer_lifetime_days
from customers c
inner join stats s on c.customer_id = s.customer_id
