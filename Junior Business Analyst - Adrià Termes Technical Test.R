# Junior business Analyst SQL Test

## Preliminary Work: Importing Packages ------------------------------------


library(DBI)
library(dbplyr)
library(tidyverse)


# Q1 ----------------------------------------------------------------------

# Let’s say you have two tables: orders and order_points. Create an SQL query
# that shows the distance between the courier starting position and the pickup
# point, as well as the distance between the pickup point and the delivery point.
# The orders table has 1M+ rows; The order_points table also has 2M+ rows. As FYI
# there are two types of point, ‘DELIVERY’ and ‘PICKUP’.


#We create an SQL connection
con1 <- DBI::dbConnect(
  duckdb::duckdb(),             #The DBMS specification in our case
)


orders <- data.frame(id = "70989363",
           customer_id = 16440619,
           courier_id = 10798260,
           acceptance_latitude = 41.4837787,
           acceptance_longitude = 2.0535802)

order_points <- data.frame(order_id = c("70989363", "70989363"),
                           point_type = c("PICKUP", "DELIVERY"), 
                           latitude = c(41.4827549, 41.4873773),
                           longitude = c(2.0528974, 2.0650261))

# Putting data in a SQL format so that we can formulate the question in R
dbWriteTable(con1, "orders", orders, overwrite = TRUE) 
dbWriteTable(con1, "order_points", order_points, overwrite = TRUE) #Transforming to SQL tables.
dbListTables(con1) #Making sure we have our tables in a SQL table format. 

orders <- tbl(con1, "orders")
order_points <- tbl(con1, "order_points")

#Question using dblpyr

inner_join(x = orders, y = order_points, by = c("id" = "order_id")) %>%
  pivot_wider(id_cols = id:acceptance_longitude,
              names_from = point_type,
              values_from = c(latitude, longitude)) %>%
  mutate( #Harvesine distance calculations for both metrics wanted
    km_distance_acceptance_to_pickup = 6371 * acos(
      cos(pi * acceptance_latitude / 180) *
        cos(pi * latitude_PICKUP / 180) *
        cos((pi * longitude_PICKUP / 180) - (pi * acceptance_longitude / 180)) +
        sin(pi * acceptance_latitude / 180) *
        sin(pi * latitude_PICKUP / 180)
    ),
    km_distance_pickup_to_delivery = 6371 * acos(
      cos(pi * latitude_PICKUP / 180) *
        cos(pi * latitude_DELIVERY / 180) *
        cos((pi * longitude_DELIVERY / 180) - (pi * longitude_PICKUP / 180)) +
        sin(pi * latitude_PICKUP / 180) *
        sin(pi * latitude_DELIVERY / 180)
    )
  ) %>%
  select(km_distance_acceptance_to_pickup, km_distance_pickup_to_delivery) %>%
  show_query()

#SQL

sql <- "
SELECT
  6371.0 * ACOS(((COS((3.14159265358979 * acceptance_latitude) / 180.0) * COS((3.14159265358979 * latitude_PICKUP) / 180.0)) * COS(((3.14159265358979 * longitude_PICKUP) / 180.0) - ((3.14159265358979 * acceptance_longitude) / 180.0))) + SIN((3.14159265358979 * acceptance_latitude) / 180.0) * SIN((3.14159265358979 * latitude_PICKUP) / 180.0)) AS km_distance_acceptance_to_pickup,
  6371.0 * ACOS(((COS((3.14159265358979 * latitude_PICKUP) / 180.0) * COS((3.14159265358979 * latitude_DELIVERY) / 180.0)) * COS(((3.14159265358979 * longitude_DELIVERY) / 180.0) - ((3.14159265358979 * longitude_PICKUP) / 180.0))) + SIN((3.14159265358979 * latitude_PICKUP) / 180.0) * SIN((3.14159265358979 * latitude_DELIVERY) / 180.0)) AS km_distance_pickup_to_delivery
FROM (
  SELECT
    id,
    customer_id,
    courier_id,
    acceptance_latitude,
    acceptance_longitude,
    MAX(CASE WHEN (point_type = 'DELIVERY') THEN latitude END) AS latitude_DELIVERY,
    MAX(CASE WHEN (point_type = 'PICKUP') THEN latitude END) AS latitude_PICKUP,
    MAX(CASE WHEN (point_type = 'DELIVERY') THEN longitude END) AS longitude_DELIVERY,
    MAX(CASE WHEN (point_type = 'PICKUP') THEN longitude END) AS longitude_PICKUP
  FROM (
    SELECT orders.*, point_type, latitude, longitude
    FROM orders
    INNER JOIN order_points
      ON (orders.id = order_points.order_id)
  ) q01
  GROUP BY
    id,
    customer_id,
    courier_id,
    acceptance_latitude,
    acceptance_longitude
)
"
dbGetQuery(con1, sql) %>%
  as_tibble()


# Q2 ----------------------------------------------------------------------

# Build one SQL query to create a cohort of Signup to First Order and show the result.
# The objective of this cohort is to see, out of the users that signed up in Week N, how
# many did their first order in Week N+1, N+2, N+3...
# 
# The output must be scalable for all weeks and does not require to be in a cohort
# format. The end user could potentially use the pivot function from Excel or Google
# sheets to do so.

con2 <- DBI::dbConnect(
  duckdb::duckdb(),             #The DBMS specification in our case
)


users <- data.frame(id = c("5722", "1708", "3313"),
                    first_order_id = c("51189589", "65981902", "69182470"),
                    registration_date = as.POSIXct(c("2015-09-08 09:40:29.000000",
                                                     "2015-04-23 13:25:47.000000",
                                                     "2015-06-16 08:20:46.000000")))

orders <- data.frame(id = c("985", "477"),
                     customer_id = c("596", "1708"),
                     activation_time = as.POSIXct(c("2015-03-15 21:10:34.000000", "2015-06-20 10:51:10.000000")))



# Putting data in a SQL format so that we can formulate the question in R
dbWriteTable(con2, "users", users, overwrite = TRUE) 
dbWriteTable(con2, "orders", orders, overwrite = TRUE) #Transforming to SQL tables.
dbListTables(con2) #Making sure we have our tables in a SQL table format. 

users <- tbl(con2, "users")
orders <- tbl(con2, "orders")

#Question using dbplyr

inner_join(x = users, y = orders, by = c("id" = "customer_id")) %>%
  mutate(registration_week = week(registration_date)) %>% #Variable about activation week
  mutate(weeks_to_activate = week(activation_time) - week(registration_date)) %>% #Activation time variable
  group_by(registration_week, weeks_to_activate) %>% #Grouping both
  count() %>% #Counting each registration week, the weeks for activation in data points terms 
  show_query()

# Question using SQL
sql <- "
SELECT registration_week, weeks_to_activate, COUNT(*) AS n
FROM (
  SELECT
    q01.*,
    week(activation_time) - week(registration_date) AS weeks_to_activate
  FROM (
    SELECT q01.*, week(registration_date) AS registration_week
    FROM (
      SELECT users.*, orders.id AS 'id.y', activation_time
      FROM users
      INNER JOIN orders
        ON (users.id = orders.customer_id)
    ) q01
  ) q01
) q01
GROUP BY registration_week, weeks_to_activate
"

#Calling it
dbGetQuery(con2, sql) %>%
  as_tibble()
  

# Q3 ----------------------------------------------------------------------

# Build a sql query to get the difference in days between an order and the previous
# order that the same customer placed.
# The orders table has 1M+ rows; here’s the orders for a specific customer:

con3 <- DBI::dbConnect(
  duckdb::duckdb(),             #The DBMS specification in our case
)


orders <- data.frame(customer_id = c("5842","5842","5842","5842","5842"),
                     id = c("71205510", "71213824", "71549414", "72516800", "72949957"),
                     activation_time = as.POSIXct(c("2019-10-16 14:14:52.000000", "2019-10-16 15:05:32.000000",
                                         "2019-10-18 06:18:18.000000", "2019-10-22 10:13:04.000000",
                                         "2019-10-24 14:49:17.000000")))

# Putting data in a SQL format so that we can formulate the question in R
dbWriteTable(con3, "orders", orders, overwrite = TRUE) #Transforming to SQL tables.
dbListTables(con3) #Making sure we have our tables in a SQL table format. 

orders <- tbl(con3, "orders")

#Question using dblpyr (reference, as it cannot filter NA's)

#Some inspiration...
orders %>%
  group_by(customer_id) %>%
  arrange(activation_time) %>%
  mutate(days_since_last_order = day(activation_time) - lag(day(activation_time))) %>%
  show_query()


sql1 <- "SELECT
  orders.*,
  EXTRACT(day FROM activation_time) - LAG(EXTRACT(day FROM activation_time), 1, NULL) OVER (PARTITION BY customer_id ORDER BY activation_time) AS days_since_last_order
FROM orders
ORDER BY activation_time"


dbGetQuery(con3, sql1) %>%
  as_tibble()


#We cannot take out NA as SQL clahes with R on that function, we will change for that case SQL in a nested manner.

sql2 <- "
WITH LaggedOrders AS (
    SELECT
        orders.*,
        DAY(activation_time) - LAG(DAY(activation_time)) OVER (PARTITION BY customer_id ORDER BY activation_time) AS days_since_last_order
    FROM
        orders
)
SELECT
    *
FROM
    LaggedOrders
WHERE
    days_since_last_order IS NOT NULL
ORDER BY
    activation_time;
"

dbGetQuery(con3, sql2) %>%
  as_tibble()
