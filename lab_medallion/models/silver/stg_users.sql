with source as (
    select * from {{ source('bronze', 'users') }}
),

first_order as (
    select
        user_id,
        min(ordered_at) as first_order_at
    from {{ ref('stg_orders') }}
    group by user_id
),

typed as (
    select
        cast(u.uuid as uuid) as user_id,
        trim(u.username) as username,
        lower(trim(u.username)) as username_normalized,
        trim(u.name) as name,
        upper(trim(u.sex)) as sex,
        lower(trim(u.mail)) as email,
        cast(u.birthdate as date) as birthdate_raw,
        split_part(u.address, chr(10), 1) as street,
        split_part(u.address, chr(10), 2) as address_line_2,
        f.first_order_at
    from source u
    left join first_order f on cast(u.uuid as uuid) = f.user_id
)

select
    user_id,
    username,
    username_normalized,
    name,
    sex,
    email,
    case
        when first_order_at is null then birthdate_raw
        when birthdate_raw > cast(first_order_at as date) then null
        else birthdate_raw
    end as birthdate,
    case
        when first_order_at is null then true
        when birthdate_raw > cast(first_order_at as date) then false
        else true
    end as birthdate_is_valid,
    street,
    nullif(regexp_extract(address_line_2, '^(.+), [A-Z]{2} \d{5}$', 1), '') as city,
    regexp_extract(address_line_2, '([A-Z]{2}) (\d{5})$', 1) as state,
    regexp_extract(address_line_2, '([A-Z]{2}) (\d{5})$', 2) as zip_code
from typed
