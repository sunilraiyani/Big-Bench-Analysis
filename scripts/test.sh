$BIG_BENCH_BASH_SCRIPT_DIR/bigBenchRun.sh 100
showTimes.sh > /home/hduser/nfs/Big-Bench/results4datanodes/out100g.txt
hdfs dfsadmin -report > /home/hduser/nfs/Big-Bench/results4datanodes/report100g.txt
showErrors.sh > /home/hduser/nfs/Big-Bench/results4datanodes/err100g.txt


