select
    ticket_id,
    customer_id,
    opened_date,
    category,
    status,
    priority,
    cast(resolution_days as int) as resolution_days
from {{ source('raw_shopsphere','support_tickets') }}