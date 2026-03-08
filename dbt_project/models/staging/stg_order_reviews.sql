with source as (select * from {{ source('raw', 'order_reviews') }})
select
    review_id,
    order_id,
    review_score,
    case
        when review_score >= 4 then 'positive'
        when review_score = 3 then 'neutral'
        else 'negative'
    end as review_sentiment
from source
