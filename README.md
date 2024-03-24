# Adrià Termes - Junior Business Analyst SQL Test
SQL technical test for a Junior business Analyst position using R for SQL querying and replication.

Using RStudio and built-in tools that can be easily ran on any person directory; we answer three twchnical questions regarding a technical test for SQL querying. There are two main reasons why, although we talk about SQL, we do not use pure-SQL tools and refer to RStudio.

1. RStudio is a one stop shop interface for data analysis: not only can we call SQL queries and retrieve data, but we can directly build plots, machine learning models and all steps of ETL pipelines without leaving the interface.
2. RSttudio is a great troubleshooting tool: For complex SQL queries, R provides libraries translating with precision to SQL language, as it was built upon it. If the query is complex and you know R, you can do any SQL query.

In that sense, the approach is as follows:

- We start by understanding the underlying business request for comprehending the final result.
- If multiple nested queries are required, we guide our approach through R language and translate the query to SQL to have better guidance.
- The final output is always an SQL query, although R is used to replicate in a real database querying context and to help create the SQL query per se.

With that, we always get to the point in which we have an SQL query; but thanks to the power of RStudio, we make sure to double check the outputs and create an in-process database management system (dbms) to replicate querying a database with sampled data given for the three exercises.
