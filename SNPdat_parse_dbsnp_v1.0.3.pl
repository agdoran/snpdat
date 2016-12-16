#!usr/bin/perl -w
use strict;

if($ARGV[0]){
	if($ARGV[0] eq '-v' or $ARGV[0] eq '--version'){
		
		print "This is SNPdat_parse_dbsnp_v1.0.3.pl\nThis version was made available Jan 2013\n";
		exit;
		
	}
}

system("date");

print "Please enter the assembly you want to map RS ids to\n:";
my $build = <STDIN>;
chomp $build;

open(IN, "$ARGV[0]") or die "Error opening the input file\n";

open(OUT, ">$ARGV[1]") or die "Error opening the output file\n";

my $sep = $/;
$/ = "\n\n";

print "$build\n";

my %snps;

while(<IN>){
	$_ =~ s/\s*//g;

	if($_ =~ m/^rs/i and $_ =~ m/$build/){
		$_ =~ s/\|(.)*$build\|/\|/;
		
		$_ =~ s/\|/ /g;
		
		my ($id, $chr, $pos, $rest) = split(" ", $_, 4);
		$snps{$chr}{$pos} = $id;
		
#		if($_ =~ m/\|/g){
#			print "in here\n";
#		}
#		print "$chr\t$pos\n";
		
		$chr =~ s/chr\=//;
		$pos =~ s/chr\-pos\=//;
#		print "$chr\t$pos\n";
		
		#$chr =~ s/\D//g;
		#$pos =~ s/\D//g;
		
		print OUT "$chr\t";
		print OUT "$pos\t";
		print OUT "$id\n";
	}
}

close(IN);

print "The resulting output file is $ARGV[1]\n";
print "This file can be used as input for SNPdat\n";

system("date");
