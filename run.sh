#!/bin/bash -
num_cpus=$(nproc)
if [ ! -d log ]; then
	mkdir log
fi
rm -rf log/*
for threads in 1 4 8 16 32 64 96
do
	mkdir -p log/${threads}
	for i in $(seq 1 ${threads})
	do 
		cpu_id=$((${i} % ${num_cpus}))
		#taskset -c ${cpu_id} python3 deflatebench.py -l /usr/local/bin/qzip -i ${i} > log/${threads}/zip_${i}.log &
		taskset -c ${cpu_id} python3 deflatebench.py -l /root/zlib-ng/minigzip -i ${i} > log/${threads}/zip_${i}.log &
	done
	while true; do
		sleep 5
		if pgrep -f "deflatebench.py" > /dev/null; then
			continue
		else
			break
		fi
	done
	echo ${threads} "threads: " >> log/zip.log
	cat log/${threads}/zip*.log | grep tot >> log/zip.log
done
