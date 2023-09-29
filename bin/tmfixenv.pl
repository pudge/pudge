#!/usr/bin/perl
use warnings;
use strict;
use feature ':5.10';

for (split /\n/, `tmux show-environment`) {
    if (/^(\w+)=(.+)$/) {
        print "export $1='$2'\n";
    }
}

