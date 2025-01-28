select split(split(filename, '_')[offset(2)], '-')[offset(0)] as trip_year, count(*) as trip_count
from `zoomcamp.yellow_tripdata`
group by trip_year
