{{ config(severity='warn') }}

-- Vérifie que le ZIP code correspond à la plage du state.
-- Les states militaires (AP, AE, AA) et les states absents du seed
-- sont exclus pour ne pas fausser le test.
select
    u.user_id,
    u.state,
    u.zip_code,
    r.zip_min,
    r.zip_max
from {{ ref('stg_users') }} u
left join {{ ref('state_zip_ranges') }} r
    on u.state = r.state
where r.state is not null
  and (
        cast(u.zip_code as integer) < r.zip_min
     or cast(u.zip_code as integer) > r.zip_max
  )
