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


# Main
@lines =  fileRead();
@sorted_lines = sort { $a <=> $b } @lines;
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

$task1_solution=$one_jolt*$three_jolt;
printf ("Task1 solution: %d",$task1_solution);
