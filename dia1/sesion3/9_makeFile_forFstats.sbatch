#!/bin/bash
#SBATCH -p short
#SBATCH -o Logs/makeFile_forFstats.o
#SBATCH -e Logs/makeFile_forFstats.e
#SBATCH -J forFstat
#SBATCH --reservation=cursojnab

shopt -s expand_aliases
source ~/.bash_profile

prefin=${HOME}/JNAB/dia1/sesion3//Outputs/ModernAncient_withOutgroups.MIND0.5.GENO0.3
prefout=${HOME}//JNAB/dia1/sesion3//Outputs/ModernAncient_ForFstats

awk '{if($1 ~ /Luisi/ || $1 ~ /delaFuente/ || $1 ~ /French/ || $1 ~ /Yoruba/){$1="Ignore"; $6="Ignore"}; print $1,$2,$3,$4,$5,$1}' $prefin.fam > $prefout.KEEP.fam

echo "genotypename:    $prefin.bed
snpname:         $prefin.bim
indivname:       $prefout.KEEP.fam
outputformat:   EIGENSTRAT 
genotypeoutname: $prefout.geno.txt
snpoutname:      $prefout.snp.txt
indivoutname:    $prefout.ind.txt
familynames:     YES" > $prefout.param

convertf -p $prefout.param 

###fix ind ID
cut -d':' -f2 $prefout.ind.txt > tmp
mv tmp $prefout.ind.txt


