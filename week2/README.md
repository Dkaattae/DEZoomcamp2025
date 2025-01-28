# using Kestra to ochestrate flows
when i run gcp_taxi_scheduled_etc file, i go to Triggers tab on top, id=green_schedule, click Backfull executions, then pick start/end time as indicated.    
*note: green taxi files are smaller, backfill works properly. yellow taxi files are bigger, when i run 2019 backfill,    
  i lost wifi connection due to router throttling my network for large bandwitch.    
  so i run the iteration instead. i run my iterate_gcp_taxi_flow file, it works properly for yellow taxi.*    
  I should define start year/month and end year/month as input, so that i do not need to run duplicates.   

## Quiz
1, before running gcp_taxi, I added ```disabled = true ``` in purge_file section. and then after running gcp_taxi, 
  i go to executions tab on the left to see outputs in extract section. clicking outputFiles and clicking yellow_tripdata_2020-12.csv, I can see the filesize under Debug Outputs   
2, after running gcp_taxi, and put green, 2020, 04 as inputs, i can check the filename in bigquery, the new table named 'green_tripdata_2020-04.csv' added in schema.   
3, see bigquery file hw2_3   
4, see bigquery file hw2_4   
5, in bigquery, click the table yellow_tripdata_2021-03.csv, in detail listed how many rows   
6, see gcp_taxi_scheduled_etc   
