#!/bin/bash
#SBATCH -p short
#SBATCH -o Logs/F3.o
#SBATCH -e Logs/F3.e
#SBATCH -J F3

shopt -s expand_aliases
source ~/.bash_profile

base=${HOME}/JNAB/dia2/sesion5/StartingData/ModernAncient_ForFstats
outpref=${HOME}/JNAB/dia2/sesion5//Outputs/F3/F3_BtwInds

##generate new ind.txt with Ind as Pop
awk '{if($3 ~ /Mbuti/ || $3 == "Ignore"){print $1,$2,$3}else{ print $1,$2,$1}}' $base.ind.txt > $base.WithIndAsPop.ind.txt

## get exact name for Mbuti
outgroup=$(grep Mbuti $base.WithIndAsPop.ind.txt | awk '{print $3}' | sort | uniq )
##get inds to be analyzed
listInds=$(grep -v $outgroup $base.WithIndAsPop.ind.txt | grep -v Ignore | awk '{print $3}')
numInds=$(echo $listInds | wc -w)
IndsList=($listInds)
let ' numIndsMinus1 = numInds - 1 '
## generate list comparison
rm -f $outpref.listComparisons
i=0;
while [[ $i -lt $numInds ]];
do
	ind1=${IndsList[$i]}
	j=$i
	while [[ $j -lt $numIndsMinus1 ]];
	do
		let ' j = j + 1 '
		ind2=${IndsList[$j]}
		echo $ind1 $ind2 $outgroup >> $outpref.listComparisons
	done
	let ' i = i + 1 '
done

echo "indivname: $base.WithIndAsPop.ind.txt
snpname: $base.snp.txt
genotypename: $base.geno.txt
popfilename: $outpref.listComparisons
missingmode: YES
inbreed: NO
outgroupmode: NO" >  $outpref.parqp3Pop

qp3Pop -p $outpref.parqp3Pop > $outpref.txt
grep Target $outpref.txt | sed s/std.\ err/stderr/g | sed s/Source\ /Source/g  > $outpref.Cleaned.txt
grep "result:" $outpref.txt | sed s/result://g >> $outpref.Cleaned.txt

