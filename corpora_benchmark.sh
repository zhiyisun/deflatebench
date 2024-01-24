#!/bin/bash -
num_cpus=$(nproc)
if [ ! -d log ]; then
	mkdir log
fi
rm -rf log/*

if [ ! -f calgarycorpus.zip ]; then
	wget http://www.data-compression.info/files/corpora/calgarycorpus.zip
fi

if [ ! -f canterburycorpus.zip ]; then
	wget http://www.data-compression.info/files/corpora/canterburycorpus.zip
fi

if [ ! -f silesia.zip ]; then
	wget http://sun.aei.polsl.pl/~sdeor/corpus/silesia.zip
fi

if [ ! -d raw_file ]; then
	mkdir raw_file
fi
rm -rf raw_file/*
unzip calgarycorpus.zip -d raw_file/
unzip canterburycorpus.zip -d raw_file/
unzip silesia.zip -d raw_file/
wget -P raw_file/ https://mirror.circlestorm.org/silesia.tar
tar cf raw_file/128M.tar raw_file/mozilla raw_file/webster raw_file/nci raw_file/sao raw_file/book1

for file in grammar.lsp fields.c geo kennedy.xls osdb mozilla 128M.tar silesia.tar
do
	echo ${file}
	cp raw_file/${file} silesia.tar
	mkdir -p log/${file}
	python3 deflatebench.py -p minigzip -i 0 > log/${file}/minigzip.log
done

sleep 5

for file in grammar.lsp fields.c geo kennedy.xls osdb mozilla 128M.tar silesia.tar
do
	echo ${file}
	cp raw_file/${file} silesia.tar
	mkdir -p log/${file}
	python3 deflatebench.py -p qzip -i 0 > log/${file}/qzip.log
done
