use strict;
use warnings;

use lib '.';
use DLX;

sub sudoku_to_dlx {
    my ($puzzle) = @_;
    my $dlx = DLX->new();

    my @cols;
    for my $r (0..8) {
        for my $c (0..8) {
            push @cols, $dlx->add_column("cell_$r$c");
        }
    }
    for my $n (1..9) {
        for my $r (0..8) {
            push @cols, $dlx->add_column("row_$r$n");
        }
        for my $c (0..8) {
            push @cols, $dlx->add_column("col_$c$n");
        }
        for my $b (0..8) {
            push @cols, $dlx->add_column("block_$b$n");
        }
    }

    for my $r (0..8) {
        for my $c (0..8) {
            if ($puzzle->[$r][$c]) {
                my $n = $puzzle->[$r][$c];
                my $block = int($r/3) * 3 + int($c/3);
                $dlx->add_row("$r$c$n", $cols[$r*9+$c], $cols[81+$r*9+$n-1], $cols[162+$c*9+$n-1], $cols[243+$block*9+$n-1]);
            } else {
                for my $n (1..9) {
                    my $block = int($r/3) * 3 + int($c/3);
                    $dlx->add_row("$r$c$n", $cols[$r*9+$c], $cols[81+$r*9+$n-1], $cols[162+$c*9+$n-1], $cols[243+$block*9+$n-1]);
                }
            }
        }
    }

    return $dlx;
}

sub solve_sudoku {
    my ($puzzle) = @_;
    my $dlx = sudoku_to_dlx($puzzle);
    my $solutions = $dlx->solve();

    return $solutions;
}

# Blank puzzle for easy copy pasta
# my $puzzle = [
#     [0, 0, 0, 0, 0, 0, 0, 0, 0],
#     [0, 0, 0, 0, 0, 0, 0, 0, 0],
#     [0, 0, 0, 0, 0, 0, 0, 0, 0],
#     [0, 0, 0, 0, 0, 0, 0, 0, 0],
#     [0, 0, 0, 0, 0, 0, 0, 0, 0],
#     [0, 0, 0, 0, 0, 0, 0, 0, 0],
#     [0, 0, 0, 0, 0, 0, 0, 0, 0],
#     [0, 0, 0, 0, 0, 0, 0, 0, 0],
#     [0, 0, 0, 0, 0, 0, 0, 0, 0],
# ];
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

my $solutions = solve_sudoku($puzzle);

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
