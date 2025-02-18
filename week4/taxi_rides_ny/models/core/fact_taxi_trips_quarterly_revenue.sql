{{ config(materialized='table') }}

with trips_data as (
    select * from {{ ref('fact_trips') }}
)
    select 
    -- Revenue grouping 
    {{ dbt.date_trunc("quarter", "pickup_datetime") }} as revenue_quarter, 
    service_type, 

    -- Revenue calculation 
    sum(total_amount) as revenue_quarterly_total_amount,
    from trips_data
    group by revenue_month, service_type