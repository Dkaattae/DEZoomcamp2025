{{ config(materialized='table') }}

with trips_data as (
    select * from {{ ref('fact_trips') }}
),
trip_data_prep as (
    select 
    extract(year from cast(pickup_datetime as timestamp)) as revenue_year, 
    extract(quarter from cast(pickup_datetime as timestamp)) as revenue_quarter,
    extract(month from cast(pickup_datetime as timestamp)) as revenue_month,
    service_type, 
    total_amount
    from trips_data
),
quarterly_revenue as (
    select
    -- Revenue grouping 
    revenue_year,
    revenue_quarter,
    service_type,
    -- Revenue calculation 
    sum(total_amount) as revenue_quarterly_total_amount,
    from trip_data_prep
    group by revenue_year, revenue_quarter, service_type
)
    select 
    next_year_revenue.revenue_year,
    next_year_revenue.revenue_quarter,
    next_year_revenue.service_type,
    next_year_revenue.revenue_quarterly_total_amount,
    previous_year_revenue.revenue_quarterly_total_amount as previous_year_revenue,
    (next_year_revenue.revenue_quarterly_total_amount-previous_year_revenue.revenue_quarterly_total_amount)
        / previous_year_revenue.revenue_quarterly_total_amount as yoy_growth
    from quarterly_revenue previous_year_revenue
    inner join quarterly_revenue next_year_revenue
        on previous_year_revenue.revenue_quarter = next_year_revenue.revenue_quarter
        and previous_year_revenue.revenue_year = next_year_revenue.revenue_year - 1
        and previous_year_revenue.service_type = next_year_revenue.service_type
    where next_year_revenue.revenue_year = 2020
    order by service_type, yoy_growth