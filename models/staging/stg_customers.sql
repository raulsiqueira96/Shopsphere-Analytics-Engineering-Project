with source as (
    select * from {{ source('raw_shopsphere','customers')}}
),

-- Removing duplicated customers, considering the first record created
rem_dup as (
select *
from (
    select 
    *,
    row_number() over(partition by customer_id order by signup_date asc) rn 

    from source
)
where rn = 1  
)

select 
    customer_id,
    trim(customer_name) as customer_name,
    lower(email) as email,
    case
        when country = 'Brzil' then 'Brazil'
        when country = 'USAA' then 'USA'
        else country
    end as country,
    signup_date,
    source_channel
from rem_dup