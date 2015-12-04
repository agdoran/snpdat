<font size='10'>SNPdat</font> (<b>SNP D</b>ata <b>A</b>nalysis <b>T</b>ool) is a high throughput analysis tool that can provide a comprehensive annotation of both novel and known single nucleotide polymorphisms (SNPs). It is specifically designed for use with organisms which are either not supported by other tools or have a small number of annotated SNPs available, however it can also be used to analyse datasets from organisms which are densely sampled for SNPs. It can be used for analysis of any organism with a draft sequence and annotation. SNPdat makes possible analyses involving non-model organisms that are not supported by the vast majority of SNP annotation tools currently available.

You can easily download the software, manual, sample dataset and short tutorial on SNPdat using the downloads tab on the left (http://code.google.com/p/snpdat/downloads/). Additional scripts and a sample input file for SNPdat are available on the downloads page.
<br />
<br />
<font size='5'>Table of Contents</font>




---

# How to use SNPdat #

---

> Running SNPdat with no arguments will also print a short help menu to the screen with some basic functions for running SNPdat.

> _e.g._
```
user@server $HOME/directory/with_all/SNPdat/files/
$ perl SNPdat

Error no arguments supplied.


SNPdat is a high throughput analysis tool that can provide a comprehensive annotation of both novel and known single nucleotide polymorphisms (SNPs).

SNPdat requires that each file is specified when running the program. There are 3 mandatory file definitions.

Usage:
perl SNPdat -i Input_file -f Fasta_file -g Gene_Transfer_File

Flags:

-i      Input file (Mandatory)
-g      Gene transfer file (GTF) (Mandatory)
-f      FASTA formated sequence file (Mandatory)
-d      a dbSNP ASN_FLAT file processed using SNPdat_parse_dbsnp.pl (optional)
-s      a file containing a summary of the queried SNPs (optional)
-o      output_file specified by the user (optional)
        NOTE:If no output file is specified, results will be printed to 'Input_file.output'
        NOTE:If no summary file is specified, summary of results will be printed to 'Input_file.summary'.


For more instuctions see the SNPdat webage:
http://code.google.com/p/snpdat/
```
> (For those of you that have your files ready to run, see section below <b>'Running SNPdat'</b>)
## Some Prerequisites ##
> ### 1. Perl ###
<b>SNPdat</b> is not operating system (OS) dependent but does require Perl to run. Perl will be included in almost all installations of MacOS, Unix and Unix-like OS. Perl is not included in the default installation of Windows but is available. Strawberry Perl (http://strawberryperl.com/) is a perl environment for MS Windows containing all you need to run perl applications. It is designed to be as close as possible to perl environment on UNIX systems. Alternatively, Cygwin (http://www.cygwin.com) can be downloaded and installed for free. Cygwin is a collection of tools which provide a Linux look and feel environment for Windows.

Also, Perl for MacOS and Unix machines in available from http://www.perl.org

## Mandatory Input files: ##
<h3>SNPdat requires three mandatory input files :</h3>

> ### 1. User input file ###
    * <b>SNPdat</b> can take two file formats as user input.
  * <b>The first user input file format</b> accepted by SNPdat is a simple tab-delimited text file. This file should not have any header information. Any line beginning with # will be skipped. This file should contain three columns:
> <pre>chromosome_id	position	mutation</pre>

> _e.g. tab-delmited text file_
```
chr25	1234568	A
chrX	1234568	T
chr19	1234568	G
chr1	1234568	C
```

  * <b>The second user input file format</b> accepted is a Variant Calling Format (VCF) file. This file should be tab-delimited. This file must have a header line that begins with <b>##fileformat=vcf</b>. Any line after the first that begins with # will be skipped. This file should have as its first five columns:
> <pre>Chromosome_id	position	snp_id	ref_base	mutation</pre>

Any column after the first five will be ignored by SNPdat
> _e.g. VCF file_
```
##fileformat=vcfv4.0
##_This line will be ignored by SNPdat_
#_This line will also be ignored_
##_ This line will be ignored_
chr25	1234568	SNPid1	T	A
chrX	1234568	SNPid2	C	T
chr19	1234568	SNPid3	C	G
chr19	1234568	SNPid4	C	A
chr1	1234568	SNPid5	G	C
```


---

> ### 2. Gene annotation file (GTF) ###
    * The GTF (General Transfer Format) is identical to GFF version 2. GTF files must have 9 fields and must be tab-separated. The first eight GTF fields are the same as GFF. The ninth field (called group field in GFF) has been expanded into a list of attributes. Each attribute consists of a type/value pair. Attributes must end in a semi-colon, and be separated from any following attribute by exactly one space.

> The attribute list must begin with the two mandatory attributes:

  * gene\_id value - A globally unique identifier for the genomic source of the sequence.
  * transcript\_id value - A globally unique identifier for the predicted transcript.

> _A brief description of the GTF fields_
    1. seqname - name of the chromosome or scaffold; chromosome names cane be given with or with out the 'chr' prefix
    1. source - name of the program that generated this feature, or the data source (database or project name)
    1. feature - feature type name, _e.g._ Gene, Variation, Similarity
    1. start - start position of the feature, with sequence numbering starting at 1
    1. end - end position of the feature, with sequence numbering starting at 1
    1. score - a floating point value
    1. strand - defined as + (forward) or - (reverse)
    1. frame - One of '0', '1', '2'. '0' indicates that the first base of the feature is the first base of a codon, '1' that the second base is the first base of a codon, and so on..
    1. attribute - a semicolon-separated lkist of tag-value pairs, providing additional information about each feature



For additional information on GTF specification see: http://genome.ucsc.edu/FAQ/FAQformat#format4

> _e.g. GTF file_
```
chr20   protein_coding  exon    371915  372086  .       -       .        gene_id "ENSBTAG00000024801"; transcript_id "ENSBTAT00000034533"; exon_number "1"; gene_name "RANBP17"; transcript_name "RANBP17";
chr20   protein_coding  CDS     371915  372086  .       -       0        gene_id "ENSBTAG00000024801"; transcript_id "ENSBTAT00000034533"; exon_number "1"; gene_name "RANBP17"; transcript_name "RANBP17"; protein_id "ENSBTAP00000034423";
chr20   protein_coding  start_codon     372083  372086  .       -       0        gene_id "ENSBTAG00000024801"; transcript_id "ENSBTAT00000034533"; exon_number "1"; gene_name "RANBP17"; transcript_name "RANBP17";
chr20   protein_coding  exon    368319  368410  .       -       .        gene_id "ENSBTAG00000024801"; transcript_id "ENSBTAT00000034533"; exon_number "2"; gene_name "RANBP17"; transcript_name "RANBP17";
```



---

> ### 3. FASTA sequence file ###
> > Fasta format is a text-based format for representing nucletide sequences, in which nucleotides are represented using a single-letter code (A,T,C,G). A sequence in FASTA format begins with a single line description. The description line is distinguished from the sequence data by a greater than (">") symbol at the beginning of the line. The word following the ">" symbol is the identifier of the sequence. There should be no space between the ">" and the first letter of the identifier.


> _e.g. fasta file_
```
>chr20
CCCACGTGAAACATCTGGAGGAGCACCTGGACACGGCCAGGAAGGACCTCATCAAGTCCA
AGGACATAAACAGAAAACTTGAGCGGGACGTCCGCGAAGTGAGTGACTGCAGCTGTGTCT
GTTGTCTTGAGGTGGAATGTGGGTTTCTTGTTCTCCCGGGGATCTCAGCCTTGGGATGGC
TGCGTGAGTAAGAGCAGAGCACTGGAGAGACCACAACTGGCTGCCTCCCTGCCTCCGCAT
CAAGGTCTCTGGGGTAGAAGAGGCCTGGTCCAGGCGGTCCGTTGGCAGTGGACCAACATG
AGGGCAGCCCTGACGCTGTGCCGCACCCTGGGTGTGGGCTCCTCATTTCCACAAGTTCTA
```


---

> ### Some notes on the input files ###
  * Note that the identifier format for all input files is the same. Even if the chromosome name differs, the format must remain the same. _i.e._ They all have chr preceeding the chromosome name (Similarily none of the identifiers have this).

  * A list of organisms with FASTA and GTF files is available from ensembl http://www.ensembl.org/info/data/ftp/index.html). A supplementary script is available to help users retrieve FASTA and GTF files. This is called <b>GTF_FASTA_finder.pl</b> and is included on the downloads page.

> 
---

> > ### Additional script for retrieving FASTA and GTF files ###
  * <b>GTF_FASTA_finder.pl</b> is an additional script provided with SNPdat.

  * This is an interactive script designed to retrieve FASTA (dna) and GTF files from Ensembl. You will need to be connected to the internet to use this script. This is written in Perl but uses the system call cURL to retrieve the information from Ensembl. cURL is a part of most Linux distributions and Mac OS X and can also be provided for windows through cygwin, which is a collection of tools that provide a Linux-like environment for windows. To run this script simply type <b>'perl GTF_FASTA_finder.pl'</b> into your terminal and follow the prompts.
> > <h3>e.g.</h3>_```
user@server $HOME/directory/with_all/SNPdat/files/
$ perl GTF_FASTA_finder.pl
|36| /pub/release-56    |37| /pub/release-57    |38| /pub/release-58
|39| /pub/release-59    |40| /pub/release-60    |41| /pub/release-61
|42| /pub/release-62    |43| /pub/release-63    |44| /pub/release-64
|45| /pub/release-65    |46| /pub/release-66    |47| /pub/release-67

Please select a release to choose from by typing its number:
47
You chose release-67

|0| ailuropoda_melanoleuca
|1| ancestral_alleles
|2| anolis_carolinensis
|3| bos_taurus
.
.
.
|56| tursiops_truncatus
|57| vicugna_pacos
|58| xenopus_tropicalis

Please select an organism (enter the corresponding number) to retrieve the FASTA file for:
46

You chose organism Saccharomyces_cerevisiae
Now retrieving the relevant FASTA file for this organism
######################################################################## 100.0%

|0| ailuropoda_melanoleuca
|1| anolis_carolinensis
|2| bos_taurus
.
.
.
|55| tursiops_truncatus
|56| vicugna_pacos
|57| xenopus_tropicalis

Please select an organism (enter the corresponding number) to retrieve the GTF file for:
45

Now retrieving the selected GTF file
Retrieving GTF: Saccharomyces_cerevisiae.EF4.67.gtf.gz
######################################################################## 100.0%
FASTA information has been retrieved for saccharomyces_cerevisiae from release release-67 of ensembl
GTF information has been retrieved for saccharomyces_cerevisiae from release release-67 of ensembl

.gtf.gz and .fa.gz files need be unzipped using the command 'gzip -d filename'

If you have any queries regarding SNPdat or the additional scripts please consult the website:
http://code.google.com/p/snpdat/

```_

For more information see the SNPdat tutorial


---

## Optional Input File: ##
  * <h4>A processed FLAT file </h4>
<b>SNPdat</b> can also cross reference queries against information from external databases. One such database is <b>dbSNP</b> (http://www.ncbi.nlm.nih.gov/snp/).
<b>SNPdat_parse_dbsnp.pl</b> can be used to process a FLAT file (found in the ASN1\_FLAT directory for an organism) from dbSNP and output a file in the required format for SNPdat. These files are typically '.flat.gz' and so will have to be unzipped using the 'gzip -d filename' command. You should then be left with a file that has the extension '.flat'. This file is then used as an input file for '<b>SNPdat_parse_dbsnp.pl</b>'. A list of organisms for which dbSNP FLAT files exist can be found [ftp://ftp.ncbi.nih.gov/snp/organisms/](ftp://ftp.ncbi.nih.gov/snp/organisms/) <br />

### Additional script for retrieving FLAT files from dbSNP ###

Or you can use '<b>dbSNP_finder.pl</b>' to get dbSNP flat files for organisms contained in [ftp://ftp.ncbi.nih.gov/snp/organisms/](ftp://ftp.ncbi.nih.gov/snp/organisms/)

> <h3>e.g.</h3>_```
user@server $HOME/directory/with_all/SNPdat/files/
$ perl dbSNP_finder.pl

|0| Alectoris_9077/
|1| Bos_29061/
|2| almond_3755/
.
.
.
|109| zebrafish_7955/
|110| zebu_9915/
|111| zostera_29655/

Please select and organism by typing its corresponding number
6
You have chosen: arabidopsis_3702/

Retrieving file: 'ds_flat_ch1.flat.gz'
################################################################### 100.0%
Retrieving file: 'ds_flat_ch2.flat.gz'
################################################################### 100.0%
Retrieving file: 'ds_flat_ch3.flat.gz'
################################################################### 100.0%
Retrieving file: 'ds_flat_ch4.flat.gz'
################################################################### 100.0%
Retrieving file: 'ds_flat_ch5.flat.gz'
################################################################### 100.0%
Retrieving file: 'ds_flat_chMasked.flat.gz'
################################################################### 100.0%
Retrieving file: 'ds_flat_chMulti.flat.gz'
################################################################### 100.0%
Retrieving file: 'ds_flat_chNotOn.flat.gz'
################################################################### 100.0%
Retrieving file: 'ds_flat_chPltd.flat.gz'
################################################################### 100.0%
Retrieving file: 'ds_flat_chUn.flat.gz'
################################################################### 100.0%

Now you will need to unzip these files.
This can be done using gzip -d
e.g.
gzip -d ds_*.gz

If you wish to use these (unzipped) files for SNPdat please run 'SNPdat_parse_dbSNP.pl' to process them first
You may want to join these files before using SNPdat_parse_dbSNP.pl
To join these files you can use the 'cat' command
e.g.
cat ds*.flat > ds_arabidopsis_3702.all.flat
```_

  * <h4>A processed FLAT file </h4>
This is the output file from <b>SNPdat_parse_dbsnp.pl</b><br />
<b>SNPdat_parse_dbsnp.pl</b> can be used to process a FLAT file (found in the ASN1\_FLAT directory for an organism) from dbSNP and output a file in the required format for SNPdat.

### Preparing the optional input file ###
An additional script called <b>SNPdat_parse_dbSNP.pl</b> can be used to convert a dbSNP FLAT file into a format that can be used by <b>SNPdat</b>.<br />
<b>This can be used as follows</b><br />
```
user@server $HOME/directory/with_all/SNPdat/files/

$ perl SNPdat_parse_dbSNP.pl the_input_file.FLAT processed_output.txt
```

You will then be prompted to type the name of the assembly you want to map to:

```
This is a perl script to process a dbSNP FLAT file of SNP data and produce
an output file that can be supplied as input for the software SNPdat

Please enter the assembly you want to map RS ids to
:
```

Once you have enter this `[and hit return]` the script will continue

_e.g._
```
This is a perl script to process a dbSNP FLAT file of SNP data and produce
an output file that can be supplied as input for the software SNPdat

Please enter the assembly you want to map RS ids to
:UMD3.1

The resulting output file is processed_output.txt
This file can be used as input for SNPdat using the -d switch
```

<br />
<b>Now that the optional input file is ready you can run SNPdat with all<br>
input files</b>
<br />

---

## Output file: ##
Specifying an output file is not necessary but can be done.
  * if no output file is specified the results will be printed to an output file with the same name as the input file but with the suffix <b>.output</b>
  * for more information on specifying the output file see section 'Running SNPdat'
> ### Output file format ###
    * SNPdat will produce a tab-delimited file as output. This file can have upto 25 columns of results.

|Column Number|Description|
|:------------|:----------|
|1            |The queried SNPs chromosome ID|
|2            |The queried SNPs genomic location|
|3            |Whether or not the queried SNP was within a feature|
|4            |Region containing the SNP; either exonic, intronic or intergenic|
|5            |Distance to nearest feature|
|6            |Either the closest feature to the SNP or the feature containing the SNP|
|7            |The number of different features that the SNP is annotated to|
|8            |The number of annotations of the current feature|
|9            |Start of feature (bp)|
|10           |End of feature (bp)|
|11           |The gene ID for the current feature|
|12           |The gene name for the current feature|
|13           |The transcript ID for the current feature|
|14           |The transcript name for the current feature|
|15           |The exon that contains the current feature and the total number of annotated exons for the gene containing the feature|
|16           |The strand sense of the feature|
|17           |The annotated reading frame (when contained in the GTF)|
|18           |The reading frame estimated by SNPdat|
|19           |The estimated number of stop codons in the estimated reading frame|
|20           |The codon containing the SNP, position in the codon and reference base and mutation|
|21           |The amino acid for the reference codon and new amino acid with the mutation in place|
|22           |Whether or not the mutation is synonymous|
|23           |The protein ID for the current feature|
|24           |The RS identifier for queries that map to known SNPs|
|25           |Error messages, warnings etc|


<p><b>Note</b><br />Additional warnings are included in the output file columns:</p>
<p><code>*</code> - Tie between two or more reading frames. The reading frame closest to the strand sense will be chosen</p>
<p><code>**</code> - Strand sense not annotated in the GTF annotation file. This will be assumed to be +</p>
<p><code>*^</code> - This SNPs was equidistance from more than one feature. Both features will be reported</p>


---

# Running SNPdat #

---

SNPdat requires that each file are specified when running the program.
There are six file definitions.
  1. `-i input_file`
  1. `-g GTF_file`
  1. `-f FASTA_file`
  1. `-d dbSNP_processed_file`
  1. `-o output_file`
  1. `-s summary_file`<br />

There are other options available for use with SNPdat. Please the manual for more information regarding additional options and advanced options.

<h3>e.g.</h3>_```
perl SNPdat.pl -i input_file -g GTF_file -f FASTA_file -d dbSNP_processed_file
```_

Specifying an output file is optional. In the above code no output file is specified and so the results will be printed to `input_file.output`. Below is an example with the output file specified

```
perl SNPdat.pl -i input_file -g GTF_file -f FASTA_file -d dbSNP_processed_file -o output_file
```

Results from the above will be printed to `output_file`.<br />
As SNPdat is running you shoud see progress reports as follows:
```
start time:
DAY MON  1 HOUR:MIN:SEC IST YEAR
DAY MON  1 HOUR:MIN:SEC IST YEAR
DAY MON  1 HOUR:MIN:SEC IST YEAR
GTF parsed:
DAY MON  1 HOUR:MIN:SEC IST YEAR
User input parsed:
DAY MON  1 HOUR:MIN:SEC IST YEAR
Finished analysing all SNPs with sequence information
:DAY MON  1 HOUR:MIN:SEC IST YEAR
Finished analysing all SNPs with no sequence information
:DAY MON  1 HOUR:MIN:SEC IST YEAR
SNPdat finished analysing all SNPs:
DAY MON  1 HOUR:MIN:SEC IST YEAR
view file 'output_file' for results
```


All together you should see this on your screen:
```

perl SNPdat.pl -i input_file -g GTF_file -f FASTA_file -d dbSNP_processed_file -o output_file
start time:
DAY MON  1 HOUR:MIN:SEC IST YEAR
DAY MON  1 HOUR:MIN:SEC IST YEAR
DAY MON  1 HOUR:MIN:SEC IST YEAR
GTF parsed:
DAY MON  1 HOUR:MIN:SEC IST YEAR
User input parsed:
DAY MON  1 HOUR:MIN:SEC IST YEAR
Finished analysing all SNPs with sequence information
:DAY MON  1 HOUR:MIN:SEC IST YEAR
Finished analysing all SNPs with no sequence information
:DAY MON  1 HOUR:MIN:SEC IST YEAR
SNPdat finished analysing all SNPs:
DAY MON  1 HOUR:MIN:SEC IST YEAR
view file 'output_file' for results

```


---

# <b>Further instructions</b> #
Further instructions for using SNPdat and any of the additional scripts can be found in the short tutorial and the manual on the downloads page. Sample data to run SNPdat can also be found on the downloads page.
http://code.google.com/p/snpdat/downloads/list

---

# <b>Updates</b> #
> <p>
<img src='http://dl.dropbox.com/u/95381569/new2.png' alt='as' width='50' height='50' />: <b>New release of SNPdat now available: SNPdat_v1.0.5 (April 2013)</b></p><p>This version now includes bug fixes for information crossing feature boundaries. A new feature is also now available from this version onwards. The '-x' option - retrieve information across feature boundaries when appropriate. Please see the manual before using this option and for more information about how it works.</p>

<p><img src='http://dl.dropbox.com/u/95381569/new2.png' alt='as' width='50' height='50' />: <b>New release of SNPdat now available: SNPdat_v1.0.4 (FEB 2013)</b></p><p>This version now includes summary file specification with the -s option on the command line. The summary file will now always print to an output file even if one is not specified</p>

<p><img src='http://dl.dropbox.com/u/95381569/new2.png' alt='as' width='50' height='50' />: <b>SNPdat has been published in BMC Bioinformatics (Feb 2013)</b></p><p>SNPdat can now be cited as:</p><p>Doran AG, Creevey CJ: <b>Snpdat: Easy and rapid annotation of results from de novo snp discovery projects for model and non-model organisms.</b> BMC Bioinformatics 2013, <b>14</b>(1):45.</p>

<p><img src='http://dl.dropbox.com/u/95381569/new2.png' alt='as' width='50' height='50' />:<b> Error running GTF_FASTA_finder.pl (Jan 2013)</b>
<blockquote>This error was caused by the program expecting a different format returned when getting a directory listing using cURL. It is now fixed and should work for all instances of cURL.</p></blockquote>

> ==== From GTF\_FASTA\_finder\_v1.0.4.pl onwards this has been corrected.



---

# <b>Authors and Contact</b> #
Anthony G Doran<sup>1,2</sup>, Christopher J Creevey<sup>1</sup><br />
<sup>1</sup>Teagasc Animal and Bioscience Research Department, Animal & Grassland Research and Innovation Centre, Teagasc, Grange, Dunsany, Co. Meath, Ireland.<br />
<sup>2</sup>Molecular Evolution and Bioinformatics Unit, Biology Department, NUI Maynooth, Maynooth, Co. Kildare, Ireland.<br />

<b><h3>Corresponding authors:</h3></b>
chc30@aber.ac.uk and anthony.g.doran@gmail.com<br />
Queries can be directed to either of the above email addresses.

SNPdat is freely available under a GNU Public License (Version 2 - http://www.gnu.org/licenses/gpl-2.0.html) at:<br />http://code.google.com/p/snpdat<br />



---

# How to Cite SNPdat #

---

The published manuscript for SNPdat is available from BMC Bioinformatics (http://www.biomedcentral.com/1471-2105/14/45#).<br />
SNPdat can be cited as:<br />Doran AG, Creevey CJ: <b>Snpdat: Easy and rapid annotation of results from de novo snp discovery projects for model and non-model organisms.</b> BMC Bioinformatics 2013, <b>14</b>(1):45.<br>

<hr />

