#!/usr/bin/perl

use warnings;
use strict;
use Tk; #gui support
use DateTime;
use Tk::PNG; #display images in tk

require "month.pl";


#main variables
my $main_window;
my $menu_bar;
my $file_mb;
my $calender_canvas; #holds the day grid
my @day_buttons; #
my $month_canvas; #canvas holding all day buttons
my $month_lbl; #label showing the current month
my $weekday_canvas;
my $year_lbl;
my $next_btn;
my $prev_btn;
my $current_display_month; #one based
my $current_display_year = 2016;

#takes the new year[0], month[1]
sub SwitchMonth($){
    my ($direction) = @_;
    if($direction == 1){
    if($current_display_month == 12)
    {
        $current_display_year++;
        $year_lbl->configure(-text=>$current_display_year);
        $current_display_month = 1;
      }
      else{
        $current_display_month++;
      }
    }
    else{
      if($current_display_month == 1)
      {
        $current_display_year--;
        $year_lbl->configure(-text=>$current_display_year);
        $current_display_month = 12;
      }
      else{
        $current_display_month--;
      }
    }
    my $length = scalar(@day_buttons);
      my %month = CalculateSpecificMonth($current_display_year, $current_display_month);
      my $countdown = $month{'FirstDayOfTheMonth'};
      my $daycounter = $month{'NumberOfDays'} - 1;

      for(my $i =0; $i < $length; $i++){
        my $text = '';
        if($countdown ==0 && $daycounter >= 0){
          my $temp = $month{'NumberOfDays'} - $daycounter;
          $text = $temp;
          $daycounter--;
        }
        else{
          $countdown--;
        }
      $day_buttons[$i]->configure(-text=>$text);
      }
      $month_lbl->configure(-text=>$month{'MonthName'});
      #get start of the month and month length

}
#draw the main window, menu bars, buttons etc.
sub DrawWindow{
  $main_window = MainWindow -> new(-title=>"PERLsonal Organizer",
                                      -background=>'black'
                                      );
      $main_window -> minsize(qw(550 550));
      $menu_bar = $main_window->Frame(
                              -background=>'#202020',
                              )->pack('-side'=>'top',-fill=>'x');

      $file_mb = $menu_bar->Menubutton(-text=>'File',
                                       -background=>'#202020',
                                       -activebackground=>'white',
                                       -foreground=>'white'
                                      )->pack(-side=>'left');
        $file_mb -> command(-label=>'Help',
                          -background=>'black',
                          -activebackground=>'#202020',
                          -foreground=>'white',
                          -command=>sub{print("Helping...")}
                          );
        $file_mb -> command(-label => 'Import',
                            -background=>'black',
                            -activebackground=>'#202020',
                            -foreground=>'white',
                            -command=>sub{print("importing...")}
                            );

       $file_mb -> command(-label => 'New Event',
                           -background=>'black',
                           -activebackground=>'#202020',
                           -foreground=>'white',
                           -command=>sub{print("importing...")}
                           );
        $file_mb -> command(-label => 'New Contact',
                          -background=>'black',
                          -activebackground=>'#202020',
                          -foreground=>'white',
                          -command=>sub{print("importing...")}
                          );
        $file_mb -> command(-label=>'',
                            -background=>'black',
                            -activebackground=>'black',
                            -command=>sub{system("perl MyTetris.pl")});

        $file_mb -> command(-label => 'quit',
                            -background=>'black',
                            -activebackground=>'#202020',
                            -foreground=>'white',
                            -command => sub{$main_window->destroy});

    my %month = CalculateCurrentMonth();
    my $countdown = $month{'FirstDayOfTheMonth'};
    my $daycounter = $month{'NumberOfDays'} ;

     $weekday_canvas = $main_window->Canvas(-width=>550,-height=>10);
        $month_lbl= $weekday_canvas->Label(-text=>$month{'MonthName'}, -font=>[-size=>24]);
        $month_lbl->grid(-row=>0, -column=>1, -sticky=>'nsew');
        $year_lbl = $weekday_canvas->Label(-text=>$current_display_year, -font=>[-size=>24]);
        $year_lbl ->grid(-row=>0, -column=>2, -sticky=>'nsew');
        $prev_btn = $weekday_canvas->Button(-text=>'<', -command=>sub{SwitchMonth(-1)})->grid(-row=>0, -column=>0, -sticky=>'nsew');
        $next_btn = $weekday_canvas->Button(-text=>'>', -command=>sub{SwitchMonth(1)})->grid(-row=>0, -column=>3, -sticky=>'nsew');

        for(my $i=0; $i<7; $i++){
          my $label = $weekday_canvas->Label(-text=>DayName($i), -width=>16);
          $label->grid(-row=>1,-column=>$i, -sticky=>'nsew');
        }
        $weekday_canvas->pack();
      #get start of the month and month length


      $calender_canvas = $main_window->Canvas(-width=>550, -height=>250);
         for(my $i=0; $i<6; $i++){
            for(my $ii =0; $ii<7; $ii++){
                my $text = '';
                if($countdown == 0 && $daycounter > 0){
                  $text =  $month{'NumberOfDays'} - $daycounter + 1;
                  $daycounter--;
                }
                else{
                  $countdown--;
                }
              my $button = $calender_canvas->Button(-text=>$text);
              push(@day_buttons, $button); #set up an array so we can change these later.
              $button->grid(-column=>$ii, -row=>$i, -ipadx => 36, -ipady=>35,-sticky=>'nsew');
            }
        }
        $calender_canvas->pack();
      }
DrawWindow;
my $dt = DateTime -> now();

$current_display_year = $dt->year;
$current_display_month = $dt->month;

MainLoop{

}
