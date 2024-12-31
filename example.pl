#!/usr/bin/perl
use strict;
use warnings;
use Data::Dump 'pp';

use lib '.';
use DLX;

# Create a new DLX solver instance
my $dlx = DLX->new();

# Define columns for the exact cover problem
my $col_1 = $dlx->add_column('1');
my $col_2 = $dlx->add_column('2');
my $col_3 = $dlx->add_column('3');
my $col_4 = $dlx->add_column('4');
my $col_5 = $dlx->add_column('5');
my $col_6 = $dlx->add_column('6');
my $col_7 = $dlx->add_column('7');

# Define rows for the exact cover problem
$dlx->add_row('rowA', $col_1, $col_4, $col_7);
$dlx->add_row('rowB', $col_1, $col_4);
$dlx->add_row('rowC', $col_4, $col_5, $col_7);
$dlx->add_row('rowD', $col_3, $col_5, $col_6);
$dlx->add_row('rowE', $col_2, $col_3, $col_6, $col_7);
$dlx->add_row('rowF', $col_2, $col_7);

# Solve the exact cover problem
my $solutions = $dlx->solve();

# Print the solutions
# print "Solutions:\n";
# print pp($solutions), "\n";

for my $solution (@$solutions) {
    print pp($solution), "\n";
}