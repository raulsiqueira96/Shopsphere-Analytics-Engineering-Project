select
    o.order_id,
    o.customer_id,
    o.product_id,
    o.order_date,
    o.quantity,
    o.unit_price,
    p.unit_cost,
    o.quantity * o.unit_price as revenue,
    o.quantity * p.unit_cost as cost,
    (o.quantity * o.unit_price) - (o.quantity * p.unit_cost) as profit
from {{ ref('stg_orders')}} o
left join {{ ref('stg_products') }} p
    on o.product_id = p.product_id