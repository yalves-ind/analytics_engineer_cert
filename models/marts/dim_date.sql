with order_dates as (
    select distinct
        cast(order_date as date) as date_key
    from {{ ref('stg_sales__salesorderheader') }}
)

select
    date_key,
    extract(year from date_key) as year,
    extract(month from date_key) as month,
    extract(day from date_key) as day,
    extract(quarter from date_key) as quarter,
    date_format(date_key, 'MMMM') as month_name,
    date_format(date_key, 'EEEE') as day_of_week,
    date_format(date_key, 'yyyy-MM') as year_month
from order_dates
