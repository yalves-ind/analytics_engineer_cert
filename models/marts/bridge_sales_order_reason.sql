with bridge as (
    select * from {{ ref('stg_sales__salesorderheadersalesreason') }}
),

reasons as (
    select * from {{ ref('stg_sales__salesreason') }}
)

select
    b.sales_order_id,
    b.sales_reason_id,
    r.sales_reason_name,
    r.reason_type
from bridge b
left join reasons r
    on b.sales_reason_id = r.sales_reason_id
