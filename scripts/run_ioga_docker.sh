#!/bin/bash
THREADSTART=$1
THREADEND=$2
INC=$3
FORWARD=$4
REVERSE=$5
OUTPUT=$6
if [ "$1" == "-h" ]; then
  echo "Usage: ./run_ioga_docker.sh 2 16 2 test.R1.fq test.R2.fq test"
  echo "Aruguments in order"
  echo "1:Thread count start"
  echo "2:Thread count end"
  echo "3:Thread count increment"
  echo "4:forward read name"
  echo "5:reverse read name"
  echo "6:output directory name"
  exit 0
fi
for (( i = THREADSTART; i <= THREADEND; i=i*INC ));
do
date +"[%Y-%m-%d %H:%M:%S] Starting container using command : ioga:latest"
/usr/bin/time -f "\t%E real, \t%U user, \t%S sys" -o ioga_${OUTPUT}_${i}.txt docker run -v $PWD:$PWD --name ioga_${i} --workdir $PWD --cpus ${i} --rm ioga:latest IOGA.py -1 ${FORWARD} -2 ${REVERSE} -t ${i} -n ioga_${OUTPUT}_$i -r Homo_sapiens_chrM.fasta -i 300 &
while true 
do
	DOCKERID=$(docker ps --format '{{.ID}}')
	if [ -z "$DOCKERID" ];then
	 echo "Not running"
	else
	docker stats --no-stream | grep ioga_${i} | awk '{print $4}' >> ioga_${OUTPUT}_${i}_mem_usage.txt &  docker stats --no-stream | grep ioga_${i} | awk '{print $3}' >> ioga_${OUTPUT}_${i}_cpu_usage.txt &  docker stats --no-stream | grep ioga_${i} | awk '{print $7}' >> ioga_${OUTPUT}_${i}_peak_mem.txt;
	docker ps --no-trunc | grep "${DOCKERID}" >/dev/null;
		if [ $? -ne 0 ];then
		break
		fi
	fi
done
date +"[%Y-%m-%d %H:%M:%S] Finished benchmark"
done
