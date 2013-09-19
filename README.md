Flight Count
=================

Script to download the any available year of the WSJ flight list and export to CSV files.

Takes a CSV input file, scans for tail numbers, and then passes those into a url and parses the resulting count.

For example

    $ perl flight-count.pl Tail.csv

Forked/modified from @tminard