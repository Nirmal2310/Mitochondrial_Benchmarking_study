#!/bin/bash
THREADSTART=$1
THREADEND=$2
INC=$3
FORWARD=$4
REVERSE=$5
OUTPUT=$6
if [ "$1" == "-h" ]; then
  echo "Usage: ./run_getorganelle_docker.sh 2 16 2 test.R1.fq test.R2.fq test"
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
date +"[%Y-%m-%d %H:%M:%S] Starting container using command : getorganelle:latest"
/usr/bin/time -f "\t%E real, \t%U user, \t%S sys" -o getorganelle_${OUTPUT}_${i}.txt docker run -v $PWD:$PWD --name getorganelle_${i} --cpus ${i} --workdir $PWD --rm getorganelle:latest get_organelle_from_reads.py -1 ${FORWARD} -2 ${REVERSE} -o getorganelle_${OUTPUT}_${i} -t ${i} -F animal_mt &
while true 
do
	DOCKERID=$(docker ps --format '{{.ID}}')
	if [ -z "$DOCKERID" ];then
	 echo "Not running"
	else
	docker stats --no-stream | grep getorganelle_${i} | awk '{print $4}' >> getorganelle_${OUTPUT}_${i}_mem_usage.txt &  docker stats --no-stream | grep getorganelle_${i} | awk '{print $3}' >> getorganelle_${OUTPUT}_${i}_cpu_usage.txt &  docker stats --no-stream | grep getorganelle_${i} | awk '{print $7}' >> getorganelle_${OUTPUT}_${i}_peak_mem.txt;
	docker ps --no-trunc | grep "${DOCKERID}" >/dev/null;
		if [ $? -ne 0 ];then
		break
		fi
	fi
done
date +"[%Y-%m-%d %H:%M:%S] Finished benchmark"
done
