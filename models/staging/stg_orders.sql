with source as (

select *

from (

    select *,
    -- window function to identify and remove duplicated order_id values
    row_number() over(
        partition by order_id
        order by order_date desc
    ) as rn

    from {{ source('raw_shopsphere','orders') }}

)

where rn = 1 -- selecting only the first order_id based on the window function

)

select
    order_id,
    customer_id,
    product_id,
    order_date,
    quantity,
    unit_price
from source
where quantity > 0 -- deleting rows where we have order but they are either negative or 0