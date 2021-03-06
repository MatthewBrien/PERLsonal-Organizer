#!/usr/bin/perl
use warnings;
use strict;
use DateTime;

#returns a string for month. indexing starts at zero.
my @months = ("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December");
sub MonthName($) {
        my ($index) = @_;
        return ($months[$index-1]);
}

#returns a string for day of the week. indexing starts at zero and sunday.
my @weekdays = ("Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday");
sub DayName($){
    my ($index) = @_;
    return ( $weekdays[$index]);
}

#returns the number of days in a standard month
my @monthlengths = (31,28,31,30,31,30,31,31,30,31,30,31);
sub month_length($){
  my ($index) = @_;
  return( $monthlengths[$index]);
}

sub CalculateCurrentMonth(){
  my  $dt = DateTime->now();
  my  $current_month = ($dt->month) ;
  my  $current_year = $dt->year;
  return (CalculateSpecificMonth($current_year, $current_month));
}
#receive year and month, month is 1 based
sub CalculateSpecificMonth(){

  my $current_year =  $_[0];
  my $current_month = $_[1];

  my %month = ();
  #check if leap year
  $month{'MonthName'} = MonthName($current_month);
  if( $current_month == 2 && LeapYear($current_year)){
    $month{'NumberOfDays'} = 29;
  }
  else{
    $month{'NumberOfDays'} = month_length($current_month-1);
  }


  my $last2digits = $current_year % 100; #(should be 16)
  my $monthnumber  = $current_month;
  #this returns 0 for sunday, 1 for monday...6 for saturday


  $month{'FirstDayOfTheMonth'} = DayOfWeek($current_year, $current_month, 1);

  return (%month);
}
1;

sub LeapYear($){
  #div by 4, and every 400  years is also one
  my ($num) = @_;
	if (($num % 4 == 0) && (($num % 100) != 0 || ($num % 400) == 0)){
     return(1);
	}
  else{
    return(0);
  }
}

sub DayOfWeek(@){
	my $year = $_[0];
	my $month = $_[1];
	my $day = $_[2];
  my @monthz = (0, 3, 3,6,1,4,6,2,5,0,3,5); #month table, look it up. Calendars are weird
  if(LeapYear($year)){
    $monthz[0] = 6;
    $monthz[1]= 2;
  }
    my  $final_day = $year;
    my $temp = int($year/4);
    $final_day += $temp;
    $temp = int($year / 100);
    $final_day -= $temp;
    $temp = int($year / 400);
    $final_day += $temp;
    $final_day += $day;
    $final_day += $monthz[$month-1];
    $final_day--;
    $final_day %= 7;

	return $final_day;
}
1;
