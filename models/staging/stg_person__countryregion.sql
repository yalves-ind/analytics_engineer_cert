with source as (
    select * from {{ source('adventure_works', 'person_countryregion') }}
)

select
    countryregioncode as country_region_code,
    name as country_name,
    modifieddate as modified_date
from source
