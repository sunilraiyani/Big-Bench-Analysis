-- Global hive options (see: Big-Bench/setEnvVars)
set hive.exec.parallel=${env:BIG_BENCH_hive_exec_parallel};
set hive.exec.parallel.thread.number=${env:BIG_BENCH_hive_exec_parallel_thread_number};
set hive.exec.compress.intermediate=${env:BIG_BENCH_hive_exec_compress_intermediate};
set mapred.map.output.compression.codec=${env:BIG_BENCH_mapred_map_output_compression_codec};
set hive.exec.compress.output=${env:BIG_BENCH_hive_exec_compress_output};
set mapred.output.compression.codec=${env:BIG_BENCH_mapred_output_compression_codec};

--display settings
set hive.exec.parallel;
set hive.exec.parallel.thread.number;
set hive.exec.compress.intermediate;
set mapred.map.output.compression.codec;
set hive.exec.compress.output;
set mapred.output.compression.codec;

-- Database
use ${env:BIG_BENCH_HIVE_DATABASE};

DROP TABLE IF EXISTS q01result;
DROP TABLE IF EXISTS q02result;
DROP TABLE IF EXISTS q03result;
DROP TABLE IF EXISTS q04result;
DROP TABLE IF EXISTS q05result;
DROP TABLE IF EXISTS q06result;
DROP TABLE IF EXISTS q07result;
DROP TABLE IF EXISTS q08result;
DROP TABLE IF EXISTS q09result;
DROP TABLE IF EXISTS q10result;
