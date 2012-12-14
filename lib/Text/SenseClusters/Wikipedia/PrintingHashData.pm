#!/usr/bin/perl -w

# Declaring the Package for the module.
package Text::SenseClusters::Wikipedia::PrintingHashData;

use strict; 
use encoding "utf-8";

# The following two lines will make this module inherit from the Exporter Class.
require Exporter;
our @ISA = qw(Exporter);


##########################################################################################
=head1 Function: prinHashOfHash
------------------------------------------------

	Function to print the content of  Hash-of-Hash.
 
	@argument1	: Reference of HashOfHash whose values has to be printed. 
	@return 		: Nothing.
				  
	Description:
			1. Iterate through the outer key in sorted order.
			2. Iterate through the inner key and print the corresponding value.

=cut
##########################################################################################
sub prinHashOfHash{
	# Getting the Hash Reference from the argument.
	my $hashOfHashRef = shift; 
	
	# Getting the Hash from its reference.
	my %hashOfHash = %$hashOfHashRef;

	# Step 1: Iterating through the OuterKeys Of the Hash.
	foreach my $sortedOuterKey (sort keys %hashOfHash){
		print "\n\nOuterKey = '$sortedOuterKey'";
	   
	    # Step 2: Iterating through the InnerKeys Of the Hash.
	    foreach my $sortedInnerKey (sort keys %{$hashOfHash{$sortedOuterKey}}){

			# Step 3:Printing the value.
	        print "\nInnerKey=$sortedInnerKey  ".
	        		"Value=$hashOfHash{$sortedOuterKey}{$sortedInnerKey}";        
	    }    
	}
}


##########################################################################################
=head1 Function: prinHashOfScore
------------------------------------------------

	This function will print the score of each cluster and its most
	probable against a topic and its corresponding score.



	For e.g:
	Direct Col Conclusion::	
		Cluster0 		:	Tony_Blair 		,	 0.577
		Cluster1 		:	Bill_Clinton 		,	 0.571
	Direct Row Conclusion::	
		Bill_Clinton 		:	Cluster1	 	,	 0.522
		Tony_Blair 		:	Cluster0 		,	 0.625

	Inverse Row Conclusion::	
		Cluster0 		:	Tony_Blair 		,	 0.625
		Cluster1 		:	Bill_Clinton 		,	 0.522
	Inverse Col Conclusion::	
		Bill_Clinton 		:	Cluster1 		,	 0.571
		Tony_Blair 		:	Cluster0 		,	 0.577

	@Argument	: Reference of HashOfHash 
				 (i)  containing the topic (with supporting score) against a 
				 	   cluster name.
				 (ii) containing the cluster name (with supporting score) 
				 	   against a topic.

	@return 	: Nothing.

	@Description:
			1. Get the HashOfHash Reference from the function argument.
			2. Iterate through key in sorted order.
			3. Clean the key and value.
			4. Write the result into the Output file.

	Output File:

	    Output file is the final file that user can see to get the detailed 
		result about the complete evaluation process.

=cut 
##########################################################################################

sub prinHashOfScore{
	# Getting the Hash Reference from the argument.
	my $topicClusterHashRef = shift; 
	
	# Getting the Hash from its reference.
	my %topicClusterHash = %$topicClusterHashRef;

	# Getting the File Handle from the function argument.
	my $outputFileHandle = shift;

	# Going through Hash and Printing the score.
	# Getting the Key of the Hash in the sorted order.
	foreach my $sortedKey (sort keys %topicClusterHash){
		
		# Extracting the "topic" from the key (FileName is the key).
		my $key = $sortedKey; 	
		
		# Removing the additional text from the key (filename related stuff).
		$key =~ s/temp_//;
		$key =~ s/.txt//;
		
		# Extracting the value from the hash.
		my $value = $topicClusterHash{$sortedKey};
		
		# Removing the additional text from the values (filename related stuff).
		$value =~ s/temp_//;
		$value =~ s/.txt//;
		
		# Writing the data into the output file.
		print $outputFileHandle "\n \t$key \t:\t$value"; 
	}
}

