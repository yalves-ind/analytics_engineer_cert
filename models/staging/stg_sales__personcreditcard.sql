with source as (
    select * from {{ source('adventure_works', 'sales_personcreditcard') }}
)

select
    businessentityid as business_entity_id,
    creditcardid as credit_card_id,
    modifieddate as modified_date
from source
