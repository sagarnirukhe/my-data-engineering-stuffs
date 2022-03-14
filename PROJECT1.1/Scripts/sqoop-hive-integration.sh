#!/bin/bash

LOGS_DIR="/home/saif/LFS/Scripts/Logs/"
CURR_DATE=`date +%d-%m-%y`
TEMP=`basename ${0}`"_"${CURR_DATE}".log"
LOG_FILENAME=`echo ${TEMP} | sed -r 's/\.sh//g'`
PARAM_COUNT=0

# Function to log execution of 
log (){
	#echo "$1"
	echo "${CURR_DATE}:$1" >> ${LOGS_DIR}${LOG_FILENAME} 2>&1
}

log "INFO: ********** Script Execution Start **********"
echo ""
echo -e "\e[32m********** Script Execution Start ***************************************\e[0m"
echo ""

#### Parameter Handling ####
while [ "$1" != "" ]; 
do
   case $1 in
    "--p" | "--paramfile")
        shift
		PARAM_FILE=$1
		PARAM_COUNT=`expr ${PARAM_COUNT} + 1`
        ;;
    "--o" | "--optionfile")
		shift
        QUERY_FILE=$1
		PARAM_COUNT=`expr ${PARAM_COUNT} + 1`
        ;;
    "--t" | "--tablename")
        shift
        TABLE_NAME=$1
		PARAM_COUNT=`expr ${PARAM_COUNT} + 1`
        ;;
    "--h" | "--help") 
         echo "\e[32mUsage: sqoop-hive-integration.sh [--p | --paramfile] [--o | --optionfile] [--t | --tablename]\e[0m"
         exit
      ;;
    *) 
        echo "Invalid option: $1"
        echo "Usage: script_name [--p | --paramfile] [--o | --optionfile] [--t | --tablename] "
        #exit
       ;;
  esac
  shift
done

if [ $PARAM_COUNT -ne 3 ]
then
	echo -e "\e[31mInvalid number of arguments"
	echo -e "\e[31mUsage: sqoop-hive-integration.sh [--p | --paramfile] [--o | --optionfile] [--t | --tablename]\e[0m"
	echo ""
	echo -e "\e[32m********** Script Execution End with an Error ******************\e[0m"
	
	log "ERROR: Invalid number of arguments."
	log "ERROR: Script Execution ends with an Error."
	exit 1
fi

# Include Config File
. ${PARAM_FILE}

#echo $HDFS_DIR"JOB3"

# Connect and show list of tables.
mysql -u${username} -p${password} -D${database} <<<'show tables' 2>/dev/null | 
 
# Read through the piped result until it's empty.
while IFS='\n' read list; do
	if [[ ${list} = "Tables_in_retail_db" ]]; then
    echo $list
    echo "----------------------------------------"
  else
    echo $list
  fi
done
echo " "
log "INFO: Read List of Tables From ${database}"

echo -e "\e[33m***** Check Database Connectivity   ********************************\e[0m"
mysql -s -u${username} -p${password} -D${database} -e "STATUS" 2>/dev/null | grep -v "DATABASE" | head -5
echo " "
log "INFO: Validated Database Connectivity ${database} Successfully."

echo -e "\e[33m***** Check ${tablename} Table Exist *******************************\e[0m"
# Connect and show list of tables.
mysql -u${username} -p${password} -D${database} --skip-column-names <<<"SHOW TABLES LIKE '${tablename}'" 2>/dev/null | 

while IFS='\n' read list; do
	#if [[ ${list} = "Tables_in_retail_db (categories)" ]];
	if [[ ${list} -eq ${tablename} ]]; then
		echo ${list}" Table Exist ......"
		record_cnt=`mysql -s -u${username} -p${password} -D${database} -e "SELECT count(*) FROM ${tablename}" 2>/dev/null`
		echo "Record Count : "${record_cnt}
	fi
done   
echo " "
log "INFO: Verified ${tablename} table Record Count Successfully."

echo -e "\e[33m********** Executing sqoop command for ${tablename} ****************\e[0m" 

sqoop import --connect jdbc:mysql://localhost:${PORT}/${database}?useSSL=False \
--table ${tablename} \
--username ${username} \
--password-file file:///home/saif/LFS/sqoop.pwd \
--delete-target-dir \
--target-dir $HDFS_DIR$tablename"_tgt" &> ${LOGS_DIR}sqoopLogFile_${CURR_DATE}.log

if [ $? -ne 0 ]
then
	echo -e "\e[31mError while execution of Sqoop Job_1\e[0m"
	log "ERROR: Error while execution of Sqoop Job_1 for ${tablename}"
	exit 1
fi
log "INFO: Executed sqoop job_1 for ${tablename} Successfully."

echo "HDFS Directory for Sqoop job_1 Created Successfully."
#hdfs dfs -ls $HDFS_DIR$tablename"_tgt" | grep -i part-* | cut -d' ' -f17 2>/dev/null
for i in `hdfs dfs -ls ${HDFS_DIR}${tablename}_tgt/part-* | awk '{print $8}'`; do echo $i; done
echo ""

echo -e "\e[33m******** Executing sqoop command for ${tablename} warehouse-dir ****\e[0m"
sqoop import --connect jdbc:mysql://localhost:${PORT}/${database}?useSSL=False \
--table ${tablename} \
--username ${username} \
--password-file file:///home/saif/LFS/sqoop.pwd \
--delete-target-dir \
--warehouse-dir $HDFS_DIR$tablename"_tgt_wrhs" &>> ${LOGS_DIR}sqoopLogFile_${CURR_DATE}.log

if [ $? -ne 0 ]
then
	echo -e "\e[31mError while execution of Sqoop Job_2\e[0m"
	log "ERROR: Error while execution of Sqoop Job_2 for ${tablename}"
	exit 1
fi
log "INFO: Executed sqoop job_2 for ${tablename} Successfully."

echo "HDFS Directory for Sqoop job_2 Created Successfully."
for i in `hdfs dfs -ls ${HDFS_DIR}${tablename}_tgt_wrhs/${tablename}/part-* | awk '{print $8}'`; do echo $i; done
echo ""

echo -e "\e[33m********** Executing sqoop command with query-file *****************\e[0m"
sqoop import --connect jdbc:mysql://localhost:${PORT}/${database}?useSSL=False \
--username ${username} \
--password-file ${PASSWORD} \
--options-file ${QUERY_FILE} \
--delete-target-dir \
--target-dir $HDFS_DIR"JOB3" -m 1 &>> ${LOGS_DIR}sqoopLogFile_${CURR_DATE}.log

if [ $? -ne 0 ]
then
	echo -e "\e[32mError while execution of Sqoop Job_3\e[0m"
	log "ERROR: Error while execution of Sqoop Job_3"
	exit 1
fi
log "INFO: Executed sqoop job_3 Successfully."

echo "HDFS Directory for Sqoop job_3 Created Successfully."
for i in `hdfs dfs -ls ${HDFS_DIR}JOB3/part-* | awk '{print $8}'`; do echo $i; done
echo ""

echo -e "\e[33m********** Executing sqoop job_4 for order_status='PENDING_PAYMENT' *****************\e[0m"
sqoop import \
--connect jdbc:mysql://localhost:${PORT}/${database}?useSSL=False \
--username ${username} \
--password-file ${PASSWORD} \
--target-dir ${HDFS_DIR}"ORDER_PENDING" \
--delete-target-dir \
--num-mappers 2 \
--query "select customer_id,customer_fname,customer_lname,order_date,order_status from customers c,orders o where \$CONDITIONS and c.customer_id=o.order_customer_id and order_status='PENDING_PAYMENT'" \
--split-by customer_id &>> ${LOGS_DIR}sqoopLogFile_${CURR_DATE}.log 

if [ $? -ne 0 ]
then
	echo -e "\e[32mError while execution of Sqoop Job_4\e[0m"
	exit 1
fi

echo "HDFS Directory for Sqoop job_4 Created Successfully."
for i in `hdfs dfs -ls ${HDFS_DIR}ORDER_PENDING/part-* | awk '{print $8}'`; do echo $i; done
echo ""

echo -e "\e[33m********** Executing Hive Job_1 for External Table  *********************************\e[0m"
#HIVE JOB To Create External Table
hive --hivevar hive_db_name=${hive_db_name} --hivevar hive_tbl_name=${hive_tbl_prefix}${tablename} --hivevar hive_op_path="${HDFS_DIR}JOB3" -f "${ROOT_DIR}hive_script.hql" &> ${LOGS_DIR}hiveLogFile_${CURR_DATE}.log 

echo "Hive Job: External Table ${hive_tbl_prefix}${tablename} Created Successfully."
log "INFO: Executed Hive job_1 Successfully."

log "INFO: ********** Script Execution End **********"
echo ""
echo -e "\e[32m********** Script Execution End *****************************************\e[0m"
echo ""

#bash sqoop-hive-integration.sh --paramfile /home/saif/LFS/Scripts/param.cfg --optionfile /home/saif/LFS/Scripts/sqoop-options-file.txt --tablename categories
#bash sqoop-hive-integration.sh --p "/home/saif/LFS/Scripts/param.cfg" --o "/home/saif/LFS/Scripts/sqoop-options-file.txt" --t "categories"
exit 0