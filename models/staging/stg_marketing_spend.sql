select
    date,
    channel,
    spend
from {{ source('raw_shopsphere','marketing_spend') }}