#!/bin/bash
#SBATCH --nodes=1 --ntasks-per-node=30
#SBATCH -p batch
source /home/oakley/.bashrc

#First argument is infile
#Outfile
today=$(date +"%m_%d_%Y")
outfile=rax_$today


echo "This script will now send the raxml job to slurm. Currently set up to just use GTR and not search for best model."
echo "writing phylogeny files to $outfile"

raxmlHPC-PTHREADS -s $1 -q $2 -m BINCAT -n $outfile -p 999 -T 30
