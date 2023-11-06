#!/bin/bash
#SBATCH -p short
#SBATCH -o Logs/plotMissing.o
#SBATCH -e Logs/plotMissing.e
#SBATCH -J plotMissing

shopt -s expand_aliases
source ~/.bash_profile

base=${HOME}/JNAB/dia1/sesion3/PrepareData/Outputs/ModernAncient

###get missing data per snp and per ind
Rscript /home/shared/cursojnab/dia1/sesion3/RScripts/distributionMissing.R ${base}

