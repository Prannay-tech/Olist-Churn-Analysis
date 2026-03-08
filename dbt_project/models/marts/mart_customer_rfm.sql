with base as (select * from {{ ref('int_customer_orders') }}),
rfm as (
    select *,
        datediff('day', last_order_date, '2018-09-03') as recency_days,
        total_orders as frequency,
        total_spend as monetary
    from base
),
scored as (
    select *,
        ntile(5) over (order by recency_days desc) as recency_score,
        ntile(5) over (order by frequency asc) as frequency_score,
        ntile(5) over (order by monetary asc) as monetary_score
    from rfm
)
select *,
    case
        when recency_score >= 4 and frequency_score >= 4 then 'Champions'
        when recency_score >= 3 and frequency_score >= 3 then 'Loyal Customers'
        when recency_score >= 4 and frequency_score < 2 then 'New Customers'
        when recency_score >= 3 and frequency_score < 3 then 'Potential Loyalists'
        when recency_score < 2 and frequency_score >= 3 then 'At Risk'
        when recency_score < 2 and frequency_score < 2 then 'Lost'
        else 'Need Attention'
    end as rfm_segment
from scored
