{{ config(materialized='table') }}

with trips_data as (
    select * from {{ ref('fhv_fact_trips') }}
),
trips_data_prep as (
    select 
    timestamp_diff(dropoff_datetime, pickup_datetime, second) as trip_duration,
    pickup_locationid,
    dropoff_locationid,
    extract(year from pickup_datetime) as the_year,
    extract(month from pickup_datetime) as the_month
    from trips_data
)
    select 
    the_year,
    the_month,
    pickup_locationid,
    dropoff_locationid,
    PERCENTILE_CONT(trip_duration, 0.9) over(partition by the_year, the_month, pickup_locationid, dropoff_locationid) as percentile_90,
    from trips_data_prep