#!/bin/bash
P=$1
TOOL=$2
MODEL=$3
THREADSTART=$4
THREADEND=$5
INC=$6
cd $P
for (( i = THREADSTART; i <= THREADEND; i=i*INC ));
do
sed 's/MiB/ MiB/g' ${TOOL}_sim_novaseq_${MODEL}_${i}_mem_usage.txt | awk -F " " '{if($2=="MiB") $1=$1/1024; print $1}' | sort -nr | head -1 >> ${TOOL}_peak_mem.txt
done

