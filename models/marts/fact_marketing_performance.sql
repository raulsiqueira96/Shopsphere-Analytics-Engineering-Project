-- This model will be used to calculate marketing metricks such as ROI and CAC. It will be based on the int_marketing_daily table, which contains daily marketing performance data.

with revenue as (
    select
        order_date as date,
        c.source_channel as channel,
        sum(o.revenue) as revenue,
        sum(o.profit) as profit,
        count(distinct o.order_id) as orders,
        count(distinct o.customer_id) as purchasing_customers
    from {{ ref('fact_orders') }} o
    inner join {{ ref('dim_customers') }} c
        on o.customer_id = c.customer_id
    group by 1,2
),

spend as (
    select
        date,
        channel,
        sum(total_spend) as spend
    from {{ ref('fact_marketing_spend') }}
    group by 1,2
)

select
    coalesce(r.date,s.date) as date,
    coalesce(r.channel,s.channel) as channel,
    coalesce(spend,0) as spend,
    coalesce(revenue,0) as revenue,
    coalesce(profit,0) as profit,
    coalesce(orders,0) as orders,
    coalesce(purchasing_customers,0) as purchasing_customers
from revenue r

full outer join spend s
    on r.date = s.date
    and r.channel = s.channel