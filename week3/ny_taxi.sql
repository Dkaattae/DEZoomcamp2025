-- Creating external table referring to gcs path
CREATE OR REPLACE EXTERNAL TABLE `zoomcamp.external_yellow_tripdata`
OPTIONS (
  format = 'parquet',
  uris = ['gs://<bucket_name>/yellow_tripdata_2024-*.parquet'] -- edit bucket name
);

-- Create a non partitioned table from external table
CREATE OR REPLACE TABLE zoomcamp.yellow_tripdata_non_partitioned AS
SELECT * FROM zoomcamp.external_yellow_tripdata;

-- q2 count distinct PULocationIDs, est 155.12MB
select count(*)
from `zoomcamp.external_yellow_tripdata`
group by PULocationID;

select count(*)
from `zoomcamp.yellow_tripdata_non_partitioned`
group by PULocationID;

-- q3 retrieve PULocationID and DOLocationID, est 310.24MB
select PULocationID, DOLocationID
from `zoomcamp.yellow_tripdata_non_partitioned`;

-- q4 fare_amount = 0
select count(*)
from `zoomcamp.yellow_tripdata_non_partitioned`
where fare_amount = 0;

-- q5 partitioned by pickupdate and clustered by vendorID
CREATE OR REPLACE TABLE `zoomcamp.yellow_tripdata_partitioned_clustered`
PARTITION BY DATE(tpep_pickup_datetime)
CLUSTER BY VendorID AS
SELECT * FROM `zoomcamp.external_yellow_tripdata`;

-- q6 distinct vendorID non partitioned table est 310.24MB
select distinct(VendorID)
from zoomcamp.yellow_tripdata_non_partitioned
where date(tpep_pickup_datetime) >= '2024-03-01'
  and date(tpep_pickup_datetime) <= '2024-03-15';

-- q6 distinct vendorID partitioned table est 26.85MB
CREATE OR REPLACE TABLE `zoomcamp.yellow_tripdata_partitioned`
PARTITION BY DATE(tpep_pickup_datetime) AS
SELECT * FROM `zoomcamp.external_yellow_tripdata`;

select distinct(VendorID)
from zoomcamp.yellow_tripdata_partitioned
where date(tpep_pickup_datetime) >= '2024-03-01'
  and date(tpep_pickup_datetime) <= '2024-03-15';

-- q6 distinct vendorID partitioned and clustered table est 26.85MB
select distinct(VendorID)
from zoomcamp.yellow_tripdata_partitioned_clustered
where date(tpep_pickup_datetime) >= '2024-03-01'
  and date(tpep_pickup_datetime) <= '2024-03-15';

-- q8 bonus
select count(*)
from `zoomcamp.yellow_tripdata_non_partitioned`;

select count(*)
from `zoomcamp.yellow_tripdata_partitioned`;

select count(*)
from `zoomcamp.yellow_tripdata_partitioned_clustered`
