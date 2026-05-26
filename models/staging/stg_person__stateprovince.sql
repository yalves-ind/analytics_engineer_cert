with source as (
    select * from {{ source('adventure_works', 'person_stateprovince') }}
)

select
    stateprovinceid as state_province_id,
    stateprovincecode as state_province_code,
    countryregioncode as country_region_code,
    isonlystateprovinceflag as is_only_state_province_flag,
    name as state_name,
    territoryid as territory_id,
    modifieddate as modified_date
from source
