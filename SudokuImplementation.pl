use strict;
use warnings;

use lib '.';
use SudokuDLX qw( solve_sudoku );

my $puzzle = [
    [ 1, 2, 3, 4, 5, 6 ],
    [ 0, 0, 0, 0, 0, 0 ],
    [ 0, 0, 0, 0, 0, 0 ],
    [ 0, 0, 0, 0, 0, 0 ],
    [ 0, 0, 0, 0, 0, 0 ],
    [ 0, 0, 0, 0, 0, 0 ],
];

my $solutions = solve_sudoku(
    puzzle          => $puzzle,
    regions         => [ [1,6], [6,1], [2,3], [3,2], ],
    first_solution  => 1,
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
