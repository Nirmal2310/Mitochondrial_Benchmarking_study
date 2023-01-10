#!/bin/bash
THREADSTART=$1
THREADEND=$2
INC=$3
OUTPUT=$4
if [ "$1" == "-h" ]; then
  echo "Usage: ./run_arc_docker.sh 2 16 2 test"
  echo "Aruguments in order"
  echo "1:Thread count start"
  echo "2:Thread count end"
  echo "3:Thread count increment"
  echo "4:output directory name"
  exit 0
fi
for (( i = THREADSTART; i <= THREADEND; i=i*INC ));
do
date +"[%Y-%m-%d %H:%M:%S] Starting container using command : arc:latest"
/usr/bin/time -f "\t%E real, \t%U user, \t%S sys" -o arc_${OUTPUT}_${i}.txt docker run -v $PWD:$PWD --cpus ${i} --name arc_${i} --workdir $PWD --rm arc:latest ARC -c ${OUTPUT}_${i}_Arc_config.txt &
while true 
do
	DOCKERID=$(docker ps --format '{{.ID}}')
	if [ -z "$DOCKERID" ];then
	 echo "Not running"
	else
	docker stats --no-stream | grep arc_${i} | awk '{print $4}' >> arc_${OUTPUT}_${i}_mem_usage.txt &  docker stats --no-stream | grep arc_${i} | awk '{print $3}' >> arc_${OUTPUT}_${i}_cpu_usage.txt &  docker stats --no-stream | grep arc_${i} | awk '{print $7}' >> arc_${OUTPUT}_${i}_peak_mem.txt;
	docker ps --no-trunc | grep "${DOCKERID}" >/dev/null;
		if [ $? -ne 0 ];then
		mv finished_Sample1 arc_${OUTPUT}_${i} &&
		rm -r working_Sample1 &&
		break
		fi
	fi
done
date +"[%Y-%m-%d %H:%M:%S] Finished benchmark"
done
