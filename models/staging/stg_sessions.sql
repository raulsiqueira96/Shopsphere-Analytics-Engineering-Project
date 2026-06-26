select
    session_id,
    customer_id,
    session_date,
    lower(device) as device,
    converted
from {{ source('raw_shopsphere','sessions') }}