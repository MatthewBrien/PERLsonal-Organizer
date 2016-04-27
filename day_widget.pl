#!/usr/bin/perl

use warnings;
use strict;
use Tk; #gui support
use DateTime;
use Tk::PNG; #display images in tk
use Tk::Dialog;
require "month.pl";
require "sorttuples.pl";
require "current_weather.pl";
my $main_window;
my $year;
my $month;
my $day;
my $day_name;
my $event_name_ent;
my $event_start_ent;
my $event_end_ent;
my $new_event_name;
my $new_event_start;
my $new_event_end;
my %weather = GetWeather();
my @allevents;
sub AddEvent(@){
  #check if Valid
  (my $start_hour, my $start_min) = split(':',$new_event_start);
  (my $end_hour, my $end_min) = split(':', $new_event_end);
  if(!$new_event_name  || !$new_event_start || !$new_event_end )
  {
    my $dialog = $main_window->Dialog(-title=>"Error", -text=>"Input cannot be blank", -buttons=> ['Okay']);
    $dialog->Show();
  }
  else{
        if(!ValidHour($start_hour) || !ValidHour($end_hour) || !ValidMin($start_min) || !ValidMin($end_min)){
          my $dialog = $main_window->Dialog(-title=>"Error", -text=>"Time out of bounds", -buttons=> ['Okay']);
          $dialog->Show();
        }
        else{
        if( (($start_hour * 60) + $start_min) >= (($end_hour * 60) + $end_min) ){
          my $dialog = $main_window->Dialog(-title=>"Error", -text=>"End time must be after start", -buttons=> ['Okay']);
          $dialog->Show();
        }
        else{
        open(SESAME, '>>Events.txt');
        print SESAME "$year,$month,$day,$new_event_name,$new_event_start,$new_event_end\n";
        close SESAME;

        my $dialog = $main_window->Dialog(-title=>"Event Created", -text=>"Creating new event : $new_event_name from $new_event_start until $new_event_end\n", -buttons=> ['Okay']);
        $dialog->Show();

        $new_event_name='';
        $new_event_start='';
        $new_event_end='';
        $main_window->destroy();
        ShowDay($year,$month, $day);
      }
    }
  }
}
sub ValidHour($){
  my ($hour) = @_;
  if( $hour > 23 || $hour < 0){
    return 0;
  }
  else{
    return 1;
  }
}
sub ValidMin($){
    my ($min) = @_;
    if($min > 59 || $min < 0){
      return 0;
    }
    else{
      return 1;
    }
}
sub ShowDay(@){
  #if day is today , show some weather stuff
  #always, load Events, display the ones for this day
     $year = $_[0];
     $month = $_[1];
     $day = $_[2];
       my $dt = DateTime->now();

    my $day_of_week = DayOfWeek($year,$month,$day);
    my $day_name = DayName($day_of_week);
    my $filename = 'Events.txt';
    my @day_events;
    @allevents=();
    open(my $EventFile, "<", $filename);
    while(<$EventFile>) {
        chomp;
    						(my $event_year, my $event_month, my $event_day, my $event_name, my $event_start_time, my $event_end_time) = split(',');
                push(@allevents, [$event_year,  $event_month,  $event_day,  $event_name,  $event_start_time, $event_end_time]);
                if($event_year eq $year && $event_month eq $month && $event_day eq $day)
                { #if today add to the day's events
                	push(@day_events, [ $event_name,  $event_start_time, $event_end_time]);
    						}
    }
    @day_events = sort{EventStart($a) <=> EventStart($b)}@day_events;

     $main_window = MainWindow -> new (-title=>'Day View', -background=>'black');
     $main_window -> minsize(qw(250 180));

    my $event_canvas = $main_window -> Frame();
    my $list_box = $event_canvas->Scrolled('Listbox',-width=>-1, -height=>8, -font=>'Calibri',-selectmode=>'single',-scrollbars=>'oe', -selectmode=>'single')->pack(-side=>'bottom');
    my $date_lbl = $event_canvas->Label(-text=>"$day_name    $month  / $day / $year" )->pack();
    if($dt->year == $year && $dt->month == $month && $dt->day == $day){
        my $weatherstring = "Current Weather at ".$weather{'location'}."\n".$weather{'temperature string'}."\nToday's weather will be:".$weather{'weather'};
      my $weather_lbl = $event_canvas->Label(-text=>$weatherstring)->pack();
    }
    $event_canvas->Label(-text=>"Scheduled Events:")->pack();


  for(my $i = 0; $i< scalar(@day_events); $i++){
     my $temptext = $day_events[$i][0]." from ".$day_events[$i][1]." to ".$day_events[$i][2]." \n ";
    $list_box->insert('end', $temptext);
  }
  #draw entry boxes and labels
    my $event_name_lbl = $event_canvas->Label(-text=>"New Event Title")->pack();
    $event_name_ent = $event_canvas->Entry(-width=>20, -background=>'white', -textvariable=>\$new_event_name)->pack(-pady=>1);
    my $event_start_lbl = $event_canvas->Label(-text=>"Start Time")->pack();
    $event_start_ent = $event_canvas->Entry(-width=>20, -background=>'white', -textvariable=>\$new_event_start)->pack(-pady=>1);
    my $event_end_lbl = $event_canvas->Label(-text=>"End Time")->pack();
    $event_end_ent = $event_canvas->Entry(-width=>20, -background=>'white', -textvariable=>\$new_event_end)->pack(-pady=>1);
    $event_canvas->pack(-side=>'top', -fill=>'x');

    my $button_canvas = $event_canvas -> Frame();
    my $save_btn = $button_canvas->Button(-text => "Save", -command=>\&AddEvent)->grid(-row=>0, -column=>0, -sticky=>'nsew');
    my $exit_btn = $button_canvas->Button(-text => "Discard",-command => sub{$main_window->destroy})->grid(-row=>0, -column=>1, -sticky=>'nsew');
    my $delete_event_btn = $button_canvas->Button(-text=>'Delete Event', -command=> sub{
        my @selection = $list_box->curselection();
        my @deleted_event = $day_events[$selection[0]];
        #print "-----$deleted_event[0][1]\n";
        splice @day_events, $selection[0] ,1; #remove deleted item from @day_Events
        $list_box->delete('0.0', 'end'); #clear listbox
        #refill listbox
        for(my $i=0; $i<scalar(@day_events); $i++){
          my $temptext = $day_events[$i][0]." from ".$day_events[$i][1]." to ".$day_events[$i][2]." \n ";
          $list_box->insert('end', $temptext);
        }
        #remove deleted event from @allevents
        for(my $i =0; $i < scalar(@allevents); $i++){
          if ($allevents[$i][0] eq $year && $allevents[$i][1] eq $month && $allevents[$i][2] eq $day && $allevents[$i][3] eq $deleted_event[0][0] && $allevents[$i][4] eq $deleted_event[0][1] && $allevents[$i][5] eq $deleted_event[0][2]){
            print "Found matching\n";
            splice @allevents, $i, 1;
            last;
          }
        }
          #delete file, save all contacts back to file, probably a better way to do that.
          system("del Events.txt");
          open(SESAME, '>>Events.txt');
          for(my $i = 0; $i < scalar(@allevents); $i++){
            for(my $ii = 0; $ii < 6; $ii++){
                print SESAME "$allevents[$i][$ii],";
            }
              print SESAME "\n";
          }
            close SESAME;
    })->grid(-row=>0, -column=>2, -sticky=>'nsew');
    $button_canvas->pack(-side=>'bottom', -fill=>'x', -pady=>10, -padx=>10);
  }
1;
