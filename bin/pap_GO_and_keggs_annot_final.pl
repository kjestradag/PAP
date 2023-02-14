#!/usr/bin/env perl
use strict;

@ARGV > 0 || die "usage: $0 <blastp>
devuelve una tabla con la relacion de \"Swiss_prot_id\tGOs\tKs_numbers\tCOGs\tECs_numbers\"\n";

my (%rel, %rel2, %rel3);
my $blastp= shift;
my ($Goterm, $K_number_to_GO, $K_number_to_COGnumber, $K_number_to_ECnumber)= ("../../DB/gene_association.goa_uniprot_compact_plusproduct","../../DB/K_number_to_GO.txt","../../DB/K_number_to_COGnumber.txt","../../DB/K_number_to_ECnumber.txt",);

open IN, $blastp or die "Cant read $blastp\n";  #  cacha todos los IDs de Uniprot (SwissProt) que tengo en el blastp
while(<IN>){
    if( /^\S+\s+sp\|([^\|]+)/ ){
        $rel{sp}{$1}++;
    }
}

open IN, $Goterm or die "Cant read $Goterm\n";  #  cacha los GO term que estan anotados para cada ID de SwissProt que tenemos 
while(<IN>){
    if( /^(\S+)\s+(\S+)/ ){
        my $spid= $1;
        if( $rel{sp}{$spid} ){
            @{$rel{gos}{$spid}}= split(';',$2);
        }else{
            
        }
    }
}

open IN, $K_number_to_GO or die "Cant read $K_number_to_GO\n";  #  cacha los K numbers asociados a cada GO
while(<IN>){
    next if /^#/;
    if( /^(\S+)\s+\[GO:(.*)\]/ ){
        my @gos= split(' ',$2);
        foreach my $go ( @gos ){
            push @{$rel2{$go}{go}}, $1;
        }
    }
}

open IN, $K_number_to_COGnumber or die "Cant read $K_number_to_COGnumber\n";  #  cacha los COG asociados a cada K number
while(<IN>){
    next if /^#/;
    if( /^(\S+)\s+\[COG:(.*)\]/ ){
        my @cogs= split(' ',$2);
        foreach my $cog ( @cogs ){
            push @{$rel3{$1}{cog}}, $cog;
        }
    }
}

open IN, $K_number_to_ECnumber or die "Cant read $K_number_to_ECnumber\n";  #  cacha los EC asociados a cada K number
while(<IN>){
    next if /^#/;
    if( /^(\S+)\s+\[EC:(.*)\]/ ){
        my @ecs= split(' ',$2);
        foreach my $ec ( @ecs ){
            push @{$rel3{$1}{ec}}, $ec;
        }
    }
}

foreach my $sp ( sort keys %{$rel{sp}} ){
    my $gos= 0;
    my @ks= '';
    my @cogs= '';
    my @ecs= '';
    my %ya= ();
    my ($kcnt, $cogcnt, $eccnt);
    if( $rel{gos}{$sp} ){
        print "$sp\t";  #  imprime el ID de SwissProt
        foreach my $go ( @{$rel{gos}{$sp}} ){
        	$gos++;
            (my $sname_go= $go) =~ s/GO://;
            foreach my $ks ( @{$rel2{$sname_go}{go}} ){
                push @ks, $ks;
            }
            $gos == 1 ? print "$go" : print ";$go" unless $ya{$go}++;  #  imprime los GO terms asociados al ID de SwissProt
        }
        print "\t";
    }
    else{
        print "$sp\t'goNA'\t";
    }
    shift(@ks);
    print "'keggNA'" if @ks == 0;
    foreach my $ks ( @ks ){
        $kcnt++;
        $kcnt == 1 ? print "$ks" : print ";$ks" unless $ya{$ks}++;  #  imprime los K numbers asociados a los GO terms asociados al ID de SwissProt 
        foreach my $cogxk ( @{$rel3{$ks}{cog}} ){
            push @cogs, $cogxk;
        }
         foreach my $ecxk ( @{$rel3{$ks}{ec}} ){
            push @ecs, $ecxk;
        }
    }
	print "\t";
    shift(@cogs);
    print "'cogNA'" if @cogs == 0;
    foreach my $cogs ( @cogs ){
        $cogcnt++;
        $cogcnt == 1 ? print "$cogs" : print ";$cogs" unless $ya{$cogs}++;  #  imprime los COGs IDs asociados a los K numbers asociados a los GO terms asociados al ID de SwissProt
    }
    print "\t";
    shift(@ecs);
    print "'ecsNA'" if @ecs == 0;
    foreach my $ecs ( @ecs ){
        $eccnt++;
        $eccnt == 1 ? print "$ecs" : print ";$ecs" unless $ya{$ecs}++;  #  imprime los ECs IDs asociados a los K numbers asociados a los GO terms asociados al ID de SwissProt
    }
    print "\n";
}
