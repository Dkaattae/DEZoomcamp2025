# download parquet file 
I used kestra to download parquet files yellow taxi 2024-01 to 2024-06, to google cloud storage. 

# bigquery
create external table from gcs bucket where file name like 'yellow_tripdata_2024-*'
create materialized table from external table
## question1
click on the materialized table in details tab, under Storage Info section, it shows the number of rows.
## question2
external table does not have an estimate since it is not actually in bigquery, but the actual bytes processed is the same as materialized table
## question3 
bigquery is a column based database, so remember to only select columns you need in queries.
## question4 
simple query
## question5
partitioned and clustered table can save cost when used properly. 
partitioned -- you can improve performance by only scanning part of the partitioned table. that is how we use datetime related columns often. 
clustered -- for large size, commonly filtered, high cardinality columns, it is best practice to cluster. 
## question6
non partitioned table will need to scan all of them, no matter what the date filter is. but for partitioned table, it will reduce cost a lot. 
if we select date from 3/1 to 3/15, that is 15 days, about 1/12 size of the whole dataset. the cost will be 1/12 of non partitioned table
## question7
external table created from gcs will be stored in gcs. 
## question8 
see question5. if table size is not big enough, the benefit is limited. 
## bonus
it is 0B to run the count of a materialized table, because the number of rows is stored in metatable. 
