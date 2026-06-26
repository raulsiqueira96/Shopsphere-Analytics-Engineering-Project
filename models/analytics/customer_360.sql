select
    *,
    date_diff(
        most_recent_order_date,
        first_order_date,
        day
    ) as customer_lifetime_days,
    safe_divide(
        lifetime_revenue,
        greatest(number_of_orders,1)
    ) as average_order_value,
    safe_divide(
        converted_sessions,
        total_sessions
    ) as conversion_rate
from {{ ref('dim_customers') }}