select
    date,
    channel,
    sum(spend) as total_spend
from {{ ref('stg_marketing_spend') }}
group by 1,2