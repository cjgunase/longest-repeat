use strict;
use List::Util qw[ reduce ];

sub longest_polyN {
    my $seq = shift @_;
    my (@array, @sorted);

    my $i = 0;
    my $pn;

    while ($i < length($seq)) {
	($pn = $seq)  =~ s/^\w{$i}(A+|T+|G+|C+)\w*$/$1/;
	#push (@array, length($pn));
	push (@array, $pn);
	$i=$i+length($pn);
    }

    @sorted  = sort {length $b <=> length $a} @array;
#    print @sorted;                                                                                                                                 
    return  shift(@sorted);
}

sub linear{
    my ($seq) = @_;
    my ($chr, $maxn, $n, $maxc) = ('', 0,0,'');

    for (0..(length($seq)-1)) {
        $_ = substr($seq, $_, 1);
        if ($_ ne $chr) {
            $n = 1;
            $chr = $_;
        }
        else {
            $n++;
            if ($n > $maxn) {
                $maxn = $n;
                $maxc = $chr;
            }
        }
    }
    my $subString='';
    for(0..($maxn-1)){
        $subString=$subString.$maxc;
    }
    return $subString;
}

sub regex {
    my ($seq) = @_;
    my @subStringArray = $seq =~ /((.)\2+)/g; #explaination : (.) -anycharacter, \2 - backreferece to subpattern, + -repeat infinite times the previous token , g -get all the patterns
    my $max = reduce{length $a > length $b ? $a : $b} @subStringArray ; # get the maximum length sub pattern in the array using List library
    my @patterns = ();
    foreach(@subStringArray){
        if(length($_)==length($max)){
		push (@patterns,$_);
        }
    }
    
    return @patterns;
}
my $input = $ARGV[0];
chomp $input;

print "#######################   Method 1 Using Linear_search ########\n";
print "ID\tSeqLen\tSubptn\tStrtLoc\tLinear-time\n";
open(fh,"$input")or die $!;
<fh>;
while(<fh>){
    chomp;
    my @values = split("\t",$_);
    my $seq = $values[1];
    my $id = $values[0];
    print "$id\t";
    print length($seq);
    print "\t";
    my $start_run = time();
    my $subString = linear($seq);
    my $end_run = time();
    print substr($subString, 0, 1 )." x ".length($subString);
    print "\t";
    print (index($seq,$subString)+1);
    print "\t";

    my $run_time = $end_run - $start_run;
    print "$run_time seconds\n";
}
close(fh);




print "\n#########################   Method 2 Using RegEx ############\n";
print "ID\tSeqLen\tSubptn\tStrtLoc\tRegex-time\n";
open(fh,"$input")or die $!;
<fh>;
while(<fh>){
    chomp;
    my @values = split("\t",$_);
    my $seq = $values[1];
    my $id = $values[0];
    my $start_run = time();
    my @subStrings = regex($seq);
    my $end_run = time();
    foreach my $subString(@subStrings){
	print "$id\t";
	print length($seq);
	print "\t";
    	print substr($subString, 0, 1 )." x ".length($subString);
    	print "\t";
    	print (index($seq,$subString)+1);
    	print "\t";
    	my $run_time = $end_run - $start_run;
    	print "$run_time seconds\n";
	}
}
close(fh);

print "\n#########################   Method 3 longst_polyN Using  ############\n";
print "ID\tSeqLen\tSubptn\tStrtLoc\tpolyN-time\n";
open(fh,"$input")or die $!;
<fh>;
while(<fh>){
    chomp;
    my @values = split("\t",$_);
    my $seq = $values[1];
    my $id = $values[0];
    my $start_run = time();
    my @subStrings = longest_polyN($seq);
    my $end_run = time();
    foreach my $subString(@subStrings){
	print "$id\t";
	print length($seq);
	print "\t";
    	print substr($subString, 0, 1 )." x ".length($subString);
    	print "\t";
    	print (index($seq,$subString)+1);
    	print "\t";
    	my $run_time = $end_run - $start_run;
    	print "$run_time seconds\n";
	}
}
close(fh);



print("------------------------------Analysis of algorithms----------------------\n");
print("Linear_search method has better running time than RegEx method for Arabdapsis Chr 5 26975502bps\n");
print("But the Linear method can not find duplicate subpatterns which has same length (for example in S4), where the RegEx method can find all the subpatterns even with same lenght\n");

