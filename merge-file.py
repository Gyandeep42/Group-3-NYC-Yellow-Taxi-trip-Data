import sys
import os
import requests
from io import BytesIO
import pandas as pd
from pyspark.sql import SparkSession
from pyspark.sql.functions import lit

# --------------------
# Configurations
# --------------------
years = list(range(2016, 2023))  # 2016–2022
base_url = "https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_YYYY-MM.parquet"
output_s3_path = "s3://your-output-bucket/nyc-yellow-taxi-data/"  # Change to your bucket

# --------------------
# Initialize Spark
# --------------------
spark = SparkSession.builder.appName("NYC_Yellow_Taxi_Merge").getOrCreate()


# --------------------
# Function to fetch monthly data
# --------------------
def fetch_monthly_data(year, month):
    url = base_url.replace("YYYY", str(year)).replace("MM", f"{month:02d}")
    print(f"Downloading: {url}")
    try:
        # Direct read via Spark
        df = spark.read.parquet(url)
        return df
    except Exception as e:
        print(f"Failed to fetch {url} -> {e}")
        return None


# --------------------
# Process year-wise
# --------------------
for year in years:
    print(f"Processing year {year} ...")
    monthly_dfs = []

    for month in range(1, 13):
        df_month = fetch_monthly_data(year, month)
        if df_month is not None:
            df_month = df_month.withColumn("year", lit(year)).withColumn("month", lit(month))
            monthly_dfs.append(df_month)

    if monthly_dfs:
        df_year = monthly_dfs[0]
        for df in monthly_dfs[1:]:
            df_year = df_year.unionByName(df)

        output_path = f"{output_s3_path}{year}/"
        print(f"Saving merged year {year} to {output_path}")
        df_year.write.mode("overwrite").parquet(output_path)

spark.stop()