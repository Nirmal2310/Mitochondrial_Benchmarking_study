#!/bin/bash
sample=$1
tool=$2
chrMT=$3
path=$(which conda | sed "s/\b\/conda\b//g")
source $path/activate mummer
nucmer --prefix=${sample}_${tool} $chrMT ${tool}_${sample}.fasta
show-snps -ClrT ${sample}_${tool}.delta >  ${tool}_${sample}.snps
all2vcf mummer --snps ${tool}_${sample}.snps --reference $chrMT --type SNP --input-header --output-header > ${tool}_${sample}_mummer.vcf
bgzip ${tool}_${sample}_mummer.vcf && bcftools index ${tool}_${sample}_mummer.vcf.gz 
source $path/activate bedtools
bedtools merge -i ${tool}_${sample}_mummer.vcf.gz > ${tool}_${sample}_mummer.bed