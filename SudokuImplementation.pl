use strict;
use warnings;

use lib '.';
use SudokuDLXthread qw( solve_sudoku );

my $order = 55;

my $puzzle = [
    [ 1..$order ],
    ([ (0) x $order ]) x ($order - 1),
];

my $solutions = solve_sudoku(
    puzzle              => $puzzle,
    regions             => [
        [1,$order],
        [$order,1],
        [5,11],
        [11,5],
    ],
    number_of_solutions => 1,
);

print "No solutions found\n" unless @$solutions;

my $solution_count = 0;
for my $solution (@$solutions) {
    $solution_count++;
    print "\n" unless $solution_count == 1;
    print "Solution $solution_count:\n";
    my $puzzle_solution = [];
    for my $cell (@$solution) {
        my ($r, $c, $n) = $cell =~ /(\d+) (\d+) (\d+)/;
        $puzzle_solution->[$r][$c] = $n;
    }
    for my $row (@$puzzle_solution) {
        print join(" ", @$row), "\n";
    }
}

1;

__END__
