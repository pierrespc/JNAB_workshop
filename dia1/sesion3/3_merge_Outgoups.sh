#!/bin/bash
#SBATCH -p short
#SBATCH -o Logs/mergeOutgroups.o
#SBATCH -e Logs/mergeOutgroups.e
#SBATCH -J mergeOutgroups

shopt -s expand_aliases
source ~/.bash_profile

base1=${HOME}/JNAB/dia1/sesion3/Outputs/ModernAncient
base2=${HOME}/JNAB/dia1/sesion3/StartingData/Outgoup/Outgoups
format=PACKEDPED
outpref=${HOME}/JNAB/dia1/sesion3//Outputs/ModernAncient_withOutgroups

####merge the 2 eigensoft files with mergeit from EIGENSOFT v7 (output in plink format)
echo "geno1: ${base1}.bed
ind1: ${base1}.fam
snp1: ${base1}.bim
geno2: ${base2}.geno.txt
ind2: ${base2}.ind.txt
snp2: ${base2}.snp.txt 
genooutfilename: ${outpref}.bed
snpoutfilename: ${outpref}.bim
indoutfilename: ${outpref}.fam
familynames: YES
outputformat: ${format} " > ${outpref}.params

mergeit -p ${outpref}.params
	



