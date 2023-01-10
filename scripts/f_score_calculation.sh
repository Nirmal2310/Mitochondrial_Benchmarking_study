#!/bin/bash
sample=$1
tool=$2
path=$(which conda | sed "s/\b\/conda\b//g")
source $path/activate bedtools
TP=$(bedtools intersect -u -a ${sample}_mutserve.bed -b ${tool}_${sample}_mummer.bed | wc -l)
ACTUAL=$(wc -l < ${sample}_mutserve.bed)
CALLED=$(wc -l < ${tool}_${sample}_mummer.bed)
FP=`bc -l <<< $CALLED-$TP`
FN=`bc -l <<< $ACTUAL-$TP`
PRECISION=`echo $(($TP/$CALLED))`
RECALL=`bc -l <<< $TP/$ACTUAL`
F_SCORE=`echo "(2*($PRECISION*$RECALL)/($PRECISION+$RECALL))" | bc -l`
echo "${F_SCORE}" >> F1_score.txt
