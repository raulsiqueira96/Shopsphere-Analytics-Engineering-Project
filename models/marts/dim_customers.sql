with customer_metrics as (
    select *
    from {{ ref('int_customer_metrics') }}
)

select
    c.customer_id,
    c.customer_name,
    c.email,
    c.country,
    c.signup_date,
    c.source_channel,
    m.first_order_date,
    m.most_recent_order_date,
    coalesce(m.number_of_orders,0) as number_of_orders,
    coalesce(m.lifetime_revenue,0) as lifetime_revenue,
    coalesce(m.lifetime_profit,0) as lifetime_profit,
    coalesce(m.total_sessions,0) as total_sessions,
    coalesce(m.converted_sessions,0) as converted_sessions,
    coalesce(m.support_tickets,0) as support_tickets,
    date_diff(
        coalesce(m.most_recent_order_date,current_date()),
        c.signup_date,
        day
    ) as customer_age_days,
    case
        when m.most_recent_order_date >= date_sub(current_date(), interval 90 day)
            then 'Active'
        else 'Churned'
    end as customer_status,
    
from {{ ref('stg_customers') }} c

left join customer_metrics m
    on c.customer_id = m.customer_id