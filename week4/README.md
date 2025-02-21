# Analytic Engineering   
## loading data   
I updated the gcp_taxi.yml from week2 to include fhv dataset.   
something i noticed but not related to week4 homework is that, in fhv_tripdata_2020-01.csv file, there is an extra newline which will fail the loading job in bigquery.    

## Q1 understanding dbt model resolution   
put the env_var in dbt environment and put the code into dbt cloud IDE, click compile will get the answer.     
```select * from dtc_zoomcamp_2025.raw_nyc_tripdata.ext_green_taxi```

## Q2 dbt variables & dynamic models   
in dbt environment, set DAYS_BACK as env_var, in development put in 7, in production put in 30.    
```'{{ env_var("DAYS_BACK", "30") }}'```   
will compile to 7 in development and 30 in production, if there are no settings in env_var, it will return 30.   

## Q3 dbt data lineage and execution   
```dbt run --select +<model_name>+```    
the left '+' meaning it will run every models has the same color line connected to <model_name> on the left in lineage,   
the right '+' meaning it will run every models has the same color line connected to <model_name> on the right in lineage,   
if any model has already been materialized in dbt (even if not fresh), dbt will run the materialized version.   
only if that model and all of its dependencies are materialized, that model will be materialized.    
so, we need to run fct_taxi_monthly_zone_revenue and all of its dependencies exclude dim_zone_lookup because it has already been materilized.      
A, ```dbt run```. this option will run everything in the project.    
B, ```dbt run --select +models/core/dim_taxi_trips.sql+ --target prod```. this option will run models with magenta color line connected to   
C, ```dbt run --select +models/core/fct_taxi_monthly_zone_revenue.sql```. same as above.   
D, ```dbt run --select +models/core/```. this option will run everything, because core is the very right layer.      
E, ```dbt run --select models/staging/+```. this option will run models beginning with 'stg_', 'dim_' and 'fct_'. not any 'raw_' layer. so this option will not materilze the model.   

## Q4 dbt Macros and Jinja   
the jinja code provided meaning when using 'core', it will set a value for target_env_var which is 'DBT_BIGQUERY_TARGET_DATASET'.   
so that env_var has to be set in environment.   
when using other value, it will set a value for stging_env_var if exists, if not exists set to target_env_var.   
so setting stging_env_var is optional.   
note: if i setup the resolve_schema_for macro file and put ```{{ config(schema=resolve_schema_for('core')) }}``` on top of dim_ or fact_ models, it will config to target_schema.custome_schema. in my case, that is dbt_<myname>_prod.   
if i need to override default macro generate_schema_name, i need to add following macro:  
<code>&nbsp;{% macro generate_schema_name(custom_schema_name, node) -%}
    {{ generate_schema_name_for_env(custom_schema_name, node) }}
{%- endmacro %}      
</code>    

## Q5 Taxi Quarterly Revenue Growth   
 see fact_taxi_trips_quarterly_revenue.sql   
## Q6 P97/P95/P90 Taxi Monthly Fare   
 see fact_taxi_trips_monthly_fare_p95.sql   
## Q7 Top #Nth longest P90 travel time Location for FHV   
 see fact_fhv_monthly_zone_traveltime_p90.sql
