use strict;
use warnings;

use lib '.';
use DLX;
use Math::Combinatorics;

my $order = 7;
my $decomp_order = 3;
my @required_blocks = ([2, 3, 7]);

my $complete_edgeset = Math::Combinatorics->new(
    count => 2,
    data  => [ 1 .. $order ],
);

my $dlx = DLX->new;

# Add all possible edges to the DLX matrix
my %edges;
while ( my @edge = $complete_edgeset->next_combination ) {
    $edges{"$edge[0] $edge[1]"} = $dlx->add_column("@edge");
}

# Add all possible triangles as rows to the DLX matrix
my $triangles = Math::Combinatorics->new(
    count => $decomp_order,
    data  => [ 1 .. $order ],
);

while ( my @triangle = $triangles->next_combination ) {
    my @edges;
    for my $i (0 .. $decomp_order - 1) {
        for my $j ($i+1..$decomp_order - 1) {
            if (defined $edges{"$triangle[$i] $triangle[$j]"}){
                push @edges, "$triangle[$i] $triangle[$j]";
            } else {
                push @edges, "$triangle[$j] $triangle[$i]";
            }
        }
    }
    my @covered_edges = map { $edges{$_} } @edges;
    $dlx->add_row("@triangle", @covered_edges);
}

# Solve the DLX matrix
my $solutions = $dlx->solve(
    first_solution => 1,
);

# Print the number of solutions
print "No solutions found\n" unless @$solutions;

# Print the solutions
my $solution_count = 0;
for my $solution (@$solutions) {
    $solution_count++;
    print "\n" unless $solution_count == 1;
    print "Solution $solution_count:\n";
    my $triangle_solution = [];
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
