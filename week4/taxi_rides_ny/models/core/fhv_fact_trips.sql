{{ config(
    schema=resolve_schema_for('core'), 
) }}

with fhv_tripdata as (
    select *, 
        'fhv' as service_type
    from {{ ref('stg_fhv_tripdata') }}
), 
dim_zones as (
    select * from {{ ref('dim_zones') }}
    where borough != 'Unknown'
)
select 
    fhv_tripdata.trip_id as trip_id,
    fhv_tripdata.dispatching_base_num as dispatching_base_num,
    fhv_tripdata.pickup_datetime as pickup_datetime,
    fhv_tripdata.dropoff_datetime as dropoff_datetime,
    fhv_tripdata.PUlocationID as pickup_locationid, 
    pickup_zone.borough as pickup_borough, 
    pickup_zone.zone as pickup_zone, 
    fhv_tripdata.DOlocationID as dropoff_locationid,
    dropoff_zone.borough as dropoff_borough, 
    dropoff_zone.zone as dropoff_zone,  
    fhv_tripdata.SR_flag,
    fhv_tripdata.affiliated_base_number
from fhv_tripdata
inner join dim_zones pickup_zone
    on fhv_tripdata.PULocationID = pickup_zone.locationid
inner join dim_zones dropoff_zone
    on fhv_tripdata.DOLocationID = dropoff_zone.locationid