with customers as (
    select * from {{ ref('stg_sales__customer') }}
),

persons as (
    select * from {{ ref('stg_person__person') }}
)

select
    c.customer_id,
    c.person_id,
    c.store_id,
    c.territory_id,
    p.first_name,
    p.middle_name,
    p.last_name,
    coalesce(p.first_name, '') || ' ' || coalesce(p.last_name, '') as full_name,
    p.person_type,
    p.email_promotion
from customers c
left join persons p
    on c.person_id = p.business_entity_id
