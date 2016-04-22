#!/usr/bin/perl

use warnings;
use strict;
use Tk; #gui support

use Tk::PNG; #display images in tk

#todo, create main
#main variables
my $main_window;
my $menu_bar;
my $file_mb;
  my $calender_canvas;

#draw the main window, menu bars, buttons etc.
sub draw_window{
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
                            -activebackground=>'black');

        $file_mb -> command(-label => 'quit',
                            -background=>'black',
                            -activebackground=>'#202020',
                            -foreground=>'white',
                            -command => sub{$main_window->destroy});

         $calender_canvas = $main_window->Canvas(-width=>550, -height=>250);
        for(my $i =0; $i<7; $i++){
          for(my $ii =0;$ii<7;$ii++){
            my $button;
            $button = $calender_canvas->Button(-text=>'button$i,$ii');
            $button->grid(-column=>$i, -row=>$ii, -ipadx => 36, -ipady=>30,-sticky=>'nsew');
          }
        }
        $calender_canvas->pack();
      }
draw_window;

MainLoop{

}
