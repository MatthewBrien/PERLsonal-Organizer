#!/usr/bin/perl
use warnings;
use strict;
sub SortTuples(@){
  #sorry for the bubble sort
  #sorting events on a given day, shouldn't be too many....
  my $size = scalar(@_);
  #print "Unsorted \n";
  #for(my $i=0;$i<$size;$i++){
  #    print "\n tuple $i is $_[$i][0] $_[$i][1] $_[$i][2] $_[$i][3]\n ";
  #}
  for(my $i = 0; $i< $size-1; $i++){
    for(my $ii = 0; $ii < $size - $i-1; $ii++){

      if($_[$ii][0] > $_[$ii+1][0]){
      my $temp = $_[$ii];
      $_[$ii]=$_[$ii+1];
      $_[$ii+1] = $temp;
      }
    }
  }
  #print "Sorted\n";
  #for(my $i=0;$i<$size;$i++){
#      print "\n tuple $i is $_[$i][0] $_[$i][1] $_[$i][2] $_[$i][3]\n \n";
  #}

  return(@_);
}

sub LastName(@){
		return $_[0][1];
}
1;
