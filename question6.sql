select "Zone", tip_amount
from green_taxi_data
inner join (
	select max(tip_amount) as max_tip
	from green_taxi_data
	where date_trunc('month', lpep_pickup_datetime)::date = '2019-10-01'::date
		and "PULocationID" in (select "LocationID" from zones where "Zone" like 'East Harlem North')
) max_tip_trip
	on green_taxi_data.tip_amount = max_tip_trip.max_tip
inner join zones
	on green_taxi_data."DOLocationID" = zones."LocationID"