#!/usr/bin/perl -w
use lib "$ENV{'HOME'}/perl"; 
use strict;

@ARGV > 0 || die "usage: $0 <blastp.out> <pfam.out> <signalp.out> <GO_and_keggs_annot.table>\n";

my (%par, %good, %sp, %ya);
my $ids_vs_org= "/free/databases/sprot/id_vs_org.txt";
my ($blastp, $pfam, $signalp, $table)= ($ARGV[0], $ARGV[1], $ARGV[2], $ARGV[3]);

open IN, $blastp or die "Cant read $blastp\n"; # lee el blastp
while(<IN>){
    if( /^(\S+)\s+sp\|([^\|]+).*\s+(\S+)\s+\S+$/ ){
        ($par{$1}{sp}, $par{$1}{sp_eval})= ($2, $3); # guarda el SP id y el eval para cada gene
        $good{$2}++;
    }
}

open IN, $ids_vs_org or die "Cant read $ids_vs_org\n"; 
while(<IN>){
    if( /^(\S+)\s+\/product=\"([^\"]+)/ ){
        $sp{$1}{prod}= $2 if $good{$1};
    }
    
}

open IN, $pfam or die "Cant read $pfam\n"; 
while(<IN>){
    next if /^#/;
    chomp;
    my @pfam_prod= split(' ', $_, 23);
    my $pfam_prod= pop(@pfam_prod);
    if( /^\S+\s+(\S+)\s+\d+\s+(\S+)\s+\S+\s+\d+\s+(\S+)/ ){
        next if $ya{$2}++;
        ($par{$2}{pfam}, $par{$2}{pfam_eval}, $par{$2}{pfam_prod})= ($1, $3, $pfam_prod);
    }
}

open IN, $signalp or die "Cant read $signalp\n"; 
while(<IN>){
    next if /^#/;
    if( /^(\S+)\s+\S+\s+\S+\s+(\d+)\s+(\d+)/ ){
        ($par{$1}{signalp_from}, $par{$1}{signalp_to})= ($2, $3);
    }
}

open IN, $table or die "Cant read $table\n"; 
while(<IN>){
    chomp;
    my($spid, $go, $knumber, $cog, $ecnumber)= split;
    ($sp{$spid}{go}, $sp{$spid}{knumber}, $sp{$spid}{cog}, $sp{$spid}{ecnumber})= ($go, $knumber, $cog, $ecnumber);
}

print "#gene_id\tsprot_Top_BLASTP_hit\tproduct\tPfam\tPfam_Func\tSignalP\tgo\tKegg\tcog\tec_number\n";

foreach my $elem ( sort keys %par ){
    $par{$elem}{sp} ||= "'spNA'";
    $par{$elem}{sp_eval} ||= "'sp_evalNA'";

    if( $sp{$par{$elem}{sp}}{prod} ){
    	($sp{$par{$elem}{sp}}{prod}= $sp{$par{$elem}{sp}}{prod})=~ s/,//g;
        ($sp{$par{$elem}{sp}}{prod}= $sp{$par{$elem}{sp}}{prod})=~ s/ /_/g;
    }else{
        $sp{$par{$elem}{sp}}{prod} ="'sp_prodNA'";
    }

    $par{$elem}{pfam} ||="'pfam_NA'";
    $par{$elem}{pfam_eval} ||="'pfam_evalNA'";
    
    if( $par{$elem}{pfam_prod} ){
    	($par{$elem}{pfam_prod}= $par{$elem}{pfam_prod})=~ s/,//g;
        ($par{$elem}{pfam_prod}= $par{$elem}{pfam_prod})=~ s/ /_/g;
    }else{
        $par{$elem}{pfam_prod} ="'pfam_prodNA'";
    }

	$sp{$par{$elem}{sp}}{go} ||= "'goNA'";
    $sp{$par{$elem}{sp}}{knumber} ||= "'keggNA'";
    $sp{$par{$elem}{sp}}{cog} ||= "'cogNA'";
    $sp{$par{$elem}{sp}}{ecnumber} ||= "'ecNA'";
    
    $par{$elem}{signalp_from} ? ($par{$elem}{coords}= "signalp_$par{$elem}{signalp_from}-$par{$elem}{signalp_to}") : ($par{$elem}{coords}= "'signalp_coordsNA'");
#     print STDERR "$elem\n$par{$elem}{coords}\n";
    
    print "$elem\t$par{$elem}{sp}^E:$par{$elem}{sp_eval}\t$sp{$par{$elem}{sp}}{prod}\t$par{$elem}{pfam}^E:$par{$elem}{pfam_eval}\t$par{$elem}{pfam_prod}\t$par{$elem}{coords}\t$sp{$par{$elem}{sp}}{go}\t$sp{$par{$elem}{sp}}{knumber}\t$sp{$par{$elem}{sp}}{cog}\t$sp{$par{$elem}{sp}}{ecnumber}\n";
}
