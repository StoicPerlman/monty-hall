#!/usr/bin/env perl

use strict;
use warnings;

use List::Util qw/max/;
use Term::ReadKey;

END { ReadMode 0; print "\n"; }    # on exit reset to default
ReadMode 4;

my $tries = $ARGV[0] // 1000000;
if ( $tries !~ /\A\d+\z/ or $tries <= 0 ) {
    print "Usage: ./monty-hall.pl [iterations]\n";
    print "Where iterations is a number greater then 0";
    exit 1;
}

print "press q to quit\n";

my $player_no_switch_wins = 0;
my $player_switch_wins    = 0;
my $output;

foreach my $cnt ( 1 .. $tries ) {

    my $winning_door = int( rand(3) ) + 1;
    my $player_pick  = int( rand(3) ) + 1;

    # Here the host will open a losing door
    # leaving only two possible paths
    # the player picked the winning door
    # and wins if he doesnt switch
    # or he picked a loser to start
    # and wins if he switches
    # this counts wins for both cases
    if ( $player_pick == $winning_door ) {
        $player_no_switch_wins++;
    }
    else {
        $player_switch_wins++;
    }

    my $switch_average    = $player_switch_wins / $cnt;
    my $no_switch_average = $player_no_switch_wins / $cnt;

    my $last_output = $output // "";

    # print updated stats plus spaces to clear
    # any left over text from last print
    # \r moves cursor to beginning of line to overwrite old output
    $output = "\rSwitch Win %: $switch_average";
    $output .= " - ";
    $output .= "No Switch Win %: $no_switch_average";
    $output .= " " x new_line_difference( $last_output, $output );

    print $output;

    # if user presses q exit loop
    my $pressed_key = ReadKey(-1) // "";
    last if "q" eq $pressed_key;
}

# if line to be printed is longer then last line printed return 0
# else ruturn number of characters that need cleared
sub new_line_difference {
    my ( $old, $current ) = @_;
    return max( 0, length($old) - length($current) );
}
