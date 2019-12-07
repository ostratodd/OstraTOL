#!/bin/bash
sing_image="/home/pcw/ubuntu_bioperl_biopy2.img" 
accdir="data/accessions"
seqdir="data/sequences"
tdir="data/transcriptomes"
andir="analyses"

cp tmpphytabdata/results.data $andir/genbank_muscle.phytab

#************************************Arguments for Phylocatenator.pl
#my $infile1=shift(@ARGV);               #0 input file
#my $mingf_persp=shift(@ARGV);           #1 minimum number of genefamiles to keep species
#my $minsp_pergf=shift(@ARGV);           #2 minimum number of species to keep genefamily
#my $min_gf_len =shift(@ARGV);           #3 minimum gene family length
#my $speciesfile=shift(@ARGV);           #4 optional species file 'None' if false
#my $modelsfile=shift(@ARGV);            #5 models file
#my $outfile=shift(@ARGV);               #6 data outfile
#my $partfile=shift(@ARGV);              #7 partition file
#my $htmlfile=shift(@ARGV);              #8 html file
#my $htmlfile2=shift(@ARGV);             #9 html file for accession numbers
#************************************Arguments for Phylocatenator.pl

rm $andir/genbank_muscle.phylip
rm $andir/genbank_muscle.partition.txt
rm $andir/genbank_muscle.html
rm $andir/genbank_muscle.accessiontable.html
./scripts/phylocatenator.pl $andir/genbank_muscle.phytab 1 4 50 None None $andir/genbank_muscle.phylip $andir/genbank_muscle.partition.txt $andir/genbank_muscle.html $andir/genbank_muscle.accessiontable.html > phylocat.log
 

#Sending bash script to submit slurm job 
sbatch ./scripts/iqtree_slurm.sh analyses/genbank_muscle.phylip phylogenies/genbank

