#!/bin/bash
sample=$1
reference=$2
chrMT=$3
path=$(which conda | sed "s/\b\/conda\b//g")
source $path/activate bwa
bwa index $reference
bwa mem -t 16 $reference $sample.R1.fastq $sample.R2.fastq | samtools view -@ 16 -bS | samtools sort -@ 16 -o ${sample}_sorted.bam
samtools index ${sample}_sorted.bam
mutserve call --reference $chrMT --output ${sample}_mutserve.vcf.gz --threads 16 ${sample}_sorted.bam
source $path/activate bedtools
bedtools merge -i ${sample}_mutserve.vcf.gz > ${sample}_mutserve.bed
