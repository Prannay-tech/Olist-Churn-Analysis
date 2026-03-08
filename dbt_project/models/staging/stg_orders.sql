with source as (select * from {{ source('raw', 'orders') }})
select
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp::date as order_purchase_date,
    order_purchase_timestamp,
    order_delivered_customer_date,
    order_estimated_delivery_date,
    datediff('day', order_purchase_timestamp, order_delivered_customer_date) as delivery_days,
    datediff('day', order_estimated_delivery_date, order_delivered_customer_date) as delivery_delay_days,
    case when order_delivered_customer_date <= order_estimated_delivery_date then 1 else 0 end as delivered_on_time
from source
where order_status not in ('unavailable', 'canceled')
