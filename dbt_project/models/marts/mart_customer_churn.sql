with rfm as (select * from {{ ref('mart_customer_rfm') }})
select
    customer_unique_id, customer_city, customer_state,
    case when recency_days > 90 then 1 else 0 end as is_churned,
    case
        when recency_days <= 30 then 'Active'
        when recency_days <= 90 then 'At Risk'
        when recency_days <= 180 then 'Churned - Recent'
        else 'Churned - Long Ago'
    end as churn_status,
    recency_days, frequency, monetary,
    recency_score, frequency_score, monetary_score, rfm_segment,
    avg_order_value, avg_review_score, avg_delivery_days,
    customer_lifetime_days, negative_reviews, positive_reviews,
    first_order_date, last_order_date
from rfm
