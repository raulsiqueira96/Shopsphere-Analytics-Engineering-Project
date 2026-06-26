# this model will be used to calculate customer acquisition metrics such as CAC. It will be based on the int_marketing_daily table, which contains daily marketing performance data.

with customers as (
    select
        signup_date as date,
        source_channel as channel,
        count(*) as new_customers
    from {{ ref('dim_customers') }}
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
    coalesce(c.date,s.date) as date,
    coalesce(c.channel,s.channel) as channel,
    coalesce(spend,0) as spend,
    coalesce(new_customers,0) as new_customers
from customers c

full outer join spend s
    on c.date = s.date
    and c.channel = s.channel