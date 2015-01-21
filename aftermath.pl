#!/usr/bin/perl

#This Perl script performs calculations on the output data from the in silico digestion
#script "restrict.pl". Put input files ("mchrXfrags.txt") in the same directory as
#script. Input files contain tab separated numbers, where each number represents the
#length of a restriction fragment. Modify this script as necessary.
use warnings;

sub fileToArr;
sub concatArrs;
sub calc;

#Read in data from files output from "restrict.pl"
@array1 = fileToArr("mchr1frags.txt");
@array2 = fileToArr("mchr2frags.txt");
@array3 = fileToArr("mchr3frags.txt");
@array4 = fileToArr("mchr4frags.txt");
@array5 = fileToArr("mchr5frags.txt");
@array6 = fileToArr("mchr6frags.txt");
@array7 = fileToArr("mchr7frags.txt");
@array8 = fileToArr("mchr8frags.txt");
@array9 = fileToArr("mchr9frags.txt");
@array10 = fileToArr("mchr10frags.txt");
@newarr=("a", "b");
concatArrs(@array1);
concatArrs(@array2);
concatArrs(@array3);
concatArrs(@array4);
concatArrs(@array5);
concatArrs(@array6);
concatArrs(@array7);
concatArrs(@array8);
concatArrs(@array9);
concatArrs(@array10);
shift(@newarr);
shift(@newarr);
open(OUT, ">>array.txt");
foreach $el (@newarr)
	{	print(OUT "\t");
		print(OUT "$el");	}
close(OUT);
calc(@newarr);






#Reads data on the bp length of restriction fragments from a file into an array
sub fileToArr
{
	$infile = $_[0];

	# Create filehandle (specifies the text file as source of input data) and print error message if the file
	# can't be found (assumes the file is in the same directory as this script)
	if(!open(DATA, "$infile"))
		{	die "\nThe file '$infile' could not be opened!\n";		}

	# Import contents of the text file to an array (every row in the file becomes one element in the array).
	@content=<DATA>;
	close(DATA);

	# Remove first 8 rows of file (those rows constitute header)
	shift(@content);shift(@content);shift(@content);shift(@content);shift(@content);shift(@content);shift(@content);shift(@content);

	# Concatenate array elements to a scalar (keeps tabs between fragments)
	$lines=join("", @content);

	# Split scalar (at tabs) into elements (= raw fragments) and send to new array
	@rawfrags=split(/\t/, $lines);

	# Remove empty elements from @rawfrags and send the rest to new array, @cleanfrags
	@cleanfrags = ("a", "b");
	foreach $rawfrag (@rawfrags)
		{	if($rawfrag =~ /^\s*$/)		# removes empty elements
				{	next;	}
			else
				{	push(@cleanfrags, $rawfrag);	}		
														}
	shift(@cleanfrags);
	shift(@cleanfrags);

	# Remove whitespace from elements in @cleanfrags
	foreach $cleanfrag (@cleanfrags)
		{	$cleanfrag =~ s/\s//g;	}
		
	return @cleanfrags;																					
																				}


#Concatenates arrays to one																				
sub concatArrs	
{
	@oldarr = @_;
	foreach $element (@oldarr)
		{	push(@newarr, $element);	}
												}


#Performs calculations on the length, number and genomic representation of
#restriction fragments in a given size interval that the user specifies
sub calc
{	# Accept input
	@arr=@_;
	$fragno=(scalar(@arr));
	
	# Sum the length of all the fragments and send to variable $genlen
	$genlen=0;
	foreach $frag (@arr)
		{	$genlen=$genlen+$frag;	} 

	# Ask the user to specify a fragment length interval
	print("\nPlease enter the lower limit of the range of fragment lengths: ");
	$lower=<STDIN>;
	chomp($lower);
	print("\nPlease enter the upper limit of the range of fragment lengths: ");
	$upper=<STDIN>;
	chomp($upper);

	# Send all fragments in that interval to new array (@selfrag)
	# Count no. of fragments in that interval
	# Send that number to new variable ($selfragno)
	@selfrag=(3,3);
	foreach $frag (@arr)
		{	if( ($frag>=$lower) && ($frag<=$upper) )
				{	push(@selfrag, $frag);	}								}	
	shift(@selfrag);
	shift(@selfrag);
	$selfragno=scalar(@selfrag);
	$fragfract=($selfragno/$fragno);

	# Sum length of all fragments in selected interval and send to variable $sellen
	$sellen=0;
	foreach $fra (@selfrag)
		{	$sellen=$sellen+$fra;	}

	# Divide $sellen by $genlen and send to variable $genfract
	$genfract=($sellen/$genlen);

	# Print $genlen, $selfragno, $sellen and $genfract
	open(OUT, ">>Result_$lower\-$upper.txt");
	print(OUT "In silico digestion results for Salmo salar with EcoRI.\nFragment length range: $lower - $upper\n\n");
	print(OUT "\nThe total genome length is $genlen bp\n");
	print(OUT "\nThe total number of fragments is $fragno \n");
	print(OUT "\nThe number of fragments in the selected interval is $selfragno. This constitutes $fragfract of the total number of fragments.\n");
	print(OUT "\nThe total length of the selected fragments is $sellen bp.\n");
	print(OUT "\nThe fragments in the selected interval constitute $genfract of the total genome length\n\n");
	
	print("\n\nThank You!\n");
	print("\nThe total genome length is $genlen bp\n");
	print("\nThe total number of fragments is $fragno \n");
	print("\nThe number of fragments in the selected interval is $selfragno. This constitutes $fragfract of the total number of fragments.\n");
	print("\nThe total length of the selected fragments is $sellen bp.\n");
	print("\nThe fragments in the selected interval constitute $genfract of the total genome length\n\n");
																												}
