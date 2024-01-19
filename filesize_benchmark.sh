#!/bin/bash -
num_cpus=$(nproc)
if [ ! -d log ]; then
	mkdir log
fi
rm -rf log/*
if [ ! -d raw_file ]; then
	mkdir raw_file
fi
rm -rf raw_file/*

for filesize in 1kB 10kB 100kB 1MB 10MB 100MB 1GB
do
	echo ${filesize}
	#dd if=/dev/random of=silesia.tar bs=1k count=${filesize}
	cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c ${filesize} > silesia.tar
	ls -l silesia.tar
	mkdir -p log/${filesize}
	python3 deflatebench.py -p qzip -i 0 > log/${filesize}/qzip.log
	python3 deflatebench.py -p minigzip -i 0 > log/${filesize}/minigzip.log
	mv silesia.tar raw_file/${filesize}.txt
done
