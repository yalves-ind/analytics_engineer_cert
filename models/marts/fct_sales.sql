with order_details as (
    select * from {{ ref('stg_sales__salesorderdetail') }}
),

order_headers as (
    select * from {{ ref('stg_sales__salesorderheader') }}
)

select
    od.sales_order_detail_id,
    od.sales_order_id,
    oh.order_date,
    cast(oh.order_date as date) as order_date_key,
    oh.due_date,
    oh.ship_date,
    oh.status,
    oh.online_order_flag,
    oh.customer_id,
    oh.salesperson_id,
    oh.territory_id,
    oh.ship_to_address_id as address_id,
    oh.credit_card_id,
    od.product_id,
    od.special_offer_id,
    od.order_qty,
    od.unit_price,
    od.unit_price_discount,
    od.unit_price * od.order_qty as gross_amount,
    od.unit_price * od.order_qty * (1 - od.unit_price_discount) as net_amount
from order_details od
left join order_headers oh
    on od.sales_order_id = oh.sales_order_id
