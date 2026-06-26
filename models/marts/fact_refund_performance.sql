# This model calculates the refund performance metrics by date, including the number of orders, refunds, total refunded amount, and total revenue.
select
    o.order_date as date,
    count(distinct o.order_id) as orders,
    count(distinct r.refund_id) as refunds,
    sum(r.refund_amount) as refunded_amount,
    sum(o.revenue) as revenue
from {{ ref('fact_orders') }} o

left join {{ ref('fact_refunds') }} r
    on o.order_id = r.order_id
group by 1