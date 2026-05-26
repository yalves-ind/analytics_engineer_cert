with credit_cards as (
    select * from {{ ref('stg_sales__creditcard') }}
)

select
    credit_card_id,
    card_type
from credit_cards
