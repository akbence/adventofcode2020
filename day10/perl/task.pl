# !/usr/bin/perl 


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

sub task2(@lines){
    
    #add first and last elements

    push(@lines, 0);
    @sorted_lines = sort { $a <=> $b } @lines;
    push(@sorted_lines, $sorted_lines[-1]+3);
    $startIndex=0;
    $size= scalar @sorted_lines;
    $solution= searchWay(\@sorted_lines,$startIndex, $size-1);
    printf("Task2 solution: %d", $solution);
}


# Main
@lines =  fileRead();
@sorted_lines = sort { $a <=> $b } @lines;

$task1_solution=task1(@sorted_lines);
printf ("Task1 solution: %d \n",$task1_solution);
$task2_solution=task2(@sorted_lines);
