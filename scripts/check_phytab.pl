#!/usr/bin/perl
use strict;

#This scrips searches through a phytab file (tab delimited) and counts number of tabs in a line
#if there is not 3, as expected, it writes to one file, writes matches to another file
#Usage: perl check_phytab.pl <infile-phytab> <filename for pass><filename for fail>

my $infile=$ARGV[0];
my $passout=$ARGV[1];
my $failout=$ARGV[2];

open IN, $infile or die "Cannot open $infile\n";
open OUT, ">".$passout or die "Cannot open $passout\n";
open FAIL, ">".$failout or die "Cannot open $failout\n";

while(<IN>){
	my $row = $_;
	chomp($row);

	my $tabs = () = $row =~ /\t/gi;
	if($tabs == 3) {
		print OUT "$row\n";
	}else{
		print "Writing improper phytab row to $failout\n";
		print FAIL "$row\n";
	}
}


