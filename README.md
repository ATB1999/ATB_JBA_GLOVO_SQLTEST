# Adrià Termes - Junior Business Analyst SQL Test
SQL technical test for a Junior business Analyst position using R for SQL querying and replication.

Using RStudio and built-in tools that can be easily ran on any person directory; we answer three technical questions regarding a technical test for SQL querying. There are three main reasons why, although we talk about SQL, we do not use pure-SQL tools and refer to RStudio.

![image](https://github.com/ATB1999/ATB_JBA_SQLTEST/assets/112544311/5a2e1194-4214-4e28-9909-3168b31c0ca7)


1. RStudio is a one stop shop interface for data analysis: not only can we call SQL queries and retrieve data, but we can directly build plots, machine learning models and all steps of ETL pipelines without leaving the interface. Allso, we can replicate
2. RStudio is a great troubleshooting tool: For complex SQL queries, R provides libraries translating with precision to SQL language, as it was built upon it. If the query is complex and you know R, you can do any SQL query.
3. RStudio allows us to replicate production environments and querying, thanks to the seamless creations of in-process database management systems (DBMS) like DuckDB, which is the one we use in this specific setting.

In that sense, the approach is as follows:

- We start by understanding the underlying business request for comprehending the final result.
- If multiple nested queries are required, we guide our approach through R language and translate the query to SQL to have better guidance.
- The final output is always an SQL query, although R is used to replicate in a real database querying context and to help create the SQL query per se.

With that, we always get to the point in which we have an SQL query; but thanks to the power of RStudio, we make sure to double check the outputs and create an in-process database management system (dbms) to replicate querying a database with sampled data given for the three exercises. There are three questions:

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
**1**. Let’s say you have two tables: orders and order_points.Create an SQL query that shows the distance between the courier starting position and the pickup point, as well as the distance between the pickup point and the delivery point. The orders table has 1M+ rows; here’s the first row:
![image](https://github.com/ATB1999/ATB_JBA_SQLTEST/assets/112544311/13cffc86-58e1-41fa-b3ea-800860ca6405)

The order_points table also has 2M+ rows. As FYI there are two types of point, ‘DELIVERY’ and ‘PICKUP’. Here’s an example:
![image](https://github.com/ATB1999/ATB_JBA_SQLTEST/assets/112544311/9fc5c472-c5b0-4e7e-8dde-fe70dec99143)

-------------------------------------------------------------------------------------------------------------------------------------------------------------------

**2**. Build one SQL query to create a cohort of Signup to First Order and show the result. The objective of this cohort is to see, out of the users that signed up in Week N, how many did their first order in Week N+1, N+2, N+3... The users table has 1M+ rows; here’s the first three rows:
![image](https://github.com/ATB1999/ATB_JBA_SQLTEST/assets/112544311/3af6b8dc-8d24-429f-8b0f-6854b0f05a19)

The orders table has 1M+ rows; here’s the first row:
![image](https://github.com/ATB1999/ATB_JBA_SQLTEST/assets/112544311/852db235-1177-45fa-afa7-f92f7038ebc0)

The output must be scalable for all weeks and does not require to be in a cohort format. The end user could potentially use the pivot function from Excel or Google
sheets to do so.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------

**3**. Build a sql query to get the difference in days between an order and the previous order that the same customer placed. The orders table has 1M+ rows; here’s the orders for a specific customer:
![image](https://github.com/ATB1999/ATB_JBA_SQLTEST/assets/112544311/70b8a083-71b5-4fe4-b9cd-a35e126270f9)

And here’s the output we expect for this specific example:
![image](https://github.com/ATB1999/ATB_JBA_SQLTEST/assets/112544311/ed28ccba-b648-43cd-b2fa-ab8209c02b91)
