#!/usr/bin/perl -w

# Declaring the Package for the module.
package Text::SenseClusters::Wikipedia::SimilarityScore;

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

# Using Text Similarity Module.
# Reference: http://search.cpan.org/~tpederse
#					/Text-Similarity-0.08/lib/Text/Similarity.pm
use Text::Similarity::Overlaps;


########################################################################################
=head1 Function: computeOverlappingScores
------------------------------------------------


	Function that will compare the labels file with the wiki files and  
	will return the overlapping score. 

	@argument1		: Name of the cluster file.
	@argument2		: Name of the file containing the data from Wikipedia.
	@argument3		: Name of the file containing the stop word lists.
 
	@return 		: Return the overlapping score between these files.
		  
	@description	:
		1). Reading the file name from the command line argument.
		2). Invoking the Text::Similarity::Overlaps module and passing
			the file names for similarity comparison.
 		3). Then overlapping score obtained from this module is returned 
			as the similarity value.

=cut

#########################################################################################

sub computeOverlappingScores{
	 
	# Getting the ClusterFileName from the argument.
	my $clusterFileName = shift;
	
	# Getting the TopicFileName from the argument.
	my $topicFileName = shift;

	# Getting the stop list file location.
	my $stopListFileLocation = shift;
	
	if(!defined $stopListFileLocation){
			 # Getting the module name.
			my $module = "Text/SenseClusters/Wikipedia/SimilarityScore.pm";
			   
			# Finding its installed location.
			my $moduleInstalledLocation = $INC{$module};
		
			# Getting the prefix of installed location. This will be one of 
			# the values in array @INC.
			$moduleInstalledLocation =~ 
				m/(.*)Text\/SenseClusters\/Wikipedia\/SimilarityScore\.pm$/g;
			
			# Getting the installed stopList.txt location using above location. 
			# For e.g.:
			#	/usr/local/share/perl/5.10.1/Text/SenseClusters
			#			/Wikipedia/stoplist.txt
			$stopListFileLocation 
					= $1."/Text/SenseClusters/Wikipedia/stoplist.txt";
			

	}
	# Setting the Options for getting the results from the Text::Similarity
	# Module.
	my %options = ('verbose' => 0, 'stoplist' => $stopListFileLocation);

	# Creating the new Overlaps Object.
	my $mod = Text::Similarity::Overlaps->new (\%options);
	
	# If the object is not created, then quit the program with error message. 
	defined $mod or die "Construction of Text::Similarity::Overlaps failed";

	# Getting the overlapping score from the Similarity function.
	my $score = $mod->getSimilarity ($clusterFileName, $topicFileName);

	# Printing the Similarity Score for the files.
	# print "The similarity of $clusterFile and $topicFile is : $score\n";
	
	# Returning the overlapping Score.
	return $score;
}


