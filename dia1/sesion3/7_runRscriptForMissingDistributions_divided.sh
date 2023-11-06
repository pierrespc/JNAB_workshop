#!/bin/bash
#SBATCH -p short
#SBATCH -o Logs/plotMissing.o
#SBATCH -e Logs/plotMissing.e
#SBATCH -J plotMissing

shopt -s expand_aliases
source ~/.bash_profile


base=Outputs/ModernAncient_withOutgroups
###get missing data per snp and per ind
Rscript ${HOME}/JNAB/dia1/sesion3/RScripts/distributionMissing_divided.R  ${base}_onlyModernEnmascarados
Rscript ${HOME}/JNAB/dia1/sesion3/RScripts/distributionMissing_divided.R  ${base}_onlyAncient

