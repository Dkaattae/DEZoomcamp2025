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
),
p90_trips as (
    select
    the_year,
    the_month,
    pickup_locationid,
    dropoff_locationid,
    any_value(percentile_90) as p90
    from (
    select 
    the_year,
    the_month,
    pickup_locationid,
    dropoff_locationid,
    PERCENTILE_CONT(trip_duration, 0.9) over(partition by the_year, the_month, pickup_locationid, dropoff_locationid) as percentile_90,
    from trips_data_prep
    where trip_duration > 0
    )
    group by the_year,the_month,pickup_locationid,dropoff_locationid
),
p90_trips_rank as (
  select 
    pickup_locationid,
    pickup_zone.zone as pickup_zone_name,
    p90,
    row_number() over(partition by pickup_locationid order by p90 desc) as p90_rank
  from p90_trips
  left outer join `trips_data_all`.`taxi_zone_lookup` pickup_zone
    on p90_trips.pickup_locationid = pickup_zone.locationid
  where pickup_zone.zone in ('Newark Airport', 'SoHo', 'Yorkville East')
    and the_year = 2019 and the_month = 11
)
  select p90_trips.*, p90_trips_rank.pickup_zone_name, dropoff_zone.zone as dropoff_zone_name
  from p90_trips
  inner join p90_trips_rank
    on p90_trips.pickup_locationid = p90_trips_rank.pickup_locationid
    and p90_trips.p90 = p90_trips_rank.p90
  left outer join `trips_data_all`.`taxi_zone_lookup` dropoff_zone
    on p90_trips.dropoff_locationid = dropoff_zone.locationid
  where p90_rank = 2
