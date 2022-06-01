#!/bin/bash
#SBATCH -A ga03186
#SBATCH -J NanoQC
#SBATCH --time 04:00:00 #
#SBATCH -c 2
#SBATCH --mem=2G
#SBATCH --mail-user=forsdickn@landcareresearch.co.nz
#SBATCH --mail-type=FAIL
#SBATCH --output %x.%j.out
#SBATCH --error %x.%j.err 

###############
# PARAMS

# Takes 2 params as input - 1) 'hac' or 'sup' and 2) INDIR name

datadir="/nesi/nobackup/ga03186/Huhu_MinION/${2}/${1}-fastq/"
combined="/nesi/nobackup/ga03186/Huhu_MinION/${2}/${1}-fastq/combined-${1}-fastqs/"
combinedQC="/nesi/nobackup/ga03186/Huhu_MinION/${2}/${1}-fastq/${1}-QC/"

PASS="/nesi/nobackup/ga03186/Huhu_MinION/${2}/${1}-fastq/pass/"
FAIL="/nesi/nobackup/ga03186/Huhu_MinION/${2}/${1}-fastq/fail/"
###############

###############
# MODULES     
module purge 
module load nanoQC/0.9.4-gimkl-2020a-Python-3.8.2

###############
cd $datadir

if [ ! -e $combined ]; then
        mkdir -p $combined
        mkdir -p $combinedQC
else
        echo "Output directories exist"
fi

# pull the 'protocol_group_id' (run ID) from a guppy_output file. 
# grep -m stops searching after first occurrence. cut to pull the value of the sample_id key
runID=$(grep -m 1 'protocol_group_id' ${datadir}/sequencing_telemetry.js | cut -d '"' -f 4)
echo '$runID is set to:' $runID $1

#echo "Assessing with NanoPlot"
# Run this step separately - it takes less couple of minutes with no resource required.
#NanoPlot -t $SLURM_CPUS_PER_TASK -o $combinedQC -p ${1} -c forestgreen --N50 --summary sequencing_summary.txt
#conda deactivate

# Concatenating all and passed Huhu-PS5 fastq files, counting total reads, and running NanoQC.

if [ ! -e ${combined}Huhu-PS5-pass.fastq.gz ]; then
	echo 'Concatenating fastqs'
	cat ${PASS}*.fastq | gzip > ${combined}Huhu-PS5-pass.fastq.gz
	cat ${PASS}*.fastq ${FAIL}*.fastq | gzip > ${combined}Huhu-PS5-all.fastq.gz
	echo 'Concatenated'
else
	echo 'Already concatenated'
fi

#echo 'Counting passed reads'
#zcat ${combined}Huhu-PS5-pass.fastq.gz | echo ${1} PASSED $((`wc -l`/4))

#echo 'Counting all reads'
#zcat ${combined}Huhu-PS5-all.fastq.gz | echo ${1} ALL $((`wc -l`/4))

echo 'Beginning QC'
cd ${combined}
for f in *.fastq.gz
	do

	if [ -e ${combinedQC}${f}.QC/*.html ]; then
		echo "completed QC for ${f}"
	else
		nanoQC ${f} -o ${combinedQC}${f}.QC
		echo 'Finished ${1} ${f} QC'
	fi
done

