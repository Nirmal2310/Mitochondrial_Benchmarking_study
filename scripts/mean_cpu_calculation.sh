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
awk '{ sum += $1; n++ } END { if (n > 0) print sum / n; }' ${TOOL}_sim_novaseq_${MODEL}_${i}_cpu_usage.txt >> ${TOOL}_cpu.txt
done

