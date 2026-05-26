with source as (
    select * from {{ source('adventure_works', 'sales_salesorderheadersalesreason') }}
)

select
    salesorderid as sales_order_id,
    salesreasonid as sales_reason_id,
    modifieddate as modified_date
from source
