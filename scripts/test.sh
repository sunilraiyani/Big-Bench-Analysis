$BIG_BENCH_BASH_SCRIPT_DIR/bigBenchRun.sh
showTimes.sh > /home/hduser/nfs/Big-Bench/results4datanodes/out1g.txt
hdfs dfsadmin -report > /home/hduser/nfs/Big-Bench/results4datanodes/report1g.txt
showErrors.sh > /home/hduser/nfs/Big-Bench/results4datanodes/err1g.txt

$BIG_BENCH_BASH_SCRIPT_DIR/bigBenchRun.sh 5
showTimes.sh > /home/hduser/nfs/Big-Bench/results4datanodes/out5g.txt
hdfs dfsadmin -report > /home/hduser/nfs/Big-Bench/results4datanodes/report5g.txt
showErrors.sh > /home/hduser/nfs/Big-Bench/results4datanodes/err5g.txt

$BIG_BENCH_BASH_SCRIPT_DIR/bigBenchRun.sh 10
showTimes.sh > /home/hduser/nfs/Big-Bench/results4datanodes/out10g.txt
hdfs dfsadmin -report > /home/hduser/nfs/Big-Bench/results4datanodes/report10g.txt
showErrors.sh > /home/hduser/nfs/Big-Bench/results4datanodes/err10g.txt

$BIG_BENCH_BASH_SCRIPT_DIR/bigBenchRun.sh 40
showTimes.sh > /home/hduser/nfs/Big-Bench/results4datanodes/out40g.txt
hdfs dfsadmin -report > /home/hduser/nfs/Big-Bench/results4datanodes/report40g.txt
showErrors.sh > /home/hduser/nfs/Big-Bench/results4datanodes/err40g.txt


