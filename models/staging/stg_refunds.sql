select
    refund_id,
    order_id,
    refund_date,
    refund_amount,
    refund_reason
from {{ source('raw_shopsphere','refunds') }}