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
sed 's/%//g' ${TOOL}_sim_novaseq_${MODEL}_${i}_cpu_usage.txt | sort -nr | head -1 >> ${TOOL}_peak_cpu.txt
done

