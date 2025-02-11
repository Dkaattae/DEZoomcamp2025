# dlt
I run the python script in docker container. the libraries needed in the script are put in the requirement.txt file   
```docker build -t dlt_pipeline .```   
```docker run --rm dlt_pipeline```   
the following output will showup in terminal.

## question1
```print("dlt version:", dlt.__version__)```   
output: ```dlt version: 1.6.1```

## question2
output:    
Pipeline ny_taxi_pipeline load step completed in 0.87 seconds    
1 load package(s) were loaded to destination duckdb and into dataset ny_taxi_data    
The duckdb destination used duckdb:////app/ny_taxi_pipeline.duckdb location to store data    
Load package 1739290130.764691 is LOADED and contains no failed jobs    

output: 
<pre>
           database  ... temporary   
0  ny_taxi_pipeline  ...     False   
1  ny_taxi_pipeline  ...     False   
2  ny_taxi_pipeline  ...     False   
3  ny_taxi_pipeline  ...     False   

[4 rows x 6 columns]
</pre>  

## question3
total number of records extracted: 10000

## question4
[(12.3049,)]
