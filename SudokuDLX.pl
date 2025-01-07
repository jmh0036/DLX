use strict;
use warnings;

use lib '.';
use DLX;

sub sudoku_to_dlx {
    my %params = @_;
    my $puzzle  = $params{puzzle};
    my $regions = $params{regions};
    my $dlx = DLX->new();

    my $order = @$puzzle;
    my $number_of_regions = @$regions;

    my @cols;
    # Each cell can only have one symbol
    for my $r (0..$order - 1) {
        for my $c (0..$order - 1) {
            push @cols, $dlx->add_column("cell_$r$c");
        }
    }
    for my $r (1..$order) {
        for my $c (0..$order - 1) {
            for my $region (@$regions) {
                my ($a, $b) = @$region;
                my $block = (int($r/$a) * $a) + int($c/$b);
                push @cols, $dlx->add_column("r#$r c#$c R#$a,$b B#$block");
            }
        }
    }

    for my $r (0..$order - 1) {
        for my $c (0..$order - 1) {
            if ($puzzle->[$r][$c]) {
                my $n = $puzzle->[$r][$c];
                my @columns;
                for my $region (0..@$regions - 1) {
                    my ($a, $b) = @{$regions->[$region]};
                    my $block = (int($r/$a) * $a) + int($c/$b);

                    push @columns, $cols[(($region+1) * $order**2) + ($block*$order)+($n-1)];
                }

                # Add the cell column
                push @columns, $cols[$r*$order+$c];
                $dlx->add_row("$r$c$n", @columns);
            } else {
                for my $n (1..$order) {
                    my @columns;
                    for my $region (0..scalar @$regions - 1) {
                        my ($a, $b) = @{$regions->[$region]};
                        my $block = (int($r/$a) * $a) + int($c/$b);

                        push @columns, $cols[(($region+1) * $order**2) + ($block*$order)+($n-1)];
                    }

                    # Add the cell column
                    push @columns, $cols[$r*$order+$c];
                    $dlx->add_row("$r$c$n",  @columns);
                }
            }
        }
    }

    return $dlx;
}

sub solve_sudoku {
    my ($puzzle) = @_;
    my $dlx = sudoku_to_dlx(
        regions => [
            [1,9],
            [9,1],
            [3,3],
        ],
        puzzle => $puzzle,
    );
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