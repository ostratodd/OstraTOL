#!/bin/bash
#SBATCH --nodes=1 --ntasks-per-node=20
#SBATCH -p batch
source /home/oakley/.bashrc

#First argument is infile


./scripts/phytab_muscle.py -i $1





