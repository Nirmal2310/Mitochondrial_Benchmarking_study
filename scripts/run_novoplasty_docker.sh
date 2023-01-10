#!/bin/bash
THREADSTART=$1
THREADEND=$2
INC=$3
config=$4
OUTPUT=$5
if [ "$1" == "-h" ]; then
  echo "Usage: ./run_novoplasty_docker.sh 2 16 2 config.txt test"
  echo "Aruguments in order"
  echo "1:Thread count start"
  echo "2:Thread count end"
  echo "3:Thread count increment"
  echo "4:config file"
  echo "5:output directory name"
  exit 0
fi
for (( i = THREADSTART; i <= THREADEND; i=i*INC ));
do
date +"[%Y-%m-%d %H:%M:%S] Starting container using command : novoplasty:latest"
/usr/bin/time -f "\t%E real, \t%U user, \t%S sys" -o novoplasty_${OUTPUT}_${i}.txt docker run -v $PWD:$PWD --name novoplasty_${i} --cpus ${i} --workdir $PWD --rm novoplasty:latest NOVOPlasty4.3.1.pl -c ${config} &
while true
do
	DOCKERID=$(docker ps --format '{{.ID}}')
	if [ -z "$DOCKERID" ];then
	 echo "Not running"
	else
	docker stats --no-stream | grep novoplasty_${i} | awk '{print $4}' >> novoplasty_${OUTPUT}_${i}_mem_usage.txt &  docker stats --no-stream | grep novoplasty_${i} | awk '{print $3}' >> novoplasty_${OUTPUT}_${i}_cpu_usage.txt &  docker stats --no-stream | grep novoplasty_${i} | awk '{print $7}' >> novoplasty_${OUTPUT}_${i}_peak_mem.txt;
	docker ps --no-trunc | grep "${DOCKERID}" >/dev/null;
		if [ $? -ne 0 ];then
		mkdir novoplasty_${OUTPUT}_${i} &&
		mv ${OUTPUT}Contigs_1_NOVOPlasty.fasta novoplasty_${OUTPUT}_${i}.fasta && 
		mv novoplasty_${OUTPUT}_${i}.fasta ${OUTPUT}contigs_tmp_NOVOPlasty.txt ${OUTPUT}log_NOVOPlasty.txt novoplasty_${OUTPUT}_${i}/
		break
		fi
	fi
done
date +"[%Y-%m-%d %H:%M:%S] Finished benchmark"
done
