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
awk 'NR==1{print $3}' ${TOOL}_sim_novaseq_${MODEL}_${i}.txt | sed 's/[.].*$//' > ${TOOL}_tmp
cat ${TOOL}_tmp | awk -F : '{if(NF==2) {print ($1*60)+ $2} else if(NF==3){print ($1 * 3600) + ($2 * 60) + $3}}' >> ${TOOL}_time.txt
done

