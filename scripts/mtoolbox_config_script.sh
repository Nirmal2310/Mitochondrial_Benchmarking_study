#!/bin/bash
PATH=$1
OUTPUT=$2
cat > $OUTPUT.conf <<EOF
#!/bin/bash

mtdb_fasta=chrM.fa
hg19_fasta=hg19RCRS.fa
mtdb=chrM
humandb=hg19RCRS
input_path=$PATH
output_name=$PATH/$OUTPUT/
list=$PATH/$OUTPUT.lst
input_type=fastq
ref=RCRS
vcf_name=$OUTPUT
EOF
