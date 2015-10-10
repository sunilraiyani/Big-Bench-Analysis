hadoop fs -mkdir /user/hduser/benchmarks/bigbench/data
for file in `ls $BIG_BENCH_BASH_SCRIPT_DIR/output`
do
	echo $file
	hdfs dfs -rm -R $BIG_BENCH_HDFS_ABSOLUTE_DATA_DIR/$file
	hdfs dfs -mkdir $BIG_BENCH_HDFS_ABSOLUTE_DATA_DIR/$file
	hdfs dfs -copyFromLocal $BIG_BENCH_BASH_SCRIPT_DIR/output/$file $BIG_BENCH_HDFS_ABSOLUTE_DATA_DIR/$file/$file
	rm $BIG_BENCH_BASH_SCRIPT_DIR/output/$file
done
hdfs dfs -ls $BIG_BENCH_HDFS_ABSOLUTE_DATA_DIR
