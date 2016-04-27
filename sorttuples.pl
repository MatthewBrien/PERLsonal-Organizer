#!/usr/bin/perl
use warnings;
use strict;
sub EventStart($){
  #[1] is startime
 my $t = $_[0][1];
(my $h, my $m) = split( ':', $t);
return (100*$h + $m );
}

sub LastName(@){
	return $_[0][1];
}
1;
