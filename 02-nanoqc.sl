#!/bin/bash
#SBATCH -A ga03186
#SBATCH -J NanoQC
#SBATCH --time 06:00:00 #
#SBATCH -c 4
#SBATCH --mem=6G
#SBATCH --partition=large
#SBATCH --mail-user=forsdickn@landcareresearch.co.nz
#SBATCH --mail-type=ALL
#SBATCH --output %x.%j.out
#SBATCH --error %x.%j.err 

###############
# PARAMS
datadir=/nesi/nobackup/ga03186/Huhu_MinION/2022-05-16-PS5/hac-fastq/
combined=/nesi/nobackup/ga03186/Huhu_MinION/2022-05-16-PS5/hac-fastq/combined-hac-fastqs/
combinedQC=/nesi/nobackup/ga03186/Huhu_MinION/2022-05-16-PS5/hac-fastq/hac-QC/

PASS=/nesi/nobackup/ga03186/Huhu_MinION/2022-05-16-PS5/hac-fastq/pass/
FAIL=/nesi/nobackup/ga03186/Huhu_MinION/2022-05-16-PS5/hac-fastq/fail/
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
echo '$runID is set to:' $runID

echo "Assessing	with NanoPlot"
conda activate NanoPlot
NanoPlot --version
NanoPlot -t $SLURM_CPUS_PER_TASK -o $combinedQC -p hac -c forestgreen --N50 --summary sequencing_summary.txt
conda deactivate

# Concatenating all and passed Huhu-PS5 fastq files, counting total reads, and running NanoQC.

echo 'Concatenating fastqs'
cat ${PASS}*.fastq | gzip > ${combined}Huhu-PS5-pass.fastq.gz
cat ${PASS}*.fastq ${FAIL}*.fastq | gzip > ${combined}Huhu-PS5-all.fastq.gz
echo 'Concatenated'

echo 'Counting passed reads'
zcat ${combined}Huhu-PS5-pass.fastq.gz | echo PASSED $((`wc -l`/4))

echo 'Counting all reads'
zcat ${combined}Huhu-PS5-all.fastq.gz | echo ALL $((`wc -l`/4))

echo 'Beginning QC'
cd ${combined}
for f in *.fastq.gz
do
nanoQC ${f} -o ${combinedQC}${f}.QC
echo 'Finished ${f} QC'
done

