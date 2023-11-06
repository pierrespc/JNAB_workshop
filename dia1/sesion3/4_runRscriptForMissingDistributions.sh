#!/bin/bash
#SBATCH -p short
#SBATCH -o $(pwd)/Logs/plotMissing.o
#SBATCH -e $(pwd)/Logs/plotMissing.e
#SBATCH -J plotMissing

base=${HOME}/JNAB/dia1/sesion3/PrepareData/Outputs/ModernAncient

###get missing data per snp and per ind
Rscript /home/shared/cursojnab/dia1/sesion3/RScripts/distributionMissing.R ${base}

