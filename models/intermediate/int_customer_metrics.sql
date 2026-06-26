-- This model calculates various customer metrics by combining data from orders, sessions, and support tickets.

with orders as ( -- Calculate order-related metrics for each customer
    select
        customer_id,
        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(distinct order_id) as number_of_orders,
        sum(revenue) as lifetime_revenue,
        sum(profit) as lifetime_profit
    from {{ ref('int_order_profit') }}
    group by 1
),
sessions as ( -- Calculate session-related metrics for each customer
    select
        customer_id,
        count(*) as total_sessions,
        sum(converted) as converted_sessions
    from {{ ref('stg_sessions') }}
    group by 1
),
tickets as ( -- Calculate support ticket-related metrics for each customer
    select
        customer_id,
        count(*) as support_tickets
    from {{ ref('stg_support_tickets') }}
    group by 1
)
-- Combine the metrics from orders, sessions, and tickets using full outer joins to ensure all customers are included
select
    coalesce(
        o.customer_id,
        s.customer_id,
        t.customer_id
    ) as customer_id, -- Use COALESCE to get the customer_id from any of the tables, ensuring we include all customers
    first_order_date,
    most_recent_order_date,
    number_of_orders,
    lifetime_revenue,
    lifetime_profit,
    total_sessions,
    converted_sessions,
    support_tickets
from orders o

full outer join sessions s
    on o.customer_id = s.customer_id -- Join orders and sessions on customer_id to combine order and session metrics

full outer join tickets t
    on coalesce(o.customer_id,s.customer_id) = t.customer_id -- Join the result with tickets on customer_id to include support ticket metrics, using COALESCE to handle cases where customer_id may come from either orders or sessions