
for file in `ls $BIG_BENCH_BASH_SCRIPT_DIR/output`
do
	a=`echo $file | cut -d '.' -f 1`
	mv $BIG_BENCH_BASH_SCRIPT_DIR/output/$file $BIG_BENCH_BASH_SCRIPT_DIR/output/$a
	echo $a
done
