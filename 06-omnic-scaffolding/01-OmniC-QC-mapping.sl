#!/bin/bash 
#SBATCH --account=ga03186
#SBATCH --job-name=01-arima-indexing # job name (shows up in the queue)
#SBATCH --cpus-per-task=28
#SBATCH --mem=20G
#SBATCH --time=01:00:00 #Walltime (HH:MM:SS)
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=forsdickn@landcareresearch.co.nz
#SBATCH --output %x.%j.out 
#SBATCH --error %x.%j.err 
################################

##############################################
# ARIMA GENOMICS MAPPING PIPELINE 02/08/2019 #
# https://github.com/ArimaGenomics/mapping_pipeline/ #
##############################################

# This is the ARIMA genomics pipeline, modified by Nat Forsdick for use with kakī data.

# Below find the commands used to map HiC data.
# Replace the variables at the top with the correct paths for the locations of files/programs on your system.
# This bash script will map one paired end HiC dataset (read1 & read2 fastqs). 
# Modify and multiplex as you see fit to work with your volume of samples and system.

##########################################
# Commands #
##########################################

############
# MODULES
############
module purge
module load BWA/0.7.17-GCC-9.2.0 picard/2.21.8-Java-11.0.4 SAMtools/1.13-GCC-9.2.0 samblaster/0.1.26-GCC-9.2.0
############

############
# PARAMS
############
HIC='EXT048Huhu_S1_L001' #'basename_of_fastq_files'
LABEL='huhu-omnic-mapped' #'overall_exp_name'
BWA='bwa' #'/software/bwa/bwa-0.7.12/bwa'
SAMTOOLS='samtools' #'/software/samtools/samtools-1.3.1/samtools'
IN_DIR='/nesi/nobackup/ga03186/Huhu_MinION/2023-09-25-OmniC-QC/EXT048Huhu_L001_ds.381f22cb853e4f759ef94d3cdde2829a/' # '/path/to/gzipped/fastq/files'
REF_DIR='/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/02-purge-dups/asm2/'
REF='/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/02-purge-dups/asm2/01-asm2-flye-purged.fa' #'/path/to/reference_sequences/reference_sequences.fa'
FAIDX='$REF.fai'
PREFIX='01-asm2-flye-purged' #'bwa_index_name'
RAW_DIR='/nesi/nobackup/ga03186/Huhu_MinION/2023-09-25-OmniC-QC/hicqc-out/01/' #'/path/to/write/out/bams'
FILT_DIR='/nesi/nobackup/ga03186/Huhu_MinION/2023-09-25-OmniC-QC/hicqc-out/02/' #'/path/to/write/out/filtered/bams'
FILTER='/nesi/project/ga03186/scripts/Hi-C_scripts/filter_five_end.pl' #'/path/to/filter_five_end.pl'
COMBINER='/nesi/project/ga03186/scripts/Hi-C_scripts/two_read_bam_combiner.pl' #'/path/to/two_read_bam_combiner.pl'
STATS='/nesi/project/ga03186/scripts/Hi-C_scripts/get_stats.pl' #'/path/to/get_stats.pl'
PICARD='/opt/nesi/mahuika/picard/2.21.8-Java-11.0.4/picard.jar'
TMP_DIR='/nesi/nobackup/ga03186/tmp/' #'/path/to/write/out/temporary/files'
PAIR_DIR='/nesi/nobackup/ga03186/Huhu_MinION/2023-09-25-OmniC-QC/hicqc-out/03/' #'/path/to/write/out/paired/bams'
REP_DIR='/nesi/nobackup/ga03186/Huhu_MinION/2023-09-25-OmniC-QC/hicqc-out/04/' #'/path/to/where/you/want/deduplicated/files'
REP_LABEL=$LABEL\_rep1
MERGE_DIR='/nesi/nobackup/ga03186/Huhu_MinION/2023-09-25-OmniC-QC/hicqc-out/05/' #'/path/to/final/merged/alignments/from/any/biological/replicates'
MAPQ_FILTER=10
CPU=26
############

echo "### Step 0: Check output directories exist & create them as needed"
[ -d $RAW_DIR ] || mkdir -p $RAW_DIR
[ -d $FILT_DIR ] || mkdir -p $FILT_DIR
[ -d $TMP_DIR ] || mkdir -p $TMP_DIR
[ -d $PAIR_DIR ] || mkdir -p $PAIR_DIR
[ -d $REP_DIR ] || mkdir -p $REP_DIR
[ -d $MERGE_DIR ] || mkdir -p $MERGE_DIR

echo "### Step 0: Index reference" # Run only once! Skip this step if you have already generated BWA index files
# Indexing takes around 40 min for a 1.2 Gb genome
cd $REF_DIR
if [ -f ${REF}.sa ]; then
    echo "${REF} index found"
    else
	bwa index -a bwtsw -p $PREFIX $REF
	samtools faidx $REF
	echo "Finished indexing $REF"
fi

echo "### Step 1.A: FASTQ to BAM (1st)"
echo "bwa mem -t $CPU -5SP $REF ${IN_DIR}${HIC}_R1_001.fastq.gz ${IN_DIR}${HIC}_R2_001.fastq.gz | samblaster |\
 samtools view -@ $CPU -buSh -F 2316 - > ${RAW_DIR}${HIC}.bam"

bwa mem -t $CPU -5SP $REF ${IN_DIR}${HIC}_R1_001.fastq.gz ${IN_DIR}${HIC}_R2_001.fastq.gz | samblaster |\
 samtools view -@ $CPU -buSh -F 2316 - > ${RAW_DIR}${HIC}.bam

cd ${RAW_DIR}
echo "Sorting ${HIC}"
samtools sort -@ $CPU ${RAW_DIR}${HIC}.bam -o ${RAW_DIR}${HIC}-sorted.bam
echo "Indexing ${HIC}"
samtools index -@ $CPU ${RAW_DIR}${HIC}-sorted.bam

echo "Sorting ${HIC}"
samtools sort -n -@ $CPU ${RAW_DIR}${HIC}.bam -o ${RAW_DIR}${HIC}-n-sorted.bam
echo "Finished step 1.A"


