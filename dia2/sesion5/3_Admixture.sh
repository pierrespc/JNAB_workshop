#!/bin/bash

root=$(pwd)
base=$root/StartingData/ModernAncient_withOutgroups.MIND0.5.GENO0.3.MAF0.05.pruned

cd  Outputs/Admixture/
for K in {2..10}
do
	sbatch -J K$K -o $root/Logs/Admixture.K$K.o -e $root/Logs/Admixture.K$K.e -p short \
		--wrap "shopt -s expand_aliases; 
			source ~/.bash_profile;
			admixture $base.bed $K --seed 1234 --cv > ModernAncient_withOutgroups.MIND0.5.GENO0.3.MAF0.05.pruned.K$K.log"
done
