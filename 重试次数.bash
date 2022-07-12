fucntion try_to_redo{
	local do_work = "$1"
	local wait_time = "$2"
	local retry_times = "$3"
	
	$do_work
	local status = $?
	while ((status!=0&&retry_times>0));
	do
	LOG "任务[$do_work]执行失败,等待$wait_time..."
	sleep $wait_time
	$do_work
	status=$?
	((retry_times--))
	LOG "剩余重试次数$retry_times"
	done
	return $status


}