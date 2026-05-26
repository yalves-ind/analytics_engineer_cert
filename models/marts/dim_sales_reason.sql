with sales_reasons as (
    select * from {{ ref('stg_sales__salesreason') }}
)

select
    sales_reason_id,
    sales_reason_name,
    reason_type
from sales_reasons
