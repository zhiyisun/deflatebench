#!/bin/bash -x
if [ ! -d log ]; then
	mkdir log
fi
rm -rf log/*
for i in {1..8} 
do 
	python3 deflatebench.py -l /usr/local/bin/qzip -i ${i} > log/zip_${i}.log &
done
cat log/zip*.log | grep tot
