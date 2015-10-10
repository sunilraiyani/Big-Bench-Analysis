-- Global hive options (see: Big-Bench/setEnvVars)
--set hive.exec.parallel=${env:BIG_BENCH_hive_exec_parallel};
--set hive.exec.parallel.thread.number=${env:BIG_BENCH_hive_exec_parallel_thread_number};
--set hive.exec.compress.intermediate=${env:BIG_BENCH_hive_exec_compress_intermediate};
--set mapred.map.output.compression.codec=${env:BIG_BENCH_mapred_map_output_compression_codec};
--set hive.exec.compress.output=${env:BIG_BENCH_hive_exec_compress_output};
--set mapred.output.compression.codec=${env:BIG_BENCH_mapred_output_compression_codec};
--set hive.default.fileformat=${env:BIG_BENCH_hive_default_fileformat};
--set hive.optimize.mapjoin.mapreduce=${env:BIG_BENCH_hive_optimize_mapjoin_mapreduce};
--set hive.optimize.bucketmapjoin=${env:BIG_BENCH_hive_optimize_bucketmapjoin};
--set hive.optimize.bucketmapjoin.sortedmerge=${env:BIG_BENCH_hive_optimize_bucketmapjoin_sortedmerge};
--set hive.auto.convert.join=${env:BIG_BENCH_hive_auto_convert_join};
--set hive.auto.convert.sortmerge.join=${env:BIG_BENCH_hive_auto_convert_sortmerge_join};
--set hive.auto.convert.sortmerge.join.noconditionaltask=${env:BIG_BENCH_hive_auto_convert_sortmerge_join_noconditionaltask};
--set hive.optimize.ppd=${env:BIG_BENCH_hive_optimize_ppd};
--set hive.optimize.index.filter=${env:BIG_BENCH_hive_optimize_index_filter};

--display settings
set hive.exec.parallel;
set hive.exec.parallel.thread.number;
set hive.exec.compress.intermediate;
set mapred.map.output.compression.codec;
set hive.exec.compress.output;
set mapred.output.compression.codec;
set hive.default.fileformat;
set hive.optimize.mapjoin.mapreduce;
set hive.mapjoin.smalltable.filesize;
set hive.optimize.bucketmapjoin;
set hive.optimize.bucketmapjoin.sortedmerge;
set hive.auto.convert.join;
set hive.auto.convert.sortmerge.join;
set hive.auto.convert.sortmerge.join.noconditionaltask;
set hive.optimize.ppd;
set hive.optimize.index.filter;

-- Database
use ${env:BIG_BENCH_HIVE_DATABASE};

-- Resources
ADD FILE ${env:BIG_BENCH_QUERIES_DIR}/q02/q2_reducer.py;

-- Result file configuration
set QUERY_NUM=q02;
set resultTableName=${hiveconf:QUERY_NUM}result;
set resultFile=${env:BIG_BENCH_HDFS_ABSOLUTE_QUERY_RESULT_DIR}/${hiveconf:resultTableName};

--For online sales, compare the total sales in which customers checked
--online reviews before making the purchase and that of sales in which customers
--did not read reviews. Consider only online sales for a specific category in a given
--year.

--PART 1 - sales that users have viewed the review pages--------------------------------------------------------
DROP TABLE if EXISTS q02_tmp_sales_review;
CREATE TABLE if not exists q02_tmp_sales_review AS 
 SELECT DISTINCT q02_nPath.s_sk AS s_sk
	FROM (
		FROM (	
			
			SELECT 	c.wcs_user_sk 		AS uid, 
				c.wcs_click_date_sk 	AS c_date, 
				c.wcs_click_time_sk 	AS c_time, 
				c.wcs_sales_sk 		AS sales_sk, 
				w.wp_type 		AS wpt
			FROM web_clickstreams c 
			INNER JOIN web_page w 	ON c.wcs_web_page_sk = w.wp_web_page_sk 
						AND c.wcs_user_sk is not null

			CLUSTER BY uid
        	) q02_map_output
		REDUCE 	q02_map_output.uid, 
			q02_map_output.c_date, 
			q02_map_output.c_time, 
			q02_map_output.sales_sk, 
			q02_map_output.wpt
		-- select category: 'review'
		USING 'python q2_reducer.py'
		AS (s_date BIGINT, s_sk BIGINT)
	) q02_nPath
	--s_date between 1999-09-02 and 2000-09-02
	where q02_nPath.s_date > 36403 and q02_nPath.s_date <36403+365
;

--PART 2 - helper table: sales within one year starting 1999-09-02  ---------------------------------------
DROP TABLE if EXISTS q02_tmp_webSales_date;
CREATE TABLE IF NOT EXISTS q02_tmp_webSales_date AS 
SELECT ws_net_paid, ws_order_number
FROM web_sales ws
where ws.ws_sold_date_sk > 36403 and ws.ws_sold_date_sk <36403+365
;

--PART 3 - for sales in given year, compute  sales in which customers checked online reviews vs. sales in which customers did not read reviews.
--Result  --------------------------------------------------------------------		
--keep result human readable
set hive.exec.compress.output=false;
set hive.exec.compress.output;	
--CREATE RESULT TABLE. Store query result externally in output_dir/qXXresult/
DROP TABLE IF EXISTS ${hiveconf:resultTableName};
CREATE TABLE ${hiveconf:resultTableName}
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
STORED AS ${env:BIG_BENCH_hive_default_fileformat_result_table} LOCATION '${hiveconf:resultFile}' 
AS

-- the real query part----------------------------------------------------------------------
SELECT 	q02_review_sales.amount 			AS q02_review_sales_amount,
	q02_all_sales.amount - q02_review_sales.amount  AS no_q02_review_sales_amount
FROM	(
	SELECT 1 AS id, sum (ws_net_paid) as amount 
	FROM q02_tmp_webSales_date ws
	INNER JOIN q02_tmp_sales_review sr ON ws.ws_order_number = sr.s_sk
) q02_review_sales

JOIN (
	SELECT 1 AS id, sum (ws_net_paid) as amount
	FROM q02_tmp_webSales_date ws
	
)  q02_all_sales 
ON q02_review_sales.id =  q02_all_sales.id
;



--cleanup-------------------------------------------------------------------
DROP TABLE if EXISTS q02_tmp_sales_review;
DROP TABLE if EXISTS q02_tmp_webSales_date;


