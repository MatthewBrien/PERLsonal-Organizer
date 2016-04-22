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
my $help_mb;
my $exit_mb;

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

        $file_mb -> command(-label=>'help',
                          -background=>'black',
                          -activebackground=>'#202020',
                          -foreground=>'white',
                          -command=>sub{print("Helping...")}
                          );
        $file_mb -> command(-label => 'import',
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
        my $but = $main_window -> Button(-text=>"Push Me");
      
      }
draw_window;
MainLoop{

}
