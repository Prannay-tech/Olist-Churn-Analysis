with source as (select * from {{ source('raw', 'products') }}),
categories as (select * from {{ source('raw', 'product_category_translation') }})
select
    p.product_id,
    coalesce(c.product_category_name_english, p.product_category_name, 'unknown') as product_category,
    p.product_weight_g
from source p
left join categories c on p.product_category_name = c.product_category_name
