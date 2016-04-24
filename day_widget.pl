#!/usr/bin/perl

use warnings;
use strict;
use Tk; #gui support
use DateTime;
use Tk::PNG; #display images in tk
require "month.pl";


sub ShowDay(@){

  #if day is today , show some weather stuff
  #always, load Events, display the ones for this day
    my $year = $_[0];
    my $month = $_[1];
    my $day = $_[2];
    my $day_of_week = DayOfWeek($year,$month,$day);
    my $day_name = DayName($day_of_week);
    my $filename = 'Events.txt';
    my @all_events;
    open(my $EventFile, "<", $filename);
    while(<$EventFile>) {
    						(my $event_year, my $event_month, my $event_day, my $event_name, my $event_start_time, my $event_end_time) = split(',');
    						if($event_year == $year && $event_month == $month && $event_day == $day){
    							push(@all_events, "$event_name:  $event_start_time : $event_end_time\n");
    						}
    }
    my $main_window = MainWindow -> new (-title=>'Today',
                                      -background=>'black');


    my $event_canvas = $main_window -> Frame();
    my $date_lbl = $event_canvas->Label(-text=>"$day_name    $month  / $day / $year \n Scheduled Events:")->pack();
    my $size = scalar(@all_events);
    for(my $i = 0; $i< $size; $i++){
      my $lbl = $event_canvas->Label(-text=>$all_events[$i])->pack();
    }
    my $event_name_lbl = $event_canvas->Label(-text=>"New Event Title")->pack();#->grid(-row=>0, -column=>0, -sticky=>'nsew');
    my $event_name_ent = $event_canvas->Entry(-width=>20, -background=>'white')->pack(-pady=>1);
    my $event_start_lbl = $event_canvas->Label(-text=>"Start Time")->pack();#->grid(-row=>0, -column=>0, -sticky=>'nsew');
    my $event_start_ent = $event_canvas->Entry(-width=>20, -background=>'white')->pack(-pady=>1);
    my $event_end_lbl = $event_canvas->Label(-text=>"End Time")->pack();
    my $event_end_ent = $event_canvas->Entry(-width=>20, -background=>'white')->pack(-pady=>1);
    $event_canvas->pack(-side=>'top', -fill=>'x');



    my $button_canvas = $event_canvas -> Frame();
    my $save_btn = $button_canvas->Button(-text => "Save")->grid(-row=>0, -column=>0, -sticky=>'nsew');
    my $exit_btn = $button_canvas->Button(-text => "Discard")->grid(-row=>0, -column=>1, -sticky=>'nsew');
    $button_canvas->pack(-side=>'left', -pady=>10, -padx=>10);
  }

#ShowDay(2016,4,24);
1;
