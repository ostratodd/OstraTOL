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
while(<CFILE>){
	chomp;
	next unless ($_);
	my @cline = split(/\t/, $_);
	for(my $i=1; $i < @cline; $i++){
		$chars{$cline[0]}=$cline[1];
	}
}
close CFILE;

#Check some assumptions about file

#Now print to phytab format using subfunction
print_phytab("Binary","binary", $dataset);
print_phytab("Multi-state","multistate", $dataset);

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
			print OUT "$species\t$print\t$dataset\t";
			for(my $c = 0; $c < 30; $c++){
				if($chars{$c} eq $search){
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
						unless($matrix{$name}{$c} =~ m/[0123456789\?]/ ){
							print "WARNING: Character $c is Multi-state [0-9] but $species is $matrix{$name}{$c} \t*****CHANGING to ? assuming missing data\n";
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
