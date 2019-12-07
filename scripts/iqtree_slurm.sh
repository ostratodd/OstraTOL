#!/bin/bash
#SBATCH --nodes=1 --ntasks-per-node=20
#SBATCH -p batch
source /home/oakley/.bashrc

#First argument is infile
#Outfile
today=$(date +"%m_%d_%Y")
outfile=$2_$today

echo $outfile

echo "This script will now send the iqtree job to slurm. Currently set up to just use GTR and not search for best model."
echo "writing phylogeny files to $outfile"

#ML tree with IQ-Tree no partitions, assume GTR model -pre is name of analysis
#iqtree -s analyses/genbank_muscle.phylip -m GTR -pre phylogenies/11302019 -redo -nt 20
iqtree -s $1 -m GTR -pre $outfile -redo -nt 20




