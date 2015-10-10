rm $BIG_BENCH_HOME/logs/*

for qnum in {1..9}
do
	$BIG_BENCH_BASH_SCRIPT_DIR/bigBenchRunQuery.sh $qnum
done
