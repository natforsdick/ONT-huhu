### Blobtools pipeline

Blobtoolkit tutorial [](https://blobtoolkit.genomehubs.org/blobtools2/blobtools2-tutorials/getting-started-with-blobtools2/). Following the tutorial directions at https://blobtoolkit.genomehubs.org/blobtools2/blobtools2-tutorials/getting-started-with-blobtools2/.

Dini set me up with a Blobtools instance running out of the NeSI training directory (nesi02659) - do you have access to this Jessie? If so, here is the workflow: Make this into a single script if possible.


#### Prior to running script:

1. Install blobtoolkit in `/nesi/nobackup/landcare03691/`

```
cd /nesi/nobackup/landcare03691/
```

Load python module

```
module purge
module load Python/3.10.5-gimkl-2022a
```

Create a virtual environment

```
python -m venv blobtools2
```

Activate the environment

```
source blobtools2/bin/activate
```

Install blobtoolkit

```
pip install blobtoolkit[full]
pip install blobtoolkit[host]

```

Test whether blobtools is installed properly

```
module purge && module load Python/3.10.5-gimkl-2022a
source /nesi/nobackup/landcare03691/blobtools/bin/activate

blobtools -h
blobtools -v
```

If it's working, output to above should look like: 

```
usage: blobtools [<command>] [<args>...] [-h|--help] [--version]
blobtoolkit v4.1.0
```

2. Get the latest NCBI taxonomy database

```
mkdir /path/to/taxdump/
cd /path/to/taxdump/

wget ftp://ftp.ncbi.nlm.nih.gov/pub/taxonomy/taxdump.tar.gz
tar zxvf taxdump.tar.gz
```
Use `ls` to check that it decompressed the directory, and check that there are .dmp files inside. 

3. Find the NCBI taxonomy ID for the focal species

Before running, collect the species-specific taxid from NCBI at https://www.ncbi.nlm.nih.gov/taxonomy. 
For rātā moehau, taxid = 101958. https://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?id=101958

4. Map the trimmed ONT data to the assembly to generate a BAM alignment file

Use `nano` to make script `01-align.sl` in the blobtools scripts directory with the following content. Then run this script. 

```
#!/bin/bash -e

#SBATCH --job-name=align
#SBATCH --output=%x.%j.out
#SBATCH --error=%x.%j.err
#SBATCH --time=00:50:00
#SBATCH --mem=10G 
#SBATCH --ntasks=1
#SBATCH --account=landcare03691
#SBATCH --cpus-per-task=32

### MODULES ###
module purge
module load minimap2/2.24-GCC-11.3.0
######

### PARAMS ###
INDIR=/nesi/nobackup/landcare03691/data/output/03-assembly/all-data/
OUTDIR=/nesi/nobackup/landcare03691/data/output/05-blobtools/
DATA=/nesi/nobackup/landcare03691/data/output/rata-MinION/
ASMPRE=assembly # assembly prefix
######

cd $OUTDIR 

# 1. Index assembly if the index .mmi doesn't already exist
echo "Indexing"
if [ ! -e ${INDIR}${ASM}.mmi ];
then
minimap2 -d ${INDIR}${ASM}.mmi ${INDIR}${ASM}.fasta
else
echo "index found"
fi

# 2. map processed ONT reads to the assembly
minimap2 -ax map-ont -t 24 ${ASM}.mmi ${DATA}rata-1-trimmed.fastq.gz ${DATA}rata-2-trimmed.fastq.gz |\
    samtools sort -@24 -O BAM -o assembly.bam -

echo "mapping complete"
```

5. You are ready to go!

Aim is to run the following script for the raw assembly (`ASMPRE=assembly`) and for the round 2 purge-dups assembly.

Use `nano` to make a new script called `01-run-blobtools.sh` and copy the contents below. This will prep a genome assembly for visualisation with Blobtools.

Be sure to check that the PARAMS are correct for your in/outputs!

```
#!/bin/bash -e

# Script to prep genome assembly for visualisation with Blobtoolkit
# 2023-04-17

### ENVIRONMENT ###
module purge && module load Python/3.10.5-gimkl-2022a
source /nesi/nobackup/nesi02659/RND/blobtools/bin/activate
######

# print blobtools version
blobtools -v

### PARAMS ###
INDIR=/nesi/nobackup/landcare03691/data/output/03-assembly/all-data/
ASM=assembly.fasta # assembly input
OUTDIR=/nesi/nobackup/landcare03691/data/output/05-blobtools/
OUTPRE=rata-2-all # output prefix
TAXDUMP=/path/to/taxdump/ # change this to wherever your decompressed taxdump directory is
INBUSCO=/nesi/nobackup/landcare03691/data/output/03-assembly/assembly-QC/BUSCO_assembly/run_/
BUSCOTSV=full_table.tsv
######

cd $OUTDIR

# 1. Create a BlobDir for your input assembly. This will produce a series of JSON files.
echo creating blob for $ASM

blobtools create --fasta ${INDIR}${ASM} ${OUTPRE}

# 2. Add taxonomy metadata
echo adding taxonomy

blobtools create \
    --fasta ${INDIR}${ASM} \
    --taxid 101958 # spp-specific taxid \
    --taxdump ${TAXDUMP} \
    ${OUTPRE}

# 3. Add BUSCO results

echo adding BUSCO

blobtools add \
    --busco ${INBUSCO}${BUSCOTSV} \
    ${OUTPRE}
```

I haven't tested this with the rātā data, but based on my testing with kakī, the script should work (fingers crossed!). It will produce a series of JSON files in the `OUTDIR`. 

There is one additional step, adding the data from the BAM alignment, that has previously caused my tests to fail, so I recommend that you run the above as it is, and then once you have tested out `6. Visualisation` below, add step 4 code the script, and try running and visualising again.

```
# 4. Add mapping coverage 

#echo adding coverage

blobtools add \
    --cov assembly.bam \
    ${OUTPRE}
```

6. Visualise assembly with Blobtools

Access NeSI via Jupyter Virtual Desktop: Dini has made a helpful guide here: https://nesi.github.io/blobtools-jupyter-vdt/ - follow steps 1 & 2 under `1. Install`, and then jump down to `Launch BlobToolKit viewer`. 

If you hit any snags along the way, let me know. If everything goes well but you have difficulties with the viewer, I suggest reaching out to Dini. If all goes really really well, try modifying the script to take the round 2 purge-dups assembly `02-assembly-purged.fa` as input. Don't forget to modify `OUTPRE` to match. Good luck!
