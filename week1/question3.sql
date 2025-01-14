select 
	case
	when trip_distance is null then null
	when trip_distance <= 1 then 0
	when trip_distance <= 3 then 1
	when trip_distance <= 7 then 2
	when trip_distance <= 10 then 3
	when trip_distance > 10 then 4
	end as trip_distance_category,
	count(*) as trip_count
from green_taxi_data
where lpep_pickup_datetime::date >= '2019-10-01'::date
	and lpep_dropoff_datetime::date < '2019-11-01'::date
group by trip_distance_category
order by trip_distance_category
