with source as (
    select * from {{ source('adventure_works', 'production_productcategory') }}
)

select
    productcategoryid as product_category_id,
    name as category_name,
    modifieddate as modified_date
from source
