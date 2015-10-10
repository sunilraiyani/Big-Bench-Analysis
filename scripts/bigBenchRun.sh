## Create BigBench directories
hadoop fs -mkdir -p /user/hduser/benchmarks/bigbench/data
hadoop fs -mkdir -p /user/hive/warehouse/bigbenchorc.db

## Remove the previously generated data
if [ -f $BIG_BENCH_BASH_SCRIPT_DIR/output ]
then
	rm -R $BIG_BENCH_BASH_SCRIPT_DIR/output
fi

## Create output folder
mkdir $BIG_BENCH_BASH_SCRIPT_DIR/output

## Generate the data at local node
if [ $# = 1 ]
then
	$BIG_BENCH_BASH_SCRIPT_DIR/bigBenchLocalDataGen.sh -sf $1 
else
	$BIG_BENCH_BASH_SCRIPT_DIR/bigBenchLocalDataGen.sh
fi

## Remove the extensions in the output directory
$BIG_BENCH_BASH_SCRIPT_DIR/rename_tables.sh

## Load data onto the cluster
$BIG_BENCH_BASH_SCRIPT_DIR/load_tables.sh

## Populate the hive tables
$BIG_BENCH_HIVE_SCRIPT_DIR/create_load.sh

## Remove the output folder
rm -R $BIG_BENCH_BASH_SCRIPT_DIR/output

## Run all queries
$BIG_BENCH_BASH_SCRIPT_DIR/runTest.sh
