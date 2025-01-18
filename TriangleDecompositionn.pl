use strict;
use warnings;

use lib '.';
use DLX;
use Math::Combinatorics;

# K_3 decomp exists if n equiv 1 or 3 mod 6
# K_4 decomp may exist if n equiv 1 or 4 mod 12
my $order = 7;
my $decomp_order = 3;
my @required_blocks = (
    [2, 3, 7],
    # [1, 5, 7],
    # [1, 3, 4],
);

my $complete_edgeset = Math::Combinatorics->new(
    count => 2,
    data  => [ 1 .. $order ],
);

my $dlx = DLX->new;

# Add required blocks to the DLX matrix first
my @edges_covered;
for my $block (@required_blocks) {
    for my $i (0 .. $#$block - 1) {
        for my $j ($i+1..$#$block) {
            push @edges_covered, "$$block[$i] $$block[$j]";
            push @edges_covered, "$$block[$j] $$block[$i]";
        }
    }
}

# Add all possible edges to the DLX matrix
my %edges;
while ( my @edge = $complete_edgeset->next_combination ) {
    $edges{"$edge[0] $edge[1]"} = $dlx->add_column("@edge") unless grep { $_ eq "$edge[0] $edge[1]" } @edges_covered;
}

# Add all possible triangles as rows to the DLX matrix, excluding required blocks
my $triangles = Math::Combinatorics->new(
    count => $decomp_order,
    data  => [ 1 .. $order ],
);

while ( my @triangle = $triangles->next_combination ) {
    next if grep { join(' ', @$_) eq join(' ', @triangle) } @required_blocks;
    my @edges;
    for my $i (0 .. $decomp_order - 1) {
        for my $j ($i+1..$decomp_order - 1) {
            if (defined $edges{"$triangle[$i] $triangle[$j]"}){
                push @edges, "$triangle[$i] $triangle[$j]" unless grep { $_ eq "$triangle[$i] $triangle[$j]" } @edges_covered;
            } else {
                push @edges, "$triangle[$j] $triangle[$i]" unless grep { $_ eq "$triangle[$j] $triangle[$i]" } @edges_covered;
            }
        }
    }
    my @covered_edges = map { $edges{$_} } @edges;
    $dlx->add_row("@triangle", @covered_edges) unless scalar @edges < $decomp_order;
}

# Solve the DLX matrix
my $solutions = $dlx->solve(
    # number_of_solutions => 1,
);

# Print the number of solutions
print "No solutions found\n" unless @$solutions;

# Print the solutions
my $solution_count = 0;
for my $solution (@$solutions) {
    $solution_count++;;
    print "\n" unless $solution_count == 1;
    print "Solution $solution_count:\n";
    my $triangle_solution = [];
    for my $block (@required_blocks) {
        push @$triangle_solution, $block;
    }
    for my $edge (@$solution) {
        my @triangle = split ' ', $edge;
        push @$triangle_solution, \@triangle;
    }
    for my $triangle (@$triangle_solution) {
        print join(" ", @$triangle), "\n";
    }
}

1;

__END__
