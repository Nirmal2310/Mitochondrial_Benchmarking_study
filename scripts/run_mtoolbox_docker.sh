#!/bin/bash
THREADSTART=$1
THREADEND=$2
INC=$3
OUTPUT=$4
if [ "$1" == "-h" ]; then
  echo "Usage: ./run_mtoolbox_docker.sh 2 16 2 test.conf"
  echo "Aruguments in order"
  echo "1:Thread count start"
  echo "2:Thread count end"
  echo "3:Thread count increment"
  echo "4:config file"
  exit 0
fi
for (( i = THREADSTART; i <= THREADEND; i=i*INC ));
do
date +"[%Y-%m-%d %H:%M:%S] Starting container using command : mtoolbox:latest"
/usr/bin/time -o mtoolbox_${OUTPUT}_${i}.txt docker run -v $PWD:$PWD --name mtoolbox_${i} --workdir $PWD --cpus ${i} --rm mtoolbox:latest /data/Nirmal_analysis/docker/MToolBox/MToolBox/MToolBox.sh -i ${OUTPUT}.conf -m "-t ${i}" -a "-t ${i}" &
while true 
do
	DOCKERID=$(docker ps --format '{{.ID}}')
	if [ -z "$DOCKERID" ];then
	 echo "Not running"
	else
	docker stats --no-stream | grep mtoolbox_${i} | awk '{print $4}' >> mtoolbox_${OUTPUT}_${i}_mem_usage.txt &  docker stats --no-stream | grep mtoolbox_${i} | awk '{print $3}' >> mtoolbox_${OUTPUT}_${i}_cpu_usage.txt &  docker stats --no-stream | grep mtoolbox_${i} | awk '{print $7}' >> mtoolbox_${OUTPUT}_${i}_peak_mem.txt;
	docker ps --no-trunc | grep "${DOCKERID}" >/dev/null;
		if [ $? -ne 0 ];then
		mv mtoolbox_${OUTPUT} mtoolbox_${OUTPUT}_${i} && 
		break
		fi
	fi
done
date +"[%Y-%m-%d %H:%M:%S] Finished benchmark"
done
