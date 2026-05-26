with source as (
    select * from {{ source('adventure_works', 'person_person') }}
)

select
    businessentityid as business_entity_id,
    persontype as person_type,
    namestyle as name_style,
    title,
    firstname as first_name,
    middlename as middle_name,
    lastname as last_name,
    suffix,
    emailpromotion as email_promotion,
    modifieddate as modified_date
from source
