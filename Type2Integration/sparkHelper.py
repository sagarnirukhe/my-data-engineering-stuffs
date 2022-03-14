from pyspark.sql import SparkSession
from pyspark.sql import DataFrame
from mysql.connector import connect, Error
# from pyspark.sql.functions import from_unixtime

def get_SparkSession(conf1, conf2):
    return SparkSession.builder.appName("SCD-TYPE2")\
            .master("local[*]")\
            .config("hive.metastore.uris",conf1)\
            .config("spark.sql.warehousedir",conf2) \
            .config('spark.cassandra.connection.host', 'localhost')\
            .config('spark.cassandra.connection.port', '9042')\
            .config('spark.cassandra.output.consistency.level', 'ONE')\
            .enableHiveSupport()\
            .getOrCreate()

def load_data_FromHive(spark, hiveDB, hiveTBL) -> DataFrame:
        spark.sql("USE " + hiveDB)
        return spark.sql("SELECT INT(custid) as custid ,username, quote_count, ip, entry_time, prp_1, prp_2, prp_3, ms, http_type, purchase_category, total_count, purchase_sub_category," \
                         "http_info, status_code, filename, cast(from_unixtime((create_dt div 1000)) as date) create_dt FROM " + hiveTBL + \
                         " WHERE cast(from_unixtime((create_dt div 1000)) as date) = date_add(current_date,1)")

def get_data_mysql(spark, user_name, pwd, customer_db, table_name, conn_url) -> DataFrame:
        return spark.read.format("jdbc") \
        .option("url",conn_url + customer_db +"?useSSL=false") \
        .option("driver","com.mysql.cj.jdbc.Driver") \
        .option("dbtable",table_name) \
        .option("user",user_name) \
        .option("password",pwd) \
        .load()

def read_cassendra_keyspace(spark,df: DataFrame, table1, database) -> DataFrame:
        spark.read \
                .format("org.apache.spark.sql.cassandra") \
                .options(table=table1, keyspace=database) \
                .load()
        print("Cassendra Read operation Completed")

def write_cassendra_keyspace(activeRecDF: DataFrame, table1, database):
        activeRecDF.write \
                .format("org.apache.spark.sql.cassandra") \
                .options(table=table1, keyspace=database) \
                .option("confirm.truncate", "true") \
                .mode("overwrite") \
                .save()

def write_mysql(finalDF: DataFrame, user_name, pwd, customer_db, table1, table2, conn_url):

        try:
                finalDF.write.format("jdbc") \
                        .option("url",conn_url + customer_db +"?useSSL=false") \
                        .option("driver", "com.mysql.cj.jdbc.Driver") \
                        .option("user", user_name) \
                        .option("password", pwd) \
                        .option("dbtable", table1) \
                        .option("truncate", "true") \
                        .mode("overwrite") \
                        .save()

                # Renaming tables
                with connect(host="localhost",
                             user=user_name,
                             password=pwd,
                             database=customer_db
                        ) as connection:
                                create_db_query = "ALTER TABLE "+ table2 + " RENAME TO customer_type2_tmp"
                                create_db_query1 = "ALTER TABLE "+ table1 +" RENAME TO "+ table2
                                create_db_query2 = "ALTER TABLE customer_type2_tmp RENAME TO " + table1
                                with connection.cursor() as cursor:
                                        cursor.execute(create_db_query)
                                        cursor.execute(create_db_query1)
                                        cursor.execute(create_db_query2)
                return 0

        except Exception as e:
                print("Error while writting into Database")
                print(e)
                exit(1)
