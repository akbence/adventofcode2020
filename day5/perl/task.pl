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
for $line (@lines) {
    print ($line);
}
