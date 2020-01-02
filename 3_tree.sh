#!/bin/bash
sing_image="/home/pcw/ubuntu_bioperl_biopy2.img" 
accdir="data/accessions"
seqdir="data/sequences"
tdir="data/transcriptomes"
andir="analyses"

cp tmpphytabdata/results.data $andir/genbank_muscle.phytab

#This adds morphological data
	cat data/morphology/*.phytab > $andir/morph.phytab
	cat data/transcriptomes/*binary.phytab  >> $andir/morph.phytab
	cat data/transcriptomes/*multi.phytab  >> $andir/morph.phytab
	#remove blank lines
	sed -i '/^[ \t]*$/d' $andir/morph.phytab

	#Remove subspecies names from one dataset
	perl -pi -e 's/\(Candonopsis\)\_//g' $andir/morph.phytab
	perl -pi -e 's/\(Abcandonopsis\)\_//g' $andir/morph.phytab

	cat $andir/genbank_muscle.phytab $andir/morph.phytab > $andir/combined.phytab
	cat data/morphology/*.model > morph_models.txt
	cat data/transcriptomes/oakley_2013.model >> morph_models.txt
	cat morph_models.txt dna_models.txt > all_models.txt
	perl -pi -e 's/MERISTIC/MULTI/g' all_models.txt

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


#Choose to include morphology or not here with one commented
#analysis_header="genbank_muscle"
analysis_header="combined"

rm $andir/$analysis_header.phylip
rm $andir/$analysis_header.partition.txt
rm $andir/$analysis_header.html
rm $andir/$analysis_header.accessiontable.html
./scripts/phylocatenator.pl $andir/$analysis_header.phytab 0 4 1 None all_models.txt $andir/$analysis_header.phylip $andir/$analysis_header.partition.txt $andir/$analysis_header.html $andir/$analysis_header.accessiontable.html > phylocat.log
 

#Sending bash script to submit slurm job 
#sbatch ./scripts/iqtree_slurm.sh analyses/$analysis_header.phylip phylogenies/genbank

#Currently Raxml because phylocatenator is setup for that better. IQTREE to mix morph and dna needs separate files and nexus partitioning (see gmail)
#https://groups.google.com/forum/#!topic/iqtree/h63lNK7icmU
sbatch ./scripts/raxml_slurm.sh analyses/$analysis_header.phylip analyses/$analysis_header.partition.txt phylogenies/$analysis_header

