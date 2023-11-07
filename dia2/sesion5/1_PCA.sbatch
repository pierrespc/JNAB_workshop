#!/bin/bash
#SBATCH -p short
#SBATCH -o Logs/PCA.o
#SBATCH -e Logs/PCA.e
#SBATCH -J PCA
#SBATCH --reservation=cursojnab
shopt -s expand_aliases
source ~/.bash_profile

base=${HOME}/JNAB/dia2/sesion5/StartingData/ModernAncient_withOutgroups.MIND0.5.GENO0.3
outpref=${HOME}/JNAB/dia2/sesion5//Outputs/PCA/PCAwithProjection

#### prepare list of modern populations (French, Yoruba, Mbuti, and thoise with Luisi or de La Fuente)
grep 'French\|Mbuti\|Yoruba\|Luisi\|delaFuente' $base.fam | awk '{print $1}' | sort | uniq > $outpref.ListModernPops

echo "
genotypename:    $base.bed
snpname:         $base.bim
indivname:       $base.fam
evecoutname:     $outpref.evec
evaloutname:     $outpref.eval
poplistname:	 $outpref.ListModernPops
numoutlieriter:	0
lsqproject:	 YES" > $outpref.Proj.par

smartpca -p $outpref.Proj.par


