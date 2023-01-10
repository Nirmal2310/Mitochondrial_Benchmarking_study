#!/bin/bash
FORWARD=$1
REVERSE=$2
OUTPUT=$3
cat > ${OUTPUT}_config.txt <<EOF
Project:
-----------------------
Project name          = NOVOPlasty
Type                  = mito
Genome Range          = 12000-80000
K-mer                 = 33
Max memory            =
Extended log          = 0
Save assembled reads  = no
Seed Input            = Homo_sapiens_chrM.fasta
Reference sequence    =
Variance detection    =
Heteroplasmy          =
HP exclude list       =
Chloroplast sequence  =

Dataset 1:
-----------------------
Read Length           = 151
Insert size           = 300
Platform              = illumina
Single/Paired         = PE
Combined reads        =
Forward reads         = $FORWARD
Reverse reads         = $REVERSE

Heteroplasmy:
-----------------------
MAF                   =
HP exclude list       =
PCR-free              = yes

Optional:
-----------------------
Insert size auto      = yes
Use Quality Scores    = no
Output path	      = ${OUTPUT}
EOF
