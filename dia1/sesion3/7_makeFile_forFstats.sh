#!/bin.bash
#SBATCH -p short
#SBATCH -o Logs/makeFile_forFstats.o
#SBATCH -e Logs/makeFile_forFstats.e
#SBATCH -J forFstat

shopt -s expand_aliases
source ~/.bash_profile

prefin=${HOME}/JNAB/dia1/sesion3//Outputs/ModernAncient_withOutgroups
prefout=${HOME}//JNAB/dia1/sesion3//Outputs/ForFstats/

awk '{if($1 ~ /Luisi/ || $1 ~ /delaFuente/ || $1 ~ /French/ || $1 ~ /Yoruba/){$1="Ignore"; $6="Ignore"}; print $1,$2,$3,$4,$5,$6}' $prefin > $prefout.KEEP

echo "genotypename:    $prefin.geno.txt
snpname:         $prefin.snp.txt
indivname:       $orefout.KEEP
outputformat:   EIGENSTRAT 
genotypeoutname: $prefout.geno.txt
snpoutname:      $prefout.snp.txt
indivoutname:    $prefout.ind.txt
familynames:     YES" > $prefout.param

sbatch -o con.o -e con.e -J conv --wrap="$SinguExec $eigImg convertf -p $prefout.param " 

