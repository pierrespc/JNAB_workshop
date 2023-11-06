#!/bin/bash
#SBATCH -p short
#SBATCH -o $(pwd)/Logs/missing.o
#SBATCH -e $(pwd)/Logs/missing.e
#SBATCH -J merge

base=${HOME}/JNAB/dia1/sesion3/PrepareData/Outputs/ModernAncient_withOutgroups

###get missing data per snp and per ind
plink --bfile ${base} --missing --out ${base}

