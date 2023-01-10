#!/bin/bash
THREADSTART=$1
THREADEND=$2
INC=$3
INTERLEAVED=$4
OUTPUT=$5
if [ "$1" == "-h" ]; then
  echo "Usage: ./run_mitobim_docker.sh 2 16 2 test_interleaved.fastq test"
  echo "Aruguments in order"
  echo "1:Thread count start"
  echo "2:Thread count end"
  echo "3:Thread count increment"
  echo "4:interleaved file"
  echo "6:output directory name"
  exit 0
fi
for (( i = THREADSTART; i <= THREADEND; i=i*INC ));
do
date +"[%Y-%m-%d %H:%M:%S] Starting container using command : chrishah/mitobim:latest"
/usr/bin/time -f "\t%E real, \t%U user, \t%S sys" -o mitobim_${OUTPUT}_${i}.txt docker run -v $PWD:$PWD --name mitobim_${i} --cpus ${i} --workdir $PWD --rm chrishah/mitobim:latest MITObim.pl -start 1 -end 10 -sample ${OUTPUT} -ref reference-mt -readpool ${INTERLEAVED} -quick Homo_sapiens_chrM.fasta --clean &
while true 
do
	DOCKERID=$(docker ps --format '{{.ID}}')
	if [ -z "$DOCKERID" ];then
	 echo "Not running"
	else
	docker stats --no-stream | grep mitobim_${i} | awk '{print $4}' >> mitobim_${OUTPUT}_${i}_mem_usage.txt &  docker stats --no-stream | grep mitobim_${i} | awk '{print $3}' >> mitobim_${OUTPUT}_${i}_cpu_usage.txt &  docker stats --no-stream | grep mitobim_${i} | awk '{print $7}' >> mitobim_${OUTPUT}_${i}_peak_mem.txt;
	docker ps --no-trunc | grep "${DOCKERID}" >/dev/null;
		if [ $? -ne 0 ];then
		mkdir mitobim_${OUTPUT}_${i} &&
		mv iteration* mitobim_${OUTPUT}_${i} &&
		break
		fi
	fi
done
date +"[%Y-%m-%d %H:%M:%S] Finished benchmark"
done
