#!/usr/bin/env bash

if [ $# -lt 1 ]
then
	echo "parameter missing"
	echo "usage: <queryNumber e.g.: q01>  <(optional)hive params e.g.: --auxpath>"
	exit 1
fi

QUERY_NUM="$1"
FILENAME="${BIG_BENCH_QUERIES_DIR}/${QUERY_NUM}/${QUERY_NUM}.sql"

if [ -f "$FILENAME" ]
then
	hive $2 -f "$FILENAME"
	echo "======= $QUERY_NUM  result ======="
	echo "results in : ${BIG_BENCH_HDFS_ABSOLUTE_QUERY_RESULT_DIR}/${QUERY_NUM}result"
	echo "to display : hadoop fs -cat ${BIG_BENCH_HDFS_ABSOLUTE_QUERY_RESULT_DIR}/${QUERY_NUM}result/*"
	echo "========================="
else
	echo "$FILENAME does not exist"
fi
