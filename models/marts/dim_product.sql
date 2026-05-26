with products as (
    select * from {{ ref('stg_production__product') }}
),

subcategories as (
    select * from {{ ref('stg_production__productsubcategory') }}
),

categories as (
    select * from {{ ref('stg_production__productcategory') }}
)

select
    p.product_id,
    p.product_name,
    p.product_number,
    p.color,
    p.product_line,
    p.product_class,
    p.product_style,
    p.size,
    p.list_price,
    p.standard_cost,
    p.sell_start_date,
    p.sell_end_date,
    sc.subcategory_name,
    c.category_name
from products p
left join subcategories sc
    on p.product_subcategory_id = sc.product_subcategory_id
left join categories c
    on sc.product_category_id = c.product_category_id
