{{ config(materialized='table') }}

with trips_data as (
    select * from {{ ref('fact_trips') }}
),
filtered_trips_data as (
    select 
    extract(year from pickup_datetime) as the_year,
    extract(month from pickup_datetime) as the_month,
    service_type,
    fare_amount
    from trips_data
    where fare_amount > 0
        and trip_distance > 0
        and payment_type_description in ('Cash', 'Credit Card')
),
trip_fare_percentile as (
    select 
    the_year,
    the_month,
    service_type,
    fare_amount,
    PERCENTILE_CONT(fare_amount, 0.9) over(partition by service_type, the_year, the_month) as percentile_90,
    PERCENTILE_CONT(fare_amount, 0.95) over(partition by service_type, the_year, the_month) as percentile_95,
    PERCENTILE_CONT(fare_amount, 0.97) over(partition by service_type, the_year, the_month) as percentile_97
    from filtered_trips_data
    where the_year = 2020 and the_month = 4
)
    select service_type, max(percentile_90) as p90, max(percentile_95) as p95, max(percentile_97) as p97
    from trip_fare_percentile
    group by service_type
