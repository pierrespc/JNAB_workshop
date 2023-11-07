#!/bin/bash
#SBATCH -p short
#SBATCH -o Logs/missingDivided.o
#SBATCH -e Logs/missingDivided.e
#SBATCH -J missingDivided
#SBATCH --reservation=cursojnab

shopt -s expand_aliases
source ~/.bash_profile

base=${HOME}/JNAB/dia1/sesion3/Outputs/ModernAncient_withOutgroups

grep 'Luisi\|delaFuente' $base.fam > ${base}_onlyModernEnmascarados.KEEP
grep -v 'Luisi\|delaFuente\|French\|Mbuti\|Yoruba ' $base.fam > ${base}_onlyAncient.KEEP

###get missing data per snp and per ind
plink --bfile ${base} --keep ${base}_onlyModernEnmascarados.KEEP --missing --out ${base}_onlyModernEnmascarados
plink --bfile ${base} --keep ${base}_onlyAncient.KEEP --missing --out ${base}_onlyAncient

