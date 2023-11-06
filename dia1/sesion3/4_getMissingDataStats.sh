#!/bin/bash
#SBATCH -p short
#SBATCH -o Logs/missing.o
#SBATCH -e Logs/missing.e
#SBATCH -J merge

shopt -s expand_aliases
source ~/.bash_profile

base=${HOME}/JNAB/dia1/sesion3/PrepareData/Outputs/ModernAncient_withOutgroups

###get missing data per snp and per ind
plink --bfile ${base} --missing --out ${base}

