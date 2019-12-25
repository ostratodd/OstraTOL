#!/usr/bin/perl -w
use strict;


#Need 4 inputs. <phytab file> <text file with accessions> <name of file for sequences (lines) to keep> <name of file for deleted lines>
my $phytabfile = $ARGV[0];
my $accfile = $ARGV[1];
my $keepfile = $ARGV[2];
my $delfile = $ARGV[3];

#Define variables
my @accnums;
my $keep;
my $theacc;

open (ACCFILE,"<$accfile") or die "Cannot open file containing accession numbers\n";

#Here, read text file with accession numbers, store in array
while (<ACCFILE>){
	chomp;
	next unless ($_);
	my @nocomment = split('\s', $_);	
	push(@accnums, $nocomment[0]);
}
close ACCFILE;


open (KEEPFILE,">$keepfile") or die "Cannot open file to write\n";
open (DELFILE,">$delfile") or die "Cannot open file to write\n";
open (PHYFILE,"<$phytabfile") or die "Cannot open file containing accession numbers\n";
while(<PHYFILE>){
	chomp;
	next unless ($_);
	for(my $i=0; $i < @accnums; $i++){
		if($_ =~ m/$accnums[$i]/){
			$keep=0;
			$theacc = $accnums[$i];
			last;	#if any accession matches no need to keep searching, this exits forloop
		}else{
			$keep=1;
		}
	}
	if($keep){
		print KEEPFILE "$_"."\n";
	}else{
		print "Removing $theacc and writing to $delfile\n";
		print DELFILE "$_"."\n";
	}
}
close PHYFILE;
close DELFILE;
close KEEPFILE;
