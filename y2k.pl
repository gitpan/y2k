#!/usr/bin/perl

use y2k;

my ($sec, $min, $hour,
   $day, $mon, $year) = localtime();

print "1. The year is ", 1900+$year, "\n";
print "2. The year is ", $year+1900, "\n";
print "3. The year is ", ('19'.$year), "\n";
print "4. The year is 19$year\n";

exit 0;
