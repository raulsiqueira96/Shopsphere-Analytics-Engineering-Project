select
    product_id,
    product_name,
    category,
    cast(unit_price as numeric) as unit_price,
    cast(unit_cost as numeric) as unit_cost
from {{source ('raw_shopsphere','products')}}