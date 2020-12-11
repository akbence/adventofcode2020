# !/usr/bin/perl 
use Class::Struct;

struct( Node => [
    node_index  => '$',
    connected_nodes => '@', 
]);

my @nodes=();
my $counter=0;

sub fileRead()
{    
    my $filename = '../input.txt';
    @lines = ();
    open(FH, '<', $filename) or die $!;

    while(<FH>){
        push(@lines, $_);
    }

    close(FH);
    return @lines
}

sub task1(@sorted_lines){
    $last_number=0;
    $one_jolt=0;
    $three_jolt=1;
    for $number (@sorted_lines) {
        if($number-$last_number == 1){
            $one_jolt++;
        }

        if($number-$last_number == 3){
            $three_jolt++;
        }
        $last_number=$number;
    }
    return $one_jolt*$three_jolt;
}

sub searchWay {
    my $curr_index = $_[1];
    my $last_index = $_[2];
    my (@sorted_lines) = @{$_[0]};
    my $result = 0;
    if ($curr_index == $last_index){
        return 1;
    }
        if(($curr_index + 1 <= $last_index) && ($sorted_lines[$curr_index+1] - $sorted_lines[$curr_index] <=3 )){
            $result += searchWay(\@sorted_lines,$curr_index+1,$last_index);
        }
        if(($curr_index + 2 <= $last_index )&& ($sorted_lines[$curr_index+2] - $sorted_lines[$curr_index] <=3 )){
            $result += searchWay(\@sorted_lines,$curr_index+2,$last_index);
        }
        if(($curr_index + 3 <= $last_index) && ($sorted_lines[$curr_index+3] - $sorted_lines[$curr_index] <=3 )){
            $result += searchWay(\@sorted_lines,$curr_index+3,$last_index);
        }
    return $result;
}


sub dfsRecursive {
    printf ("called");
    my $u = $_[1];
    my $d = $_[2];
    my (@visited) = @{$_[0]};

    if($u == $d){
        $counter++;
        return;
    }

    $visited[$u] = 1;
    for $adj (@nodes[$u]->connected_nodes){
        if($visited[$adj] == 0){
            dfsRecursive(\@visited,$adj,$d);
        }

    }
    $visited[$u] = 0;
}

sub task2(@lines){
    
    #add first and last elements

    push(@lines, 0);
    @sorted_lines = sort { $a <=> $b } @lines;
    push(@sorted_lines, $sorted_lines[-1]+3);
    $startIndex=0;

    my $size= scalar @sorted_lines;
    my $iter=0;
    
    for $number (@sorted_lines) {
        my @connections = ();
        if(($iter + 1 < $size) && ($sorted_lines[$iter+1] - $sorted_lines[$iter] <=3 )){
            push(@connections, $iter+1);
        }
        if(($iter + 2 < $size )&& ($sorted_lines[$iter+2] - $sorted_lines[$iter] <=3 )){
            push(@connections, $iter+2);
        }
        if(($iter + 3 < $size) && ($sorted_lines[$iter+3] - $sorted_lines[$iter] <=3 )){
            push(@connections, $iter+3);
        }
        my $t = Node->new(node_index=>$iter,
            connected_nodes=>\@connections);
        push(@nodes, $t);
        $iter++;
    }

    my @visited = (0) x scalar @nodes;
    dfsRecursive( \@visited,$nodes[0]->node_index,$nodes[-1]->node_index);
        
        
#    $solution= searchWay(\@sorted_lines,$startIndex, $size-1);
 #   printf("Task2 solution: %d", $solution);
}


# Main
@lines =  fileRead();
@sorted_lines = sort { $a <=> $b } @lines;

$task1_solution=task1(@sorted_lines);
printf ("Task1 solution: %d \n",$task1_solution);
$task2_solution=task2(@sorted_lines);
