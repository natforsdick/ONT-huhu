#!/bin/bash -e
#SBATCH --account=ga03186
#SBATCH --job-name=huhu-omnic-map # job name (shows up in the queue)
#SBATCH --cpus-per-task=12 # mapping can use 18, subsequent processing requires 6
#SBATCH --mem=24G # #mapping needs 30GB, probably needs 36GB for sorting
#SBATCH --time=01:00:00 #Walltime (HH:MM:SS) # Total processing minimum 12 hrs
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=forsdickn@landcareresearch.co.nz
#SBATCH --output %x.%j.out # CHANGE number for new run
#SBATCH --error %x.%j.err #  CHANGE number for new run

ml purge
ml SAMtools/1.15.1-GCC-11.3.0 BWA/0.7.17-GCC-11.3.0 pairtools/1.0.2-gimkl-2022a-Python-3.10.5 lz4/1.9.3-GCCcore-11.3.0

#########
# PARAMS
PREFIX=medaka-consensus
INDIR='/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/omnic-scaffolding/shasta-purged-polished-omnic/' 
OMNICR1=/nesi/nobackup/ga03186/Huhu_MinION/2023-09-25-OmniC-QC/omnic-out/clean-in/huhu-omnic-clean-R1.fastq.gz
OMNICR2=/nesi/nobackup/ga03186/Huhu_MinION/2023-09-25-OmniC-QC/omnic-out/clean-in/huhu-omnic-clean-R2.fastq.gz
REFDIR=/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/omnic-scaffolding/shasta-purged-polished-omnic/
REF=medaka-consensus
TMPDIR="/nesi/nobackup/ga03186/tmp-omnic-${SLURM_JOB_ID}"
CPU=24
########

cd $INDIR
export TMPDIR=$TMPDIR

# sort bam
echo sorting bam
samtools sort -@ $CPU -T ${TMPDIR}tempfile.bam -o ${PREFIX}-mapped.PT.bam ${PREFIX}-unsorted.bam

# index bam
echo indexing final bam
samtools index ${PREFIX}-mapped.PT.bam

if [ -f ${PREFIX}-mapped.PT.bam ]
then
echo "pipeline completed"
else
echo "pipeline not complete"
fi

