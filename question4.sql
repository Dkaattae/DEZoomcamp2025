with trip_age as (
select lpep_dropoff_datetime - lpep_pickup_datetime as trip_time,
	lpep_pickup_datetime,
	lpep_dropoff_datetime
from green_taxi_data
)

select max_trip_time, lpep_pickup_datetime, lpep_dropoff_datetime
from trip_age
inner join (
	select max(trip_time) as max_trip_time
	from trip_age
) max_trip_age
	on trip_age.trip_time = max_trip_age.max_trip_time
