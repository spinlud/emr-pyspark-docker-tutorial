import boto3  # Not used, just to verify dependency is there
from pyspark.sql import SparkSession
from pyspark.sql.types import *
from pyspark.sql.functions import *
from my_spark_app.shared.config import Config


def main():
	# Create spark session
	spark = SparkSession.builder.getOrCreate()

	# Define a schema for our input data
	json_schema = StructType([
		StructField('fips', StringType(), True),
		StructField('admin2', StringType(), True),
		StructField('province_state', StringType(), True),
		StructField('country_region', StringType(), True),
		StructField('combined_key', StringType(), False),
		StructField('last_update', StringType(), True),
		StructField('latitude', FloatType(), True),
		StructField('longitude', FloatType(), True),
		StructField('confirmed', IntegerType(), True),
		StructField('active', IntegerType(), True),
		StructField('recovered', IntegerType(), True),
		StructField('deaths', IntegerType(), True)
	])

	# Load data from S3
	df = spark.read.json(path=f'{Config.READ_PROTOCOL}://covid19-lake/enigma-jhu/json/*', schema=json_schema)

	# Register a temporary table so we can query it using SQL syntax
	df.registerTempTable('temp')

	# Get last updated data for each country_region/province_state
	latest_data = spark.sql(f'''
		SELECT
			a.combined_key,
			a.country_region,
			a.province_state,
			a.confirmed,
			a.active,
			a.recovered,
			a.deaths,
			a.last_update
		FROM temp a
		WHERE last_update = (SELECT MAX(last_update) FROM temp b WHERE a.combined_key = b.combined_key)
			AND a.country_region IS NOT NULL AND a.country_region <> ''
			AND a.province_state IS NOT NULL AND a.province_state <> ''
	''')

	# Show Italy data
	latest_data.where(col('country_region') == 'Italy') \
		.sort('province_state') \
		.show(50, truncate=False)

	# Write csv report for each country_region/province_state
	latest_data \
		.repartition(1, ['country_region', 'province_state']) \
		.write \
		.partitionBy(['country_region', 'province_state']) \
		.mode('overwrite') \
		.csv(path=f'{Config.WRITE_PROTOCOL}:///output', sep=',', header=True)



if __name__ == '__main__':
	main()
