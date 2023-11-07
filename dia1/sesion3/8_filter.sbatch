#!/bin/bash
#SBATCH -p short
#SBATCH -o Logs/filter.o
#SBATCH -e Logs/filter.e
#SBATCH -J filter
#SBATCH --reservation=cursojnab

shopt -s expand_aliases
source ~/.bash_profile

base=${HOME}/JNAB/dia1/sesion3/Outputs/ModernAncient_withOutgroups
MaxMissingRatePerInd=0.5
MaxMissingRatePerSnp=0.3
MinorAlleleFrequency=0.05

### filter individuals for missing (--mind)
plink --bfile ${base} --mind ${MaxMissingRatePerInd} --make-bed --out ${base}.MIND${MaxMissingRatePerInd}

##### filter snps for missing (--mind)


plink --bfile ${base} --geno ${MaxMissingRatePerInd} --make-bed --out ${base}.MIND${MaxMissingRatePerInd}.GENO${MaxMissingRatePerSnp} 

##on this we filter for MAF
plink --bfile ${base}.MIND${MaxMissingRatePerInd}.GENO${MaxMissingRatePerSnp} --maf --make-bed --out ${base}.MIND${MaxMissingRatePerInd}.GENO${MaxMissingRatePerSnp}.MAF${MinorAlleleFrequency}

###now we filter for LD in sliding windows (try to get independent SNPs)

#first get list of snps to extract according to this criteria
plink --bfile ${base}.MIND${MaxMissingRatePerInd}.GENO${MaxMissingRatePerSnp}.MAF${MinorAlleleFrequency} --indep-pairwise 50 5 0.5 --out ${base}.MIND${MaxMissingRatePerInd}.GENO${MaxMissingRatePerSnp}.MAF${MinorAlleleFrequency}.pruning

#then we extract them
plink --bfile ${base}.MIND${MaxMissingRatePerInd}.GENO${MaxMissingRatePerSnp}.MAF${MinorAlleleFrequency} --extract ${base}.MIND${MaxMissingRatePerInd}.GENO${MaxMissingRatePerSnp}.MAF${MinorAlleleFrequency}.pruning.prune.in --make-bed --out ${base}.MIND${MaxMissingRatePerInd}.GENO${MaxMissingRatePerSnp}.MAF${MinorAlleleFrequency}.pruned


###we fix the loss of population in 6th column for all fam files generated
a=$(ls ${HOME}/JNAB/dia1/sesion3/Outputs/ModernAncient_withOutgroups.MIND*fam)
for i in $a
do
	awk '{$6=$1;print $1,$2,$3,$4,$5,$6}' $i > tmp; mv tmp $i
done

