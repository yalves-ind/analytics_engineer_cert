with addresses as (
    select * from {{ ref('stg_person__address') }}
),

states as (
    select * from {{ ref('stg_person__stateprovince') }}
),

countries as (
    select * from {{ ref('stg_person__countryregion') }}
)

select
    a.address_id,
    a.address_line_1,
    a.address_line_2,
    a.city,
    a.postal_code,
    s.state_name,
    s.state_province_code,
    cr.country_name
from addresses a
left join states s
    on a.state_province_id = s.state_province_id
left join countries cr
    on s.country_region_code = cr.country_region_code
