#!/bin/bash -e
#SBATCH -A ga03186
#SBATCH -J NanoQC
#SBATCH --time 05:20:00
#SBATCH --cpus-per-task=4
#SBATCH --mail-user=forsdickn@landcareresearch.co.nz
#SBATCH --mail-type=FAIL,END
#SBATCH --output %x-%j.out
#SBATCH --error %x-%j.err
#SBATCH --mem 4G
#SBATCH --profile=task 

# 02-nanoqc.sl
# 2022-06-01, Nat Forsdick
# QC for Nanopore sequence data
# Takes 1 param: data directory

###############
# PARAMS

datadir=/nesi/nobackup/ga03186/Huhu_MinION/${1}/sup-fastq/
combined=${datadir}combined-sup-fastqs/
combinedQC=${datadir}sup-QC/
PASS=${datadir}pass/
FAIL=${datadir}fail/
###############

###############
# MODULES     
module purge 
module load nanoQC/0.9.4-gimkl-2020a-Python-3.8.2

###############
echo "Starting NanoQC pipeline"
cd $datadir

if [ ! -e $combined ]; then
        mkdir -p $combined
        mkdir -p $combinedQC
else
        echo "Output directories exist"
fi

# pull the 'protocol_group_id' (run ID) from a guppy_output file. 
# grep -m stops searching after first occurrence. cut to pull the value of the sample_id key
runID=$(grep -m 1 'protocol_group_id' ${datadir}sequencing_telemetry.js | cut -d '"' -f 4)
echo '$runID is set to:' $runID $1

#echo "Assessing with NanoPlot"
# Run this step separately - it takes less couple of minutes with no resource required.
#NanoPlot -t $SLURM_CPUS_PER_TASK -o $combinedQC -p ${1} -c forestgreen --N50 --summary sequencing_summary.txt
#conda deactivate

# Concatenating all and passed Huhu-PS5 fastq files, counting total reads, and running NanoQC.

if [ ! -e ${combined}Huhu-PB5-pass.fastq.gz ]; then
	echo 'Concatenating fastqs'
	cat ${PASS}*.fastq | gzip > ${combined}Huhu-PB5-pass.fastq.gz
	echo 'Concatenated'
fi

if [ ! -e ${combined}Huhu-PB5-all.fastq.gz ]; then
        echo 'Concatenating fastqs'
	cat ${PASS}*.fastq ${FAIL}*.fastq | gzip > ${combined}Huhu-PB5-all.fastq.gz
	echo 'Concatenated'
else
	echo 'Already concatenated'
fi

echo 'Counting passed reads'
zcat ${combined}Huhu-PB5-pass.fastq.gz | echo ${1} PASSED $((`wc -l`/4))

echo 'Counting all reads'
zcat ${combined}Huhu-PB5-all.fastq.gz | echo ${1} ALL $((`wc -l`/4))

echo 'Beginning QC'
cd ${combined}
for f in *.fastq.gz
	do

	if [ ! -e ${combinedQC}${f}.QC/*.html ]; then
		nanoQC ${f} -o ${combinedQC}${f}.QC
		echo 'Finished ${1} ${f} QC'
	fi
done
