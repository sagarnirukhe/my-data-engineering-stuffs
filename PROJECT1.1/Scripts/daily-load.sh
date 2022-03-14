#!/bin/bash
# bash daily-load.sh --paramfile /home/saif/LFS/PROJECT1.1/Scripts/param.cfg

CURR_DATE=`date +%d-%m-%y`
TEMP=`basename ${0}`"_"${CURR_DATE}".log"
LOG_FILENAME=`echo ${TEMP} | sed -r 's/\.sh//g'`
PARAM_COUNT=0

#### Parameter Handling ####
while [ "$1" != "" ]; 
do
   case $1 in
    "--p" | "--paramfile")
        shift
		PARAM_FILE=$1
		PARAM_COUNT=`expr ${PARAM_COUNT} + 1`
        ;;
    "--h" | "--help") 
         echo "\e[32mUsage: ots.sh [--p | --paramfile] \e[0m"
         exit 1
      ;;
    *) 
        echo "Invalid option: $1"
        echo "Usage: script_name [--p | --paramfile] "
        exit 1
       ;;
  esac
  shift
done

if [ $PARAM_COUNT -ne 1 ]
then
	echo -e "\e[31mInvalid number of arguments"
	echo -e "\e[31mUsage: sqoop-hive-integration.sh [--p | --paramfile] 					\e[0m"
	log "ERROR: Invalid number of arguments."
	log "ERROR: Script Execution ends with an Error."
	exit 1
fi

# Include Config File
. ${PARAM_FILE}

# Function to log execution of 
log (){
	#echo "$1"
	echo "${CURR_DATE}:$1" >> ${LOGS_DIR}${LOG_FILENAME} 2>&1
}

echo ""
log "INFO: ********** Script Execution Start **********"
echo -e "\e[32m********** Script Execution Start ****************************************************************\e[0m"
echo ""

hive_hql=${ROOT_DIR}"SQL/hive_daily.hql"
source_dir=${ROOT_DIR}"Captured_feeds"

echo -e "\e[33m********** MySql Data Import Start ***************************************\e[0m"
log "INFO: MySql Data Import Start."

if [ `ls -1 ${source_dir}/*.csv 2>/dev/null | wc -l ` -gt 0 ];
then
	for i in $(ls ${source_dir}/*.csv)
	do
		file_name=`echo ${i} | awk -F'/' '{print $NF}'`
		#Load First Source data file into MySql Table
		# mysql --local-infile=1 -s -u${username} -p${password} -D${database} <<EOF
		MYSQL_PWD="${password}" mysql --local-infile=1 -s -u${username} -D${database} "$@" <<EOF
		SET GLOBAL local_infile=1;
		LOAD DATA LOCAL INFILE '${i}' INTO TABLE customer
		FIELDS TERMINATED BY ',' ENCLOSED BY '"'
		LINES TERMINATED BY '\n'
		SET filename='${file_name}',create_dt = '$(date --date="next day" "+%Y-%m-%d")';
		;
EOF
		echo "${i} File load Completed."

		file_name=`echo ${i} | awk -F'/' '{print $NF}'`
		echo "File Name:" ${file_name}
		current_time=$(date "+%Y.%m.%d-%H.%M.%S")
		mv ${i} ${source_dir}/archive/${file_name}_$(date "+%Y%m%d%H%M%S")
	done
	
	log "INFO: MySql Data Import Completed."
	echo ""
	echo -e "\e[33m********** MySql Data Import Completed *******************************\e[0m"
	echo ""
else 
	echo "Source Files does not exist...."
	echo ""
	log "INFO: Source Files does not available for processing."
	log "INFO: Stops Execution of Script."
	echo -e "\e[32m********** Stops Execution of Script ************************************************************\e[0m"
	exit 1
fi

#Execute Incremental Sqoop Job to load data into HDFS
echo -e "\e[33m********** Sqoop Job Execution Start     *********************************\e[0m"
JOBLIST=`sqoop job --list | grep "inc_customer_import_job"`

#Execute sqoop Job
sqoop job --exec inc_customer_import_job &>> ${LOGS_DIR}sqoopLogFile_${CURR_DATE}.log

if [ $? -ne 0 ]
then
	echo -e "\e[31mError while executing SQOOP Job\e[0m"
	log "ERROR: Error while executing SQOOP JOb."
	exit 1
fi
log "INFO: SQOOP Job executed Successfully."
echo ""
echo "Sqoop Job:" ${JOBLIST} " executed Successfully."
echo "" 

echo -e "\e[33m********** Sqoop Job Execution Completed *********************************\e[0m"
echo ""

#Create Hive tables into Hive Schema
echo -e "\e[33m********** Hive Execution Start ******************************************\e[0m"
hive --hivevar hive_db_name=${hive_db_name} --hivevar hive_tbl_name=${manage_tble_name} --hivevar hive_ext_tbl_name=${external_table_name} --hivevar hive_op_path=${hdfs_location}"customer_import" --hivevar hive_avaro_schema=${hdfs_location}${sqoop_tblename}".avsc" -f "${ROOT_DIR}SQL/hive_daily.hql" &> ${LOGS_DIR}hiveLogFile_${CURR_DATE}.log

if [ $? -ne 0 ]
then
	echo -e "\e[31mError while executing Hive Job\e[0m"
	log "ERROR: Error while executing Hive JOb."
	exit 1
fi
log "INFO: HIVE Job Executed Successfully."
echo "Hive Operations completed.."
echo ""
echo -e "\e[33m********** Hive Execution End ********************************************\e[0m"
echo ""

#Load Archive Table and TRUNCATE original TBL
		# mysql --local-infile=1 -s -u${username} -p${password} -D${database} <<EOF
		MYSQL_PWD="${password}" mysql --local-infile=1 -s -u${username} -D${database} "$@" <<EOF
		INSERT INTO customer_archive(custid,username,quote_count,ip,entry_time,prp_1,prp_2,prp_3,ms,http_type,purchase_category,total_count,purchase_sub_category,http_info ,status_code,filename) SELECT custid,username,quote_count,ip,entry_time,prp_1,prp_2,prp_3,ms,http_type,purchase_category,total_count,purchase_sub_category,http_info ,status_code,filename FROM customer;
EOF

log "INFO: ********** Script Execution Completed **********"
echo -e "\e[32m********** Script Execution Completed ************************************************************\e[0m"
echo ""
