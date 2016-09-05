#!usr/bin/perl -w
use strict;

if($ARGV[0]){
	if($ARGV[0] eq '-v' or $ARGV[0] eq '--version'){
		
		print "This is GTF_FASTA_finder_v1.0.4.pl\nThis version was made available Jan 2013\n";
		exit;
		
	}
}

print STDOUT <<END;

This is GTF_FASTA_finder.pl
This is an additional script included in the main SNPdat package.
GTF_FASTA_finder.pl can be used to retrieve GTF and FASTA information for organisms from ensembl.
You will need an internet connection and cURL installed on your machine.
See code.google.com/p/snpdat/ for more information

END


system("curl -s ftp://ftp.ensembl.org/pub/ > temp.list.txt");

open(REL, "temp.list.txt");

my @list;
my $check = 0;

while(<REL>){
	chomp $_;
	
	if($. == 1){
		if($_ =~ m/html/ig){
			$check = 1;
		}
	}
	
	#html if check is 1
	if($check == 1){
		
		next unless ($_ =~ m/release/ig);
		next unless ($_ =~ m/directory/ig);
		
		$_ =~ s/^.*\"\>//;
		$_ =~ s/\<.*$//;
		
		push(@list, $_);
		
	}elsif($check == 0){
		
		next unless ($_ =~ m/^d/);
		next unless ($_ =~ m/release/ig);
		
		$_ =~ s/  */ /g;
		
		my @array = split(" ", $_);
		
		my $rel = $#array;
		
		push(@list, $array[$rel]);
		
	}

}

close(REL);

for(my $i = 0; $i < @list; $i++){
	print "[$i]\t$list[$i]\n";
}

print "\n";

my $size = @list;

print "Please select a release (enter the corresponding number) to retrieve files from:\n";

my $build = <STDIN>;
chomp $build;

if($build < 0 or $build =~ m/\D/ or $build > $size-1){
  error();
}


if($build > 26 ){

	print "You chose release $list[$build]\n\n";

	
	system("curl -s ftp://ftp.ensembl.org/pub/$list[$build]/fasta/ > temp.list2.txt");
	
	
	open(ORG, "temp.list2.txt");
	my $pos = 1;
	my @org_list;

	my $fcheck = 0;

	while(<ORG>){
		chomp $_;
		
		if($. == 1){
			if($_ =~ m/html/ig){
				$fcheck = 1;
			}
		}
		
		#html format
		if($fcheck == 1){
			
			next unless ($_ =~ m/directory/ig);
			next unless ($_ =~ m/\/fasta\//i);
			
			$_ =~ s/^.*\"\>//g;
			$_ =~ s/\<.*$//g;
			
			push(@org_list, $_);
			
		}elsif($fcheck == 0){
			
			next unless ($_ =~ m/^d/);
			
			$_ =~ s/  */ /g;
			
			my @array = split(" ", $_);
			
			my $spe = $#array;
			
			push(@org_list, $array[$spe]);
			
		}
		
		
	}
	close(ORG);

	#print all the organisms
	for(my $i = 0; $i < @org_list; $i++){
		print "[$i]\t$org_list[$i]\n";
	}
	print "\n";


	print "Please select an organism (enter the corresponding number) to retrieve FASTA files for:\n";
	my $organ = <STDIN>;
	chomp $organ;

	my $size2 = @org_list;

	if($organ < 0 or $organ =~ m/\D/ or $organ =~ m/[^0-9]/ or $organ > $size2-1){
		error();
	}

	print "\nYou chose organism $org_list[$organ]\n\n";
	print "Now retrieving the relevant FASTA file for this organism\n";

	system("curl -s ftp://ftp.ensembl.org/pub/$list[$build]/fasta/$org_list[$organ]/dna/ > fasta.temp.txt");
	
	open(FASTA, "fasta.temp.txt");

	my $facheck = 0;

	while(<FASTA>){
		chomp $_;
		
		if($. == 1){
			if($_ =~ m/html/ig){
				$facheck = 1;
			}
		}
		
		if($facheck == 1){
			
			next unless ($_ =~ m/dna\.toplevel/);
			$_ =~ s/^.*\"\>//g;
			$_ =~ s/\<.*$//g;
			
			system("curl -O -# ftp://ftp.ensembl.org/pub/$list[$build]/fasta/$org_list[$organ]/dna/$_");
			
			
		}elsif($facheck == 0){
			
			next unless ($_ =~ m/.gz/g);
			$_ =~ s/  */ /g;
			
			my @array = split(" ", $_);
			
			my $fil = $#array;
			
			
			if($array[$fil] =~ m/dna\.toplevel/){
				
				system("curl -O -# ftp://ftp.ensembl.org/pub/$list[$build]/fasta/$org_list[$organ]/dna/$array[$fil]");
				
			}
			
		}
		
		
	}
	close(FASTA);
	
	system("curl -s ftp://ftp.ensembl.org/pub/$list[$build]/gtf/ > gtf.temp.txt");

	open(GTF, "gtf.temp.txt") or die "Error cannot retrieve GTF file listing\n";

	my $gcheck = 0;

	my @glist;

	while(<GTF>){
		chomp $_;
		
		if($. == 1){
			if($_ =~ m/html/ig){
				$gcheck = 1;
			}
		}
		
		if($gcheck == 1){
			next unless ($_ =~ m/directory/i);
			next unless ($_ =~ m/\/gtf\//i);
			
			
			$_ =~ s/^.*\"\>//;
			$_ =~ s/\<.*$//;
			
			push(@glist, $_);
			
			
		}elsif($gcheck == 0){
			
			next unless ($_ =~ m/^d/);
			
			$_ =~ s/  */ /g;
			
			my @array = split(" ", $_);
			
			my $gfil = $#array;
			
			push(@glist, $array[$gfil]);
			
			
		}
		
	}
	
	for(my $i = 0; $i < @glist; $i++){
		print "[$i]\t$glist[$i]\n";
	}
	print "\n";
	
	print "Please select the organism you would like to retrieve the GTF file for\n";
	
	my $gchoice = <STDIN>;
	chomp $gchoice;
	my $size3 = @glist;
	
	if($gchoice < 0 or $gchoice =~ m/\D/ or $gchoice =~ m/[^0-9]/ or $gchoice > $size3-1){
		error();
	}
	
	print "\nNow retrieving the selected GTF file\n";
	
	system("curl -s ftp://ftp.ensembl.org/pub/$list[$build]/gtf/$glist[$gchoice]/ > gtf_files.temp.txt");
	
	open(GTFDIR, "gtf_files.temp.txt") or die "Error getting the GTF directory listing\n";
	
	my @gtf_dir;
	my $gtcheck = 0;
	while(<GTFDIR>){
		chomp $_;
		
		if($. == 1){
			if($_ =~ m/html/ig){
				$gtcheck = 1;
			}
		}
		next unless ($_ =~ m/\.gtf\.gz/);
		
		if($gtcheck == 1){
			
			$_ =~ s/^.*\"\>//;
			$_ =~ s/\<.*$//;
			push(@gtf_dir, $_);
			
		}elsif($gtcheck == 0){
			$_ =~ s/  */ /g;
			my @array = split(" ", $_);
			my $gtflast = $#array;
			push(@gtf_dir, $array[$gtflast]);
		}
		
	}
	
	for(my $i = 0; $i < @gtf_dir; $i++ ){
		print "Retrieving GTF: $gtf_dir[$i]\n";
		system("curl -O -# ftp://ftp.ensembl.org/pub/$list[$build]/gtf/$glist[$gchoice]/$gtf_dir[$i]");
	}
	close(GTF);
	
	system("rm gtf_files.temp.txt");

	summary($org_list[$organ], $list[$build], $glist[$gchoice]);

	#remove temp files
	system("rm temp.list2.txt");
	system("rm fasta.temp.txt");
	system("rm gtf.temp.txt");
	
}else{

	print "You chose build $list[$build]\n\n\n";
	
	system("curl -s ftp://ftp.ensembl.org/pub/$list[$build]/ > temp.list2.txt");

	
	open(ORG, "<temp.list2.txt") or die "List of available organisms not correctly retrieved\n";
	
	my @org_list;
	
	my $fcheck = 0;
	
	#get list of organisms
	while(<ORG>){
		chomp $_;
		
		if($. == 1){
			if($_ =~ m/html/ig){
				$fcheck = 1;
			}
		}
		
		
		if($fcheck == 1){
			
			next unless ($_ =~ m/directory/ig);
			next unless ($_ =~ m/$list[$build]\//);
			
			$_ =~ s/^.*\"\>//g;
			$_ =~ s/\<.*$//g;
			
			push(@org_list, $_); 
			
			
		}elsif($fcheck == 0){
			
			next unless ($_ =~ m/^d/);
			$_ =~ s/  */ /g;
			
			my @array = split(" ", $_);
			my $fpos = $#array;
			
			push(@org_list, $array[$fpos]);
			
			
		}
	}
	
	#print the list of organisms
	for(my $i = 0; $i < @org_list; $i++){
		print "[$i]\t$org_list[$i]\n";
	}
	
	close(ORG);
	
	#select an organism
	print "Please select an organism (enter the corresponding number) to retrieve files from:\n";
	my $organ = <STDIN>;
	chomp $organ;

	my $size2 = @org_list;
	
	if($organ < 0 or $organ =~ m/\D/ or $organ =~ m/[^0-9]/ or $organ > $size2-1){
		error();
	}
	
	print "\nYou chose organism $org_list[$organ]\n\n";
	
	#
	#	First check to ensure there exists a fasta and gtf directory for this organism in this build
	#
	
	system("curl -s ftp://ftp.ensembl.org/pub/$list[$build]/$org_list[$organ]/data/ > temp.check.list.txt");
	
	open(CHECKL, "<temp.check.list.txt") or die "Error retrieving FASTA and GTF information. Please go to:\nftp://ftp.ensembl.org/pub/$list[$build]/$org_list[$organ]/\nto retrieve information manually\n";
	
	#now read in the contents of the organisms directory and check to see if /data/ directory exists. If so move into that directory.
	#If /data/ does not exist print error messege.
	#If it does, move into that directory and check to see if gtf and fasta directories exist. 
	#If they dont report error and exit
	#if one of them does descend into that directory and check for relevant file type. Then report error that the other directory does not exist
	#If both of them exist then descend into each one sequentially and retrieve the relevant file types
	
	my $gtf_check = 0;
	my $fasta_check = 0;
	
	my $gtf_file;
	my $fasta_file;
	
	my $lcheck = 0;
	
	while(<CHECKL>){
		chomp $_;
		
		if($. == 1){
			if($_ =~ m/html/ig){
				$lcheck = 1;
			}
		}
		
		if($lcheck == 1){
			next unless ($_ =~ m/directory$/i);
			$_ =~ s/^.*\=\"//;
			$_ =~ s/\".*$//;
			
			if($_ =~ m/\/data\/gtf\//){
				$gtf_check = 1;
				$gtf_file = $_;
			}
			
			if($_ =~ m/\/data\/fasta\//){
				$fasta_check = 1;
				$fasta_file = $_;
			}
		}
		elsif($lcheck == 0){
			next unless ($_ =~ m/^d/);
			
			$_ =~ s/  */ /g;
			my @array = split(" ", $_);
			my $lpos = $#array;
			
			if($array[$lpos] =~ m/gtf/){
				$gtf_check = 1;
				$gtf_file = $_;
			}
			
			if($array[$lpos] =~ m/fasta/){
				$fasta_check = 1;
				$fasta_file = $_;
			}
		}
	}
	
	if($gtf_check == 0){
		print "Warning - There is no GTF information for this organism\n";
		print "Please go to ftp://ftp.ensembl.org/pub/$list[$build]/$org_list[$organ]/ to manually retrieve the information.\n";
		print "If you think this error was not caused by you please consult the website and/or tutorial:\n";
		print "http://code.google.com/p/snpdat\n\n\n";
	}
	
	if($fasta_check == 0){
		print "Warning - There is no FASTA information for this organism\n";
		print "Please go to ftp://ftp.ensembl.org/pub/$list[$build]/$org_list[$organ]/ to manually retrieve the information.\n";
		print "If you think this error was not caused by you please consult the website and/or tutorial:\n";
		print "http://code.google.com/p/snpdat\n\n\n";
	}
	
	#now retrieve the fasta information if the directory does exit. Will want to prompt the user to select a FASTA file
	#as the directory structure is not standard nor is the naming for the genome FASTA
	if($fasta_check != 0){
		system("curl -s ftp://ftp.ensembl.org/pub/$list[$build]/$org_list[$organ]/data/fasta/dna/> fasta.dir.list.txt");
		
		open(FAST, "<fasta.dir.list.txt") or die "Error trying to retrieve FASTA information\n";
		
		my @fast_list;
		
		my $rcheck = 0;
		
		while(<FAST>){
			chomp $_;
			
			if($. == 1){
				if($_ =~ m/html/ig){
					$rcheck = 1;
				}
			}
			
			if($rcheck == 1){
				$_ =~ s/  */ /g;
				next unless ($_ =~ m/\.gz/);
				my @array = split(" ", $_, 3);
				$_ =~ s/^.*\"\>//;
				$_ =~ s/\<.*$//;
				
				my $detail = "$_\t$array[2]";
				push(@fast_list, $detail);
				
			}elsif($rcheck == 0){
				
				$_ =~ s/  */ /g;
				next unless ($_ =~ m/\.gz/);
				my @array = split(" ", $_);
				my $dpos = $#array;
				my $detail = "$array[$dpos]\t$array[4]";
				push(@fast_list, $detail);
			}
			
		}
		
		
		for(my $i = 0; $i < @fast_list; $i++){
			print "[$i]\t$fast_list[$i]\n";
		}
		print "\n";
		
		print "*NOTE - if you are looking to download the entire genome - you will probably want to select the largest available file\n";
		print "Please select a FASTA file (enter the corresponding number) to retrieve:\n";
		
		my $fast_ch = <STDIN>;
		chomp $fast_ch;
		
		my $size3 = @fast_list;
		
		if($fast_ch < 0 or $fast_ch =~ m/\D/ or $fast_ch =~ m/[^0-9]/ or $fast_ch > $size3-1){
			error();
		}
		
		my ($seqr, $rest) = split("\t", $fast_list[$fast_ch], 2);
		
		print "You chose:\n$fast_list[$fast_ch]\n\n";
		
		system("curl -O -# ftp://ftp.ensembl.org/pub/$list[$build]/$org_list[$organ]/data/fasta/dna/$seqr");
		print "FASTA information retrieved\n\n";
		
		
	}else{
		print "Warning - There is no FASTA information for this organism\n";
		print "Please go to ftp://ftp.ensembl.org/pub/$list[$build]/$org_list[$organ]/ to manually retrieve the information.\n";
		print "If you think this error was not caused by you please consult the website and/or tutorial:\n";
		print "http://code.google.com/p/snpdat\n\n\n";
	}
	
	my ($gtfr, $rest);
	
	if($gtf_check != 0){
		print "These are the available GTF files for $org_list[$organ]\n\n";
		
		system("curl -s ftp://ftp.ensembl.org/pub/$list[$build]/$org_list[$organ]/data/gtf/ > gtf.dir.list.txt");
		
		open(GTFR, "<gtf.dir.list.txt") or die "Error trying to retrieve GTF information\n";
		
		my @gtf_list;
		my $gcheck = 0;
		
		while(<GTFR>){
			chomp $_;
			
			if($. == 1){
				if($_ =~ m/html/i){
					$gcheck = 1;
				}
			}
			
			#html
			if($gcheck == 1){
				$_ =~ s/  */ /g;
				next unless ($_ =~ m/\.gz/);
				
				my @array = split(" ", $_, 3);
				$_ =~ s/^.*\"\>//;
				$_ =~ s/\<.*$//;
				
				my $detail = "$_\t$array[2]";
				push(@gtf_list, $detail);
				
			}elsif($gcheck == 0){
				$_ =~ s/  */ /g;
				next unless ($_ =~ m/\.gz/);
				my @array = split(" ", $_);
				my $dpos = $#array;
				my $detail = "$array[$dpos]\t$array[4]";
				push(@gtf_list, $detail);
			}
			
			
		}
		
		for(my $i = 0; $i < @gtf_list; $i++){
			print "[$i]\t$gtf_list[$i]\n";
		}
		
		print "\n";
		
		print "*NOTE - if you are looking to download the entire genome - you will probably want to select the largest available file\n";
		print "Please select a GTF file (enter the corresponding number) to retrieve:\n";
		
		my $gtf_ch = <STDIN>;
		chomp $gtf_ch;
		
		my $size4 = @gtf_list;
		
		if($gtf_ch < 0 or $gtf_ch =~ m/\D/ or $gtf_ch =~ m/[^0-9]/ or $gtf_ch > $size4-1){
			error();
		}
		
		print "You chose:\n$gtf_list[$gtf_ch]\n\n";
		
		($gtfr, $rest) = split("\t", $gtf_list[$gtf_ch], 2);
		
		system("curl -O -# ftp://ftp.ensembl.org/pub/$list[$build]/$org_list[$organ]/data/gtf/$gtfr");
		print "GTF information retrieved\n\n";
		
	}

	summary($org_list[$organ], $list[$build], $gtfr);
	
	#remove temp files
	system("rm temp.list2.txt");
	system("rm temp.check.list.txt");
	
	if($fasta_check != 0){
		system("rm fasta.dir.list.txt");
	}
	
	if($gtf_check != 0){
		system("rm gtf.dir.list.txt");
	}
}

system("rm temp.list.txt");

#
#
#
#
#
#









sub error{

print STDOUT <<END;

Error!! Invalid selection. The value you have entered does not correspond to one of the available options.
Please try again.

If you think this error was not caused by you please consult the website and/or tutorial:
http://code.google.com/p/snpdat/

END

exit;

}

sub summary{

print "FASTA information has been retrieved for $_[0] from release $_[1] of ensembl\n";

if($_[2]){
	print "GTF information has been retrieved for $_[2] from release $_[1] of ensembl\n";
}

print "\n.gtf.gz and .fa.gz files need be unzipped using the command \'gzip -d filename\'\n\n";

print "If you have any queries regarding SNPdat or the additional scripts please consult the website:\n";
print "http://code.google.com/p/snpdat/\n\n";

}


