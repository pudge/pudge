#!/usr/bin/perl -s
use warnings;
use strict;
use feature ':5.10';

use LWP::Simple;

our $n;

# optional cron:
# */15 9-22   * * * ~/bin/water_heater.plx
# *    0-8,23 * * * ~/bin/water_heater.plx

my $url = 'http://lmreports.eastriver.coop/loadgraphandcontroldatagen/LoadControlStatus.html';
my $hook = 'http://maker.ifttt.com/trigger/water_heater_status/with/key/__KEY__?value1=__PNAME__&value2=';
my %loads = (
    water_heater    => 'WAT&nbsp;12',
    air_conditioner => 'AIR&nbsp;*',
);

for my $name (sort keys %loads) {
    my $pname = $name =~ s/_/+/gr;
    my $load = "$loads{$name})";
    my $file = "$ENV{HOME}/.$name";
    my $keyfile = "$ENV{HOME}/.water_heater_key";

    chomp(my $key = do { open my $fh, '<', $keyfile or die "Cannot open $keyfile: $!"; <$fh> });
    my $hook = $hook =~ s/\b__KEY__\b/$key/gr;
    $hook =~ s/\b__PNAME__\b/$pname/g;

    my $html = get($url) || '';
    my $seen = 0;
    my $status = 0;
    while ($html =~ /(.+?)\n/g) {
        my $m = $1;
        $seen = 1, next if $m =~ /\Q$load\E/;
        next unless $seen;
        if ($m =~ />(ON|OFF)</) {
            $status = $1;
            last;
        }
    }

    if ($n) {
        say $status;
        exit;
    }

    if ($status) {
        my $fh;
        if (open $fh, '<', $file) {
            my $old = <$fh>;
            get($hook . $status) if $status ne $old;
            close $fh;
        }
        if (open $fh, '>', $file) {
            print $fh $status;
            close $fh;
        }
    }
}
