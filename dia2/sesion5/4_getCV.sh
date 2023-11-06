#!/bin/bash

echo -e "K\tCV" > Outputs/Admixture/ModernAncient_withOutgroups.MIND0.5.GENO0.3.MAF0.05.pruned.CV.tsv
for K in {2..10}
do
	cv=$(grep "CV error" Outputs/Admixture/ModernAncient_withOutgroups.MIND0.5.GENO0.3.MAF0.05.pruned.K$K.log | awk '{print $NF}')
	echo -e $K"\t"$cv >>Outputs/Admixture/ModernAncient_withOutgroups.MIND0.5.GENO0.3.MAF0.05.pruned.CV.tsv
done


