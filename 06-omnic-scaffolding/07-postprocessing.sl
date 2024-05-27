#!/bin/bash -e
#SBATCH --account=ga03186
#SBATCH --job-name=make-juice-in # job name (shows up in the queue)
#SBATCH --cpus-per-task=4
#SBATCH --mem=26G
#SBATCH --time=01:30:00 #Walltime (HH:MM:SS)
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=forsdickn@landcareresearch.co.nz
#SBATCH --output %x.%j.out # CHANGE number for new run
#SBATCH --error %x.%j.err 

# Generating .hic file for visualisation and manual curation

##########
# PARAMS #
YAHSJUICE=/nesi/project/ga03186/scripts/Hi-C_scripts/yahs/juicer
OUTDIR=/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/omnic-scaffolding/shasta-purged-polished-omnic/yahs/
JUICER=/nesi/nobackup/ga03048/juicer/scripts/juicer_tools.1.9.9_jcuda.0.8.jar
REF_DIR=/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/omnic-scaffolding/shasta-purged-polished-omnic/
REF=medaka-consensus.fa
REFPRE=medaka-consensus
SCAF=huhu-medaka-mapped-NMC
##########

cd $OUTDIR

echo 'generating hic contact map'
$YAHSJUICE pre -a -o ${SCAF}_JBAT ${SCAF}.bin ${OUTDIR}${SCAF}_scaffolds_final.agp \
${REF_DIR}${REF}.fai > ${SCAF}_JBAT.log 2>&1
echo done step 1

#(juicer pre ${SCAF}.bin ${SCAF}_scaffolds_final.agp ${REFDIR}${REF}.fai | sort -k2,2d -k6,6d -T ./ --parallel=8 -S32G | awk 'NF' > alignments_sorted.txt.part) && (mv alignments_sorted.txt.part alignments_sorted.txt)

echo 'running juicer_tools pre'
java -jar -Xmx26G $JUICER pre ${SCAF}_JBAT.txt ${SCAF}_JBAT.hic.part \
	<(cat ${SCAF}_JBAT.log | grep PRE_C_SIZE | awk '{print $2" "$3}')

mv ${SCAF}_JBAT.hic.part ${SCAF}_JBAT.hic

echo done step 2
