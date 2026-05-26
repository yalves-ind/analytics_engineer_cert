with source as (
    select * from {{ source('adventure_works', 'production_productsubcategory') }}
)

select
    productsubcategoryid as product_subcategory_id,
    productcategoryid as product_category_id,
    name as subcategory_name,
    modifieddate as modified_date
from source
