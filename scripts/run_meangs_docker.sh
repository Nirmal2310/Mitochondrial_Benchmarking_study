#!/bin/bash
THREADSTART=$1
THREADEND=$2
INC=$3
FORWARD=$4
REVERSE=$5
OUTPUT=$6
if [ "$1" == "-h" ]; then
  echo "Usage: ./run_meangs_docker.sh 2 16 2 test.R1.fq test.R2.fq test 126"
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
date +"[%Y-%m-%d %H:%M:%S] Starting container using command : bioinfodocker/meangs:latest"
/usr/bin/time -f "\t%E real, \t%U user, \t%S sys" -o meangs_${OUTPUT}_${i}.txt docker run -v $PWD:/home/meangs --name meangs_${i} -w /home/meangs --cpus ${i} --rm bioinfodocker/meangs:latest meangs.py -1 ${FORWARD} -2 ${REVERSE} -t ${i} -o meangs_${OUTPUT}_${i} -i 300 --deepin &

while true 
do
	DOCKERID=$(docker ps --format '{{.ID}}')
	if [ -z "$DOCKERID" ];then
	 echo "Not running"
	else
	docker stats --no-stream | grep meangs_${i} | awk '{print $4}' >> meangs_${OUTPUT}_${i}_mem_usage.txt &  docker stats --no-stream | grep meangs_${i} | awk '{print $3}' >> meangs_${OUTPUT}_${i}_cpu_usage.txt &  docker stats --no-stream | grep meangs_${i} | awk '{print $7}' >> meangs_${OUTPUT}_${i}_peak_mem.txt;
	docker ps --no-trunc | grep "${DOCKERID}" >/dev/null;
		if [ $? -ne 0 ];then
		break
		fi
	fi
done
date +"[%Y-%m-%d %H:%M:%S] Finished benchmark"
done
