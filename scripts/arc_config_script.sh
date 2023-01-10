#!/bin/bash
THREAD=$1
FORWARD=$2
REVERSE=$3
OUTPUT=$4
cat >${OUTPUT}_${THREAD}_Arc_config.txt <<EOF
## Configuration options start with a single "#" and use
## Name=value pairs
##
## Data Columns define samples:
## Sample_ID:Sample_ID
## FileName: path for fasta/fastq file
## FileType: PE1, PE2, or SE
## FileFormat: fasta or fastq
# reference=Homo_sapiens_chrM.fasta
# numcycles=10
# mapper=bowtie2
# assembler=spades
# only-assembler=False
# nprocs=$THREAD
# format=fastq
# verbose=True
# urt=True
# map_against_reads=False
# assemblytimeout=180
# bowtie2_k=5
# rip=True
# subsample=1
# maskrepeats=True
# sloppymapping=True
# sra=False
Sample_ID	FileName        FileType
Sample1 $FORWARD        PE1
Sample1 $REVERSE        PE2
EOF
