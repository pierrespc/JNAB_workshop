#!/bin/bash


head -1  ../../../ReferenceDataSet/ColorCompendium_Modern.txt | cut -f1,2,10,11> ColorCode.tsv
listPops=$(awk '{print $3}' ../*/*ind.txt | sort | uniq )
for pop in $listPops
do
	n=$(awk -F "\t" -v OFS="\t" -v p=$pop '{if($2==p)print $0}' ../../../ReferenceDataSet/ColorCompendium_{Ancient,Modern}.txt | wc -l)
	if [[ $n != 1 ]]
	then
		echo $pop $n
	fi
	grep  $pop ../../../ReferenceDataSet/ColorCompendium_{Ancient,Modern}.txt  | cut -d':' -f2 | cut -f 1,2,10,11 >> ColorCode.tsv
done

grep -w Brazil_LapaDoSanto_9600BP ../../../ReferenceDataSet/ColorCompendium_Ancient.txt | cut -f1,2,10,11 >>  ColorCode.tsv
grep -w Brazil_Laranjal_6800BP  ../../../ReferenceDataSet/ColorCompendium_Ancient.txt | sed s/6800BP/6700BP/g | cut -f1,2,10,11 >> ColorCode.tsv

echo -e "Africa\tMbuti.SDG\t1\tblack" >> ColorCode.tsv
echo -e "Africa\tYoruba.SDG\t2\tblack" >> ColorCode.tsv
echo -e "Europe\tFrench.SDG\t3\tgrey" >> ColorCode.tsv

