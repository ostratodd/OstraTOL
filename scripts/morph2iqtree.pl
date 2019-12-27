#!/usr/bin/perl -w
use strict;


#Need 4 inputs. <matrix file> <character file> <phytab outfile> <Dataset name>
my $matrixfile = $ARGV[0];
my $characterfile = $ARGV[1];
my $phytab = $ARGV[2];
my $dataset = $ARGV[3];

#Define variables
my %matrix;
my %chars;
my $species;
my $taxno=0;
my $maxchar = 0;

open (MFILE,"<$matrixfile") or die "Cannot open file to write\n";
open (CFILE,"<$characterfile") or die "Cannot open file to write\n";
open (OUT,">$phytab") or die "Cannot open file for writing\n";

#read matrix
while(<MFILE>){
	chomp;
	next unless ($_);
	my @mline = split(/\t/, $_);
	for(my $i=1; $i < @mline; $i++){
		$matrix{$mline[0]}{$i-1}=$mline[$i]; #subtract one assuming counting starts at 0
	}
	$maxchar = @mline-1;
	$taxno++;
}
close MFILE;

my $binary=0; my $meristic=0; my $multi=0;
#read characters file
while(<CFILE>){
	chomp;
	next unless ($_);
	my @cline = split(/\t/, $_);

	if($cline[1] eq 'Binary'){
		$binary=1;
	}
	if($cline[1] eq 'Meristic'){
		$meristic=1;
	}
	if($cline[1] eq 'Multi-state'){
		$multi=1;
	}
	for(my $i=1; $i < @cline; $i++){
		$chars{$cline[0]}=$cline[1];
	}
}
close CFILE;

#Check some assumptions about file

#Now print to phytab format using subfunction
#Need to check if there are >0 of each data type
if($binary){
	print_phytab("Binary","binary", $dataset);
}
if($multi){
	print_phytab("Multi-state","multistate", $dataset);
}
if($meristic){
	print_phytab("Meristic","meristic", $dataset);
}


sub print_phytab
{
	my ($search, $print, $dataset) = @_;

	my $charno;
	foreach my $name (sort keys %matrix) {
		$charno=0;
		if($name eq "Taxon"){
			#skip
		}else{
			$species = $name;
			$species =~ s/ /_/g;
			print OUT "$species\t$print"."_"."$dataset\t$dataset\t";
			for(my $c = 0; $c < $maxchar; $c++){
				if($chars{$c} eq $search){
					if($matrix{$name}{$c} =~ m/\-/ ){
						$matrix{$name}{$c} = "?";
					}
					if($search eq "Binary") {
						if($matrix{$name}{$c} =~ m/\(/ ){
							print "WARNING: Character $c is binary but $species is $matrix{$name}{$c} \t*****CHANGING to ? assuming missing data\n";
							$matrix{$name}{$c} = '?';
						}
						unless($matrix{$name}{$c} =~ m/[01\?]/ ){
							print "WARNING: Character $c is binary but $species is $matrix{$name}{$c} \t*****CHANGING to ? assuming missing data\n";
							$matrix{$name}{$c} = '?';
						}
					}
					if($search eq "Multi-state") {
						if($matrix{$name}{$c} =~ m/\(/ ){
							print "WARNING: Character $c is binary but $species is $matrix{$name}{$c} \t*****CHANGING to ? assuming missing data\n";
							$matrix{$name}{$c} = '?';
						}
						unless($matrix{$name}{$c} =~ m/[0123456789\?]/ ){
							print "WARNING: Character $c is Multi-state [0-9] but $species is $matrix{$name}{$c} \t*****CHANGING to ? assuming missing data\n";
							$matrix{$name}{$c} = '?';
						}
					}
					if($search eq "Meristic") {
						if($matrix{$name}{$c} =~ m/\(/ ){
							print "WARNING: Character $c is binary but $species is $matrix{$name}{$c} \t*****CHANGING to ? assuming missing data\n";
							$matrix{$name}{$c} = '?';
						}
						unless($matrix{$name}{$c} =~ m/[ABCDEFG0123456789\?]/ ){
							print "WARNING: Character $c is Meristic [A-G 0-9] but $species is $matrix{$name}{$c} \t*****CHANGING to ? assuming missing data\n";
							$matrix{$name}{$c} = '?';
						}
					}
					print OUT $matrix{$name}{$c};
				}
			}
		}
		print OUT "\n";
	}
}


#for(my $c=0; $c < $maxchar; $c++){
#	print $c.": ".$chars{$c}."\n";
#}

close OUT;
