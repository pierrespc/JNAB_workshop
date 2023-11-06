#!/bin/bash 


base=${HOME}/JNAB/dia1/sesion3/PrepareData/Outputs/ModernAncient


###get number of individuals:
echo number of individuals is:
wc -l ${base}.fam

echo number of individuals per population:
awk '{print $1}' ${base}.fam | sort | uniq -c


###number of variants
echo number of variants is:
wc -l ${base}.bim
echo number of variants per chr:
awk '{print $1}' ${base}.bim | uniq -c




