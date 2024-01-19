#!/bin/bash -
num_cpus=$(nproc)
if [ ! -d log ]; then
	mkdir log
fi
rm -rf log/*

if [ -f silesia.tar ]; then
	rm silesia.tar
fi
wget https://mirror.circlestorm.org/silesia.tar

for tool in qzip minigzip
do
	for threads in 1 4 8 16 32
	do
		echo ${tool} ${threads} "thread(s):"
		mkdir -p log/${threads}
		for i in $(seq 1 ${threads})
		do 
			cpu_id=$((${i} % ${num_cpus}))
			taskset -c ${cpu_id} python3 deflatebench.py -p ${tool} -i ${i} > log/${threads}/${tool}_${i}.log &
		done
		while true; do
			sleep 5
			if pgrep -f "deflatebench.py" > /dev/null; then
				continue
			else
				break
			fi
		done
	done
done
