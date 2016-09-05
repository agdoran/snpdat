#!usr/bin/perl -w 
use strict;


print STDOUT <<END;

This is dbSNP_finder.0.1.pl
This is an additional script included in the main SNPdat package.
dbSNP_finder.pl can be used to retrieve dbSNP information for organisms from dbSNP.
You will need an internet connection and cURL installed on your machine.
See code.google.com/p/snpdat/ for more information

END


system("curl -s ftp://ftp.ncbi.nih.gov/snp/organisms/ > temp.dbsnp.txt");

open(ORGS, "temp.dbsnp.txt") or die "Error cannot open the directory\n";

my $check = 0;

my @organs;

#
#	get the organism list
#

while(<ORGS>){
	chomp $_;
	
	if($. == 1){
		if($_ =~ m/html/ig){
			$check = 1;
		}
	}
	
	if($check == 1){
		
		next unless ($_ =~ m/directory/ig);
		next unless ($_ =~ m/\/organisms\//);
		
		next unless ($_ =~ m/\/\"/);
		
		$_ =~ s/^.*\/snp\/organisms\///;
		$_ =~ s/\/\".*$//;
		
		push(@organs, $_);
		
	}elsif($check == 0){
		
		$_ =~ s/  */ /;
		
		next unless ($_ =~ m/^d/);
		my @array = split(" ", $_);
		
		my $orga = $#array;
		
		push(@organs, $array[$orga]);
	}

}

close(ORGS);

#print the organism list and prompt the user to select an organism
for(my $i = 0; $i < @organs; $i++){
	
	print "[$i]\t$organs[$i]\n";
	
}
print "\n";

print "Please select an organism from the above list by typing the corresponding number\n";

my $choice = <STDIN>;
chomp $choice;
my $size = @organs;

#choice is not compatible rm temp file and print error messege
if($choice < 0 or $choice =~ m/\D/ or $choice > $size-1){
	
	system("rm temp.dbsnp.txt");
	
	error();
	
}

#tell the user what they have selected
print "You have chosen: $organs[$choice]\n";

#get the ASN1_flat file directory listing
system("curl -s ftp://ftp.ncbi.nih.gov/snp/organisms/$organs[$choice]/ASN1_flat/ > temp2.dbsnp.txt");

open(ASN, "temp2.dbsnp.txt") or die "Error ppening the ASN1_flat file directory listing\n";

$check = 0;

my @chrs;
my $dbsnp_check = 0;


while(<ASN>){
	chomp $_;
	
	
	if($_ =~ m/.gz/){
		$dbsnp_check = 1;
	}
	
	
	if($. == 1){
		
		if($_ =~ m/html/ig){
			$check = 1;
		}
		
	}
	
	#if html format
	if($check == 1){
		
		next unless ($_ =~ m/\/ASN1_flat\//);
		
		$_ =~ s/^.*ASN1_flat\///;
		$_ =~ s/\"\>.*$//;
		
		push(@chrs, $_);
		
	}
	#if not htm format
	elsif($check == 0){
		
		next if($_ =~ m/^d/);
		next unless($_ =~ m/.gz/g);
		
		$_ =~ s/  */ /;
		
		my @array = split(" ", $_);
		my $chr = $#array;
		
		push(@chrs, $array[$chr]);
		
	}
	
	
}

close(ASN);

#make sure there is dbsnp information available
if($dbsnp_check != 0){

	$size = @chrs;

	$chrs[$size] = "Retrieve all chromosome files";

	for(my $i = 0; $i < @chrs; $i++){
		print "[$i]\t$chrs[$i]\n";
	}

	print "\n";

	print "Please select a chromosome from the above list by typing the corresponding number\n";
	print "If you would like to retrieve all chromosomes please select the last option\n";


	my $rchoice = <STDIN>;
	chomp $rchoice;
	my $rsize = @chrs;


	#choice is not compatible rm temp file and print error messege
	if($rchoice < 0 or $rchoice =~ m/\D/ or $rchoice > $rsize-1){
		
		system("rm temp.dbsnp.txt");
		system("rm temp2.dbsnp.txt");
		
		error();
		
	}


	#tell the user what they have selected
	print "You have chosen:\n$chrs[$rchoice]\n\n";

	#retrieve all chr files
	if($rchoice == $#chrs){
		
		for(my $i = 0; $i < $#chrs; $i++){
			
			print "Retrieving $chrs[$i]\n";
			
			system("curl -O -# ftp://ftp.ncbi.nih.gov/snp/organisms/$organs[$choice]/ASN1_flat/$chrs[$i]");
			
		}
		
		system("rm temp.dbsnp.txt");
		system("rm temp2.dbsnp.txt");
		
	}
	#otherwise retrieve the selected
	else{
		
		print "Retrieving\n$chrs[$rchoice]\n";
		
		
		system("curl -O -# ftp://ftp.ncbi.nih.gov/snp/organisms/$organs[$choice]/ASN1_flat/$chrs[$rchoice]");
		
		#remove temp files
		system("rm temp.dbsnp.txt");
		system("rm temp2.dbsnp.txt");
		
	}

}else{
	print "Error. No dbSNP information available for the selected organism";
	print "If you think this error messege is incorrect please go to the URL ftp://ftp.ncbi.nih.gov/snp/organisms/$organs[$choice] to manually retrieve SNP information\n";
	print "If you think this error was not caused by you please consult the website and/or tutorial:\nhttp://code.google.com/p/snpdat/\n";

	system("rm temp.dbsnp.txt");
	system("rm temp2.dbsnp.txt");
}






sub error{

print STDOUT <<END;

Error!! Invalid selection. The value you have entered does not correspond to one of the available options.
Please try again.

If you think this error was not caused by you please consult the website and/or tutorial:
http://code.google.com/p/snpdat/

END

exit;

}

