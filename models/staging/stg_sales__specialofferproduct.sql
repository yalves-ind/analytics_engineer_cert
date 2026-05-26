with source as (
    select * from {{ source('adventure_works', 'sales_specialofferproduct') }}
)

select
    specialofferid as special_offer_id,
    productid as product_id,
    modifieddate as modified_date
from source
