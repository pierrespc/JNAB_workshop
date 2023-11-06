#!/bin/bash
#SBATCH -p short
#SBATCH -o Logs/merge.o
#SBATCH -e Logs/merge.e
#SBATCH -J merge

shopt -s expand_aliases
source ~/.bash_profile

base1=${HOME}/JNAB/dia1/sesion3/StartingData/AADR/AADR_selected
base2=${HOME}/JNAB/dia1/sesion3/StartingData/MaskedModernData/Luisi2020_delaFuente2018_GW.TH0.9.Nat.Phased.Mind1_Ditypes.eigen
format=PACKEDPED
outpref=${HOME}/JNAB/dia1/sesion3//Outputs/ModernAncient

####merge the 2 eigensoft files with mergeit from EIGENSOFT v7 (output in plink format)
echo "geno1: ${base1}.geno.txt
ind1: ${base1}.ind.txt
snp1: ${base1}.snp.txt
geno2: ${base2}.geno.txt
ind2: ${base2}.ind.txt
snp2: ${base2}.snp.txt 
genooutfilename: ${outpref}.bed
snpoutfilename: ${outpref}.bim
indoutfilename: ${outpref}.fam
familynames: YES
outputformat: ${format} " > ${outpref}.params

mergeit -p ${outpref}.params
	



