with orders as (select * from {{ ref('stg_orders') }}),
items as (
    select order_id,
        count(order_item_id) as item_count,
        sum(price) as items_revenue,
        sum(freight_value) as freight_revenue,
        sum(total_item_value) as total_order_value
    from {{ ref('stg_order_items') }} group by order_id
),
payments as (
    select order_id,
        sum(payment_value) as total_payment,
        max(payment_installments) as max_installments
    from {{ ref('stg_order_payments') }} group by order_id
),
reviews as (select order_id, review_score, review_sentiment from {{ ref('stg_order_reviews') }})

select
    o.order_id, o.customer_id, o.order_purchase_date, o.order_status,
    o.delivery_days, o.delivery_delay_days, o.delivered_on_time,
    coalesce(i.item_count, 0) as item_count,
    coalesce(i.total_order_value, 0) as total_order_value,
    coalesce(p.total_payment, 0) as total_payment,
    p.max_installments,
    r.review_score, r.review_sentiment
from orders o
left join items i on o.order_id = i.order_id
left join payments p on o.order_id = p.order_id
left join reviews r on o.order_id = r.order_id
