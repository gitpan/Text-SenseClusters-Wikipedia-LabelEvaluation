#!/usr/bin/perl -w

package Text::SenseClusters::Wikipedia::ReadingFilesData;

use strict; 
use encoding "utf-8";

# The following two lines will make this module inherit from the Exporter Class.
require Exporter;
our @ISA = qw(Exporter);

###########################################################################################

=head1 Function: readLinesFromClusterFile
------------------------------------------------

	This function will read lines from the file containing the Labels of the  
	Clusters and make the hash file.

	@argument1	: Name of the cluster file name.
	@argument2	: Reference of Hash ($labelSenseClustersHash) which will hold   
				  the information in the following format:
 					For e.g.: Cluster0{
									Descriptive    => George Bush, Al Gore, White 
														House, New York
									Discriminating => George Bush, York Times	
 							  } 
							  Cluster1{
									Descriptive    => George Bush, BRITAIN London, 
														 Prime Minister
									Discriminating => BRITAIN London, Prime Minister	
 							  } 

	@return 	: It will return the reference of the Hash mentioned above: 
		  			$labelSenseClustersHashRef.
		  			
	@description	:
		1. Read the file line by line.
		
 		2. Ignore the lines which do not follow one of the following format:
     		 Cluster 0 (Descriptive): George Bush, Al Gore, White House, New York
     		 Cluster 0 (Discriminating): George Bush, BRITAIN London
     		 
 		3. Create Key from the "Cluster # (Descriptive)" or "Cluster # (Discrim
			- inating)" as "OuterKey: Cluster#" "InnerKey: Descriptive".
			
 		4. Store the value of hash as the keywords similar to above example:
			for e.g:
			
			  $labelSenseClustersGlobalRef{Cluster0}{Discriminating}
			  			= "BRITAIN London, Prime Minister";
			  
			  
=cut
###########################################################################################

sub readLinesFromClusterFile{ 

	# Reading the cluster file Name from the argument.
	my $clusterFileName = shift;
	
	# Reading the reference from the argument.
	my $labelSenseClustersHashRef = shift;
		
	# Getting the hash from the reference.	
	my %labelSenseClustersHash = %$labelSenseClustersHashRef;

	# Opening the File passed by user as the first command line argument.
	# It should be the name of the cluster file containing the labels.
	open clusterFile, $clusterFileName or die $!;

	while (<clusterFile>){
		# Removing the new line character.
		chomp;
		
		# Removing the white space from the front and end of the word.
		$_ =~ s/^\s+|\s+$//g;
		
		# If the line is empty then ignore that line and go to next line.	
		if($_ eq ''){
			next;
		}

		# Contents of LabelFile.
		#     Cluster 0 (Descriptive): George Bush, Al Gore, White House, New York
		#     Cluster 0 (Discriminating): George Bush, BRITAIN London
		
		# Spiliting each line by ":". 
		my @lineArray = split(/:/, $_);
		
		# If the given do not have Two elements after split. (It means no data for the 
		# given cluster.) Then ignore that cluster.
		if(scalar(@lineArray)!=2){
		  next;
		}

		# Following Code are for making the Key (which will be Cluster Number and Type of 
		# Labels) Typical Key Structure --> "Cluster 0 (Descriptive)"
		
		# Spiliting the elements contianing the information about the key with whitespace
		my @keyArray = split(/\s+/, $lineArray[0]);	
		
		# If something wrong with the structure than ignore the key and carry on with 
		# next line.
		if(scalar(@keyArray)!=3){
			next;
		}
		
		# Making of the Outer key, which is "cluster#"
		my $outerKey = $keyArray[0].$keyArray[1];
		
		# The inner key indicates the type of label i.e. Descriptive or Discriminating. 
		my $innerKey = $keyArray[2];
		
		# Removing the start parenthesis '(' and closing ')' parenthesis from the inner 
		# key.
		$innerKey =~s/[(,)]+//g;
		
		# Setting the keywords associated with this keys as the value.
		# For e.g.: Cluster0{
		#				Descriptive =>		George Bush, Al Gore, White House, New York
		#				Discriminating =>	George Bush, BRITAIN London	
		# 			} 
		$labelSenseClustersHash{$outerKey}{$innerKey} = $lineArray[1];
	}
	
	# Close the file handle.
	close (clusterFile);  
	
	# Returning the reference of the Hash containg the Labels information from 
	# the cluster.
	return \%labelSenseClustersHash;
}



##########################################################################################
=head1 Function: readLinesFromTopicFile

------------------------------------------------

	This function will read lines from the topic file and list of all the 
	topics. 

	@argument1	: Name of the topicFile.
  
	@return 	: String containing the list of all the topics(labels) for  
				  the clusters.
	  
	@description	:
		1. Read the file line by line.
 		2. Remove the new line characters and making string variable which 
  		   contains the list of all the topics.
  		   
=cut
##########################################################################################

sub readLinesFromTopicFile{ 
	
	# Getting the topic file name from argument.
	my $topicFileName = shift;

	# Opening the File, whose name is passed as the second command-line-argument.
	# It is the name of the file which contains the list of the topics for clusters.
	open topicFile, $topicFileName or die $!;
	
	# Defining the variable which will hold all the topics.
	my $topicData = "";
	
	# Reading the file line by line till end of file.
	while (<topicFile>){
		
		# Removing the new line character.
		chomp;
		
		# Concatenating it to previous line.
		$topicData = $topicData.$_;
	}
	
	# Close the file handle.
	close (topicFile);  
		
	# Returning the topic list.
	return $topicData;
}

# Making the default return statement as 1;
# Reference : http://lists.netisland.net/archives/phlpm/phlpm-2001/msg00426.html

1;
