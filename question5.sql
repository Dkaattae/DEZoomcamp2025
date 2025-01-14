select "Zone", location_total_amount
from (
	select "PULocationID", sum(total_amount) as "location_total_amount"
	from green_taxi_data
	where "lpep_pickup_datetime"::date = '2019-10-18'::date 
	group by "PULocationID"
	having sum(total_amount) > 13000
) location_amount
left outer join zones
	on location_amount."PULocationID" = zones."LocationID"
order by location_total_amount desc;