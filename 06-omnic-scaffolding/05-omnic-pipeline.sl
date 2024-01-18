#!/bin/bash -e
#SBATCH --account=ga03186
#SBATCH --job-name=huhu-omnic-map # job name (shows up in the queue)
#SBATCH --cpus-per-task=24 # mapping can use 18, subsequent processing requires 6
#SBATCH --mem=4G # #mapping needs 30GB, probably needs 36GB for sorting, 4GB for everything else
#SBATCH --time=12:00:00 #2-00:00:00 #Walltime (HH:MM:SS) # Total processing minimum 12 hrs
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=forsdickn@landcareresearch.co.nz
#SBATCH --output %x.%j.out # CHANGE number for new run
#SBATCH --error %x.%j.err #  CHANGE number for new run

ml purge
ml SAMtools/1.15.1-GCC-11.3.0 BWA/0.7.17-GCC-11.3.0 pairtools/1.0.2-gimkl-2022a-Python-3.10.5

#########
# PARAMS
PREFIX=huhu-shasta-purged-DT-yahsNMC_JBAT
INDIR='/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/omnic-scaffolding/omnic-r2/' 
OMNICR1=/nesi/nobackup/ga03186/Huhu_MinION/2023-09-25-OmniC-QC/omnic-out/clean-in/huhu-omnic-clean-R1.fastq.gz
OMNICR2=/nesi/nobackup/ga03186/Huhu_MinION/2023-09-25-OmniC-QC/omnic-out/clean-in/huhu-omnic-clean-R2.fastq.gz
REFDIR=/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/omnic-scaffolding/omnic-r2/
REF=01-huhu-shasta-purged-DT-yahsNMC_JBAT.FINAL
CPU=18
########

cd $INDIR

# alignment -T0 = all alignments to generate stats, quality filtering later
#echo aligning
#bwa mem -5SP -T0 -t $CPU ${REFDIR}$REF.fa $OMNICR1 $OMNICR2 -o ${PREFIX}-aligned.sam

# find ligation junctions
#echo finding ligation junctions
#pairtools parse --min-mapq 40 --walks-policy 5unique --max-inter-align-gap 30 --nproc-in $CPU \
#--nproc-out $CPU --chroms-path ${REFDIR}${REF}.genome ${PREFIX}-aligned.sam > ${PREFIX}-parsed.pairsam

# sort pairsam
#echo sorting pairsam
#pairtools sort --nproc $CPU --tmpdir=$TMPDIR ${PREFIX}-parsed.pairsam > ${PREFIX}-sorted.pairsam

# remove duplicates
echo removing duplicates
pairtools dedup --nproc-in $CPU --nproc-out $CPU --mark-dups --output-stats ${PREFIX}-stats.txt \
--output ${PREFIX}-dedup.pairsam ${PREFIX}-sorted.pairsam

# split .bam, .pairs
echo splitting bam
pairtools split --nproc-in $CPU --nproc-out $CPU --output-pairs ${PREFIX}-mapped.pairs \
--output-sam ${PREFIX}-unsorted.bam ${PREFIX}-dedup.pairsam

if [ -f ${PREFIX}-mapped.pairs ]
then
echo "pipeline completed"
fi

