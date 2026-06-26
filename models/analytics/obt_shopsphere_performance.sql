with orders as (
    select
        o.order_date as date,
        c.country,
        c.source_channel as channel,
        count(distinct o.order_id) as orders,
        count(distinct o.customer_id) as purchasing_customers,
        sum(o.revenue) as revenue,
        sum(o.cost) as cost,
        sum(o.profit) as profit
    from {{ ref('fact_orders') }} o

    left join {{ ref('dim_customers') }} c
        on o.customer_id = c.customer_id
    group by 1,2,3
),

marketing as (
    select
        date,
        channel,
        sum(spend) as spend
    from {{ ref('fact_marketing_performance') }}
    group by 1,2

),

acquisition as (
    select
        date,
        channel,
        sum(new_customers) as new_customers
    from {{ ref('fact_customer_acquisition') }}
    group by 1,2

),

sessions as (
    select
        s.session_date as date,
        c.country,
        c.source_channel as channel,
        count(*) as sessions,
        sum(converted) as converted_sessions
    from {{ ref('fact_sessions') }} s
    left join {{ ref('dim_customers') }} c
        on s.customer_id = c.customer_id
    group by 1,2,3

),

refunds as (

    select
        o.order_date as date,
        c.country,
        c.source_channel as channel,
        count(distinct r.refund_id) as refunds,
        sum(r.refund_amount) as refunded_amount
    from {{ ref('fact_refunds') }} r

    left join {{ ref('fact_orders') }} o
        on r.order_id = o.order_id

    left join {{ ref('dim_customers') }} c
        on o.customer_id = c.customer_id
    group by 1,2,3

),

final as (

select
    coalesce(
        o.date,
        s.date,
        m.date,
        a.date,
        r.date
    ) as date,
    coalesce(
        o.country,
        s.country,
        r.country
    ) as country,
    coalesce(
        o.channel,
        s.channel,
        m.channel,
        a.channel,
        r.channel
    ) as channel,
    coalesce(revenue,0) as revenue,
    coalesce(cost,0) as cost,
    coalesce(profit,0) as profit,
    coalesce(orders,0) as orders,
    coalesce(purchasing_customers,0) as purchasing_customers,
    coalesce(spend,0) as spend,
    coalesce(new_customers,0) as new_customers,
    coalesce(sessions,0) as sessions,
    coalesce(converted_sessions,0) as converted_sessions,
    coalesce(refunds,0) as refunds,
    coalesce(refunded_amount,0) as refunded_amount
from orders o

full outer join sessions s
    on o.date = s.date
    and o.country = s.country
    and o.channel = s.channel

full outer join marketing m
    on coalesce(o.date,s.date) = m.date
    and coalesce(o.channel,s.channel) = m.channel

full outer join acquisition a
    on coalesce(o.date,s.date,m.date) = a.date
    and coalesce(o.channel,s.channel,m.channel) = a.channel

full outer join refunds r
    on coalesce(o.date,s.date,m.date,a.date) = r.date
    and coalesce(o.channel,s.channel,m.channel,a.channel) = r.channel
)

select 
    *,
    EXTRACT(YEAR FROM date) AS year,
    EXTRACT(MONTH FROM date) AS month_num,
    FORMAT_DATE('%b', date) AS month_name,
    FORMAT_DATE('%Y-%m', date) AS year_month
from final
where date >= "2024-01-01"