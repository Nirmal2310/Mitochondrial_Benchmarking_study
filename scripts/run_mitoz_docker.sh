#!/bin/bash
THREADSTART=$1
THREADEND=$2
INC=$3
FORWARD=$4
REVERSE=$5
OUTPUT=$6
if [ "$1" == "-h" ]; then
  echo "Usage: ./run_mitoz_docker.sh 2 16 2 test.R1.fq test.R2.fq test 126"
  echo "Aruguments in order"
  echo "1:Thread count start"
  echo "2:Thread count end"
  echo "3:Thread count increment"
  echo "4:forward read name"
  echo "5:reverse read name"
  echo "6:output directory name"
  echo "7:Read length"
  exit 0
fi
for (( i = THREADSTART; i <= THREADEND; i=i*INC ));
do
DOCKERCMD="time -o mitoz_${OUTPUT}_${i}.txt docker run -v $PWD:$PWD --name mitoz_${i} --cpus ${i} --workdir $PWD --rm guanliangmeng/mitoz:2.3 python3 /app/release_MitoZ_v2.3/MitoZ.py all --genetic_code 2 --clade Chordata --insert_size 300 --thread_number ${i} --fastq1 ${FORWARD} --fastq2 ${REVERSE} --outprefix mitoz_${OUTPUT}_${i} --fastq_read_length 151"
date +"[%Y-%m-%d %H:%M:%S] Starting container using command : guanliangmeng/mitoz:2.3"
$DOCKERCMD &
while true 
do
	DOCKERID=$(docker ps --format '{{.ID}}')
	if [ -z "$DOCKERID" ];then
	 echo "Not running"
	else
	docker stats --no-stream | grep mitoz_${i} | awk '{print $4}' >> mitoz_${OUTPUT}_${i}_mem_usage.txt &  docker stats --no-stream | grep mitoz_${i} | awk '{print $3}' >> mitoz_${OUTPUT}_${i}_cpu_usage.txt &  docker stats --no-stream | grep mitoz_${i} | awk '{print $7}' >> mitoz_${OUTPUT}_${i}_peak_mem.txt;
	docker ps --no-trunc | grep "${DOCKERID}" >/dev/null;
		if [ $? -ne 0 ];then
		rm -r tmp/ &&
		break
		fi
	fi
done
date +"[%Y-%m-%d %H:%M:%S] Finished benchmark"
done
