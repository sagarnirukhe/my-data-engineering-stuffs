import configHelper
import logging
import sparkHelper
from datetime import datetime

# from pyspark import SparkConf
# from pyspark import SparkContext, HiveContext
# from pyspark.sql import SparkSession, DataFrame
# from pyspark.sql.types import StructType, StructField, StringType, IntegerType, DateType,BooleanType
# from pyspark.sql import SparkSession, Row
from pyspark.sql.functions import md5, concat_ws, lit, col

logging.basicConfig(
    filename='/home/saif/LFS/PROJECT1.1/Logs/b7.Type2.log',
    level=logging.INFO,
    format='%(asctime)s %(levelname)s %(message)s',
    datefmt='%Y-%m-%d %H-%M-%S',
    filemode='w'
)
logger = logging.getLogger()

if __name__ == '__main__':
    logger.info("Execution Start")

    try:
        spark = sparkHelper.get_SparkSession(configHelper.getProperty("hive_db","metastore.uris"),
                                             configHelper.getProperty("hive_db","spark.warehousedir"))

        high_date = datetime.strptime('9999-12-31', '%Y-%m-%d').date()
        current_date = datetime.today().date()
        col_list = configHelper.getProperty("misc", "cols_hash").split(",")

        # Read Source Data from Hive Table
        newDF = sparkHelper.load_data_FromHive(spark,configHelper.getProperty("hive_db","database"),
                                               configHelper.getProperty("hive_db","table"))

        # Added HashColumn to identify UPSERT / Unchange records
        newDFWithHash = newDF.withColumn("record_hash", md5(concat_ws("", *col_list)))
        #newDFWithHash.show(truncate=False)
        #exit(0)

        logger.info("Read Data From Hive Successfully.")

        # Get Data from Target table
        curr_data_df =  sparkHelper.get_data_mysql(spark, configHelper.getProperty("mysql","username"),
                                                    configHelper.getProperty("mysql", "password"),
                                                    configHelper.getProperty("mysql", "database"),
                                                    configHelper.getProperty("mysql", "target_table"),
                                                    configHelper.getProperty("mysql", "url"))
        #curr_data_df.show(truncate=False)
        logger.info("Read Data From RDBMS Table Successfully.")

        # Identify Unchange Recods
        unChangeDF = curr_data_df.filter(col("is_current") == 1).alias("left")\
            .join(newDFWithHash.alias("right"),col("left.record_hash") == col("right.record_hash"), "inner") \
            .select("left.*")
        #unChangeDF.show(truncate=False)

        logger.info("Created unChangeDF for Unchange Records")

        # New Records
        newRecDF = newDFWithHash.alias("left") \
            .join(curr_data_df.filter(col("is_current") == 1).alias("right"),col("left.record_hash") == col("right.record_hash"), "leftanti") \
            .select("left.*") \
            .withColumn("eff_start_date", lit(current_date)) \
            .withColumn("eff_end_date", lit(high_date)) \
            .withColumn("is_current", lit(1).cast("int"))

        #newRecDF.show(truncate=False)
        logger.info("Created newRecDF for NEW Records")

        # Closing Records
        delRecDF = curr_data_df.alias("left") \
            .join(newDFWithHash.alias("right"), col("left.record_hash") == col("right.record_hash"), "leftanti") \
            .select("left.*") \
            .withColumn("eff_end_date", lit(current_date)) \
            .withColumn("is_current", lit(0).cast("int"))

        #delRecDF.show(truncate=False)
        logger.info("Created delRecDF for closing records")

        print("******* Control Table Stats ***************************************************************************")
        print("NO Change: {}".format(unChangeDF.count()))
        print("INSERT: {}".format(newRecDF.count()))
        print("Update: {}".format(delRecDF.count()))
        print()

        # Final DataFrame
        finalDF = unChangeDF \
            .union(newRecDF) \
            .union(delRecDF) \
            .sort(col("custid"))

        print("******* Final SCDTYPE2 Result *************************************************************************")
        finalDF.show(truncate=False)

        # RDBMS-MYSQL write operation call
        sparkHelper.write_mysql(finalDF,
            configHelper.getProperty("mysql", "username"),
            configHelper.getProperty("mysql", "password"),
            configHelper.getProperty("mysql", "database"),
            configHelper.getProperty("mysql", "stage_table"),
            configHelper.getProperty("mysql", "target_table"),
            configHelper.getProperty("mysql", "url"))

        print("RDBMS write operation completed")
        logger.info("finalDF write Succeedfully to RDBMS")
        cassandraDF = finalDF.filter(col("is_current") == 1) \
                        .select(col("custid"),col("username"),col("quote_count"),col("ip"),col("entry_time") \
                            ,col("prp_1"),col("prp_2"),col("prp_3"),col("ms"),col("http_type"),col("purchase_category") \
                            ,col("total_count"),col("purchase_sub_category"),col("status_code"),col("filename"),col("create_dt") \
                            ,col("record_hash"),col("eff_start_date"),col("eff_end_date"),col("is_current"))

        logger.info("finalDF writing Active Records to Cassandra: Start")
        # Cassandra write operation call
        sparkHelper.write_cassendra_keyspace(cassandraDF,configHelper.getProperty("cassandra_db", "table") \
                                             ,configHelper.getProperty("cassandra_db", "keyspace"))

        logger.info("cassandraDF writing Active Records to Cassandra: Completed")
        print("Cassandra write operation completed")

        logger.info("Execution End")
    except Exception as e:
        print(e)
        logger.error(e)
        exit(1)