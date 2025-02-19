select *
from {{ ref('fact_trips') }}
where pickup_datetime >= CURRENT_TIMESTAMP() - INTERVAL '{{ env_var("DAYS_BACK", "30") }}' DAY