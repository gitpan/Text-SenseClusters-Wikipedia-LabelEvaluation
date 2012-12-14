#!/usr/bin/perl -w

# Declaring the Package for the module.
package Text::SenseClusters::Wikipedia::GetWikiData;

use strict; 
use encoding "utf-8";

# The following two lines will make this module inherit from the Exporter Class.
require Exporter;
our @ISA = qw(Exporter);

# Using WWW::Wikipedia Module.
# Reference: http://search.cpan.org/dist/WWW-Wikipedia/lib/WWW/Wikipedia.pm
use WWW::Wikipedia;

# Defining the Variable for using the Wikipedia Module.
# Reference: http://search.cpan.org/~bricas/WWW-Wikipedia-2.00/
my $wiki = WWW::Wikipedia->new();


##########################################################################################
=head1 function: getWikiDataForTopic
---------------------------------------------------

	This function will fetch data about a topics from the Wikipedia, then it  
	will write the fetched data into a new file 'topic_Name.txt'.


	@argument1	: Name of the topic for which we need to fetch data from the 
 				  Wikipedia.

	@return 	: Name of the file in which this function has written the 
				  data,'topic_Name.txt'.
		  
	@description	:
		1). Reading the topic to read from the function arguments.
		2). Use this topic name to create file name in which we will write
			data about the topic.
 		3). Get the data from the Wikipedia module about the topic and write
			it into the above mentioned topic.
		4). Return the file name.

=cut
##########################################################################################
sub getWikiDataForTopic{
	
	# Read the Topic name from the argument of the function.
	my $topicToLook = shift;
	
	# Removing the white space from the front and end of the word.
	$topicToLook =~ s/^\s+|\s+$//g;

	# Removing the white space with underscore.
	$topicToLook =~ s/\s+/_/g;

	# Creating the fileName from the topic name.
	my $fileName = "temp_$topicToLook.txt";
	
	# Open the file handle in Write Mode.
	open (MYFILE, ">$fileName");

	# Use Wikipedia Search to get the result about the topic.
	# Reference: http://search.cpan.org/~bricas/WWW-Wikipedia-2.00/	
	my $result = $wiki->search($topicToLook);

	# If the entry has some text, write it out to file.
	if ($result){
		# Writing the content of the search result into the newly created file.  
		print MYFILE $result->text();
		
		# Also writing the list of any related items into the files. 
		print MYFILE join( "\n", $result->related() );
	}

	# Close the file handle.
	close (MYFILE);

	# Returning the name of the file in which we write the Wikipedia data 
	# about the given topic.
	return $fileName;
}

