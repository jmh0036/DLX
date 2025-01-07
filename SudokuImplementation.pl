use strict;
use warnings;

use lib '.';
use SudokuDLX qw(solve_sudoku);

my $puzzle = [
    [0, 2, 0, 0, 7, 0, 0, 0, 0],
    [0, 0, 1, 0, 0, 0, 8, 4, 0],
    [0, 0, 0, 5, 0, 0, 1, 0, 0],
    [9, 0, 0, 0, 1, 0, 7, 6, 4],
    [5, 0, 0, 0, 6, 0, 0, 0, 0],
    [4, 0, 0, 0, 9, 0, 0, 3, 0],
    [0, 0, 7, 9, 0, 0, 0, 0, 0],
    [0, 3, 0, 4, 0, 0, 0, 5, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 8],
];

my $solutions = solve_sudoku(
    puzzle  => $puzzle,
    regions => [ [1,9], [9,1], [3,3] ],
);

print "No solutions found\n" unless @$solutions;

my $solution_count = 0;
for my $solution (@$solutions) {
    $solution_count++;
    print "\n" unless $solution_count == 1;
    print "Solution $solution_count:\n";
    my $puzzle_solution = [];
    for my $cell (@$solution) {
        my ($r, $c, $n) = $cell =~ /(\d)(\d)(\d)/;
        $puzzle_solution->[$r][$c] = $n;
    }
    for my $row (@$puzzle_solution) {
        print join(" ", @$row), "\n";
    }
}

1;

__END__
