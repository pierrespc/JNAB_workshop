#!/bin/bash 



for base in StartingData/AADR/AADR_selected StartingData/MaskedModernData/Luisi2020_delaFuente2018_GW.TH0.9.Nat.Phased.Mind1_Ditypes.eigen StartingData/Outgroup/Outgroups  
do

	#get base name:
	basename=$(echo $base | awk -F "/" '{print $NF}')
	###get number of individuals:
	echo number of individuals is: > Outputs/$basename.Numbers.txt
	wc -l ${base}.ind.txt >> Outputs/$basename.Numbers.txt

	echo -e "\n\nnumber of individuals per population:" >> Outputs/$basename.Numbers.txt
	awk '{print $3}' ${base}.ind.txt | sort | uniq -c >> Outputs/$basename.Numbers.txt


	###number of variants
	echo -e "\n\nnumber of variants is:" >> Outputs/$basename.Numbers.txt
	wc -l ${base}.snp.txt >> Outputs/$basename.Numbers.txt
	echo -e "\n\nnumber of variants per chr:" >> Outputs/$basename.Numbers.txt
	awk '{print $2}' ${base}.snp.txt | uniq -c >> Outputs/$basename.Numbers.txt
done




