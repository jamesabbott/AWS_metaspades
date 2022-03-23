#!/bin/env bash

set -e

fastq_paths=(
	'ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR538/000/ERR5385020/ERR5385020_1.fastq.gz'
	'ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR538/000/ERR5385020/ERR5385020_2.fastq.gz'
	'ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR538/001/ERR5385021/ERR5385021_1.fastq.gz'
	'ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR538/001/ERR5385021/ERR5385021_2.fastq.gz'
	'ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR538/002/ERR5385022/ERR5385022_1.fastq.gz'
	'ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR538/002/ERR5385022/ERR5385022_2.fastq.gz'
	'ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR538/003/ERR5385023/ERR5385023_1.fastq.gz'
	'ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR538/003/ERR5385023/ERR5385023_2.fastq.gz'
	'ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR538/004/ERR5385024/ERR5385024_1.fastq.gz'
	'ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR538/004/ERR5385024/ERR5385024_2.fastq.gz'
	'ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR538/005/ERR5385025/ERR5385025_1.fastq.gz'
	'ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR538/005/ERR5385025/ERR5385025_2.fastq.gz'
	'ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR538/006/ERR5385026/ERR5385026_1.fastq.gz'
	'ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR538/006/ERR5385026/ERR5385026_2.fastq.gz'
	'ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR538/007/ERR5385027/ERR5385027_1.fastq.gz'
	'ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR538/007/ERR5385027/ERR5385027_2.fastq.gz'
	'ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR538/008/ERR5385028/ERR5385028_1.fastq.gz'
	'ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR538/008/ERR5385028/ERR5385028_2.fastq.gz'
	'ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR538/009/ERR5385029/ERR5385029_1.fastq.gz'
	'ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR538/009/ERR5385029/ERR5385029_2.fastq.gz'
	'ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR538/000/ERR5385030/ERR5385030_1.fastq.gz'
	'ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR538/000/ERR5385030/ERR5385030_2.fastq.gz'
	'ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR538/001/ERR5385031/ERR5385031_1.fastq.gz'
	'ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR538/001/ERR5385031/ERR5385031_2.fastq.gz'
)

declare -A sample_map=(
	['ERR5385020']='Bulk3'
	['ERR5385021']='Bulk1'
	['ERR5385022']='Elite1'
	['ERR5385023']='Elite2'
	['ERR5385024']='Elite3'
	['ERR5385025']='Desert1'
	['ERR5385026']='North1'
	['ERR5385027']='North2'
	['ERR5385028']='North3'
	['ERR5385029']='Bulk2'
	['ERR5385030']='Desert3'
	['ERR5385031']='Desert2'
)

if [[ ! -d "fastq" ]]; then
	mkdir fastq
fi

count=0
for path in ${fastq_paths[@]}; do
	count=$(($count+1))

	fastq_file=$(basename "$path")
	accession=$(echo ${fastq_file}|awk -F_ '{print $1}')
	read_pair=$(echo ${fastq_file}|awk -F_ '{print $2}'|sed 's/.fastq.gz//')
	sample=${sample_map[${accession}]}

	echo "${count}/${#fastq_paths[@]}"
	curl --output "fastq/${sample}_${read_pair}.fastq.gz" "${path}"

done
