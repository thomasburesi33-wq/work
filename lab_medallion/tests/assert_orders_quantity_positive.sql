-- La quantité doit être strictement positive
select
    order_id,
    quantity
from {{ ref('stg_orders') }}
where quantity <= 0
