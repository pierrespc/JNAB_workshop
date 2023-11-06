#!/bin/bash
#SBATCH -p short
#SBATCH -o Logs/filter.o
#SBATCH -e Logs/filter.e
#SBATCH -J filter

shopt -s expand_aliases
source ~/.bash_profile

base=${HOME}/JNAB/dia1/sesion3/PrepareData/Outputs/ModernAncient
MaxMissingRatePerInd=0.1
MaxMissingRatePerSnp=0.4
MinorAlleleFrequency=0.05

### filter for missing (--mind and --geno)
plink --bfile ${base} --mind ${MaxMissingRatePerInd} --snp ${MaxMissingRatePerInd} --make-bed --out ${base}.MIND${MaxMissingRatePerInd}.GENO${MaxMissingRatePerSnp} 

##on this we filter for MAF
plink --bfile ${base}.MIND${MaxMissingRatePerInd}.GENO${MaxMissingRatePerSnp} --maf --make-bed --out ${base}.MIND${MaxMissingRatePerInd}.GENO${MaxMissingRatePerSnp}.MAF${MinorAlleleFrequency}

###now we filter for LD in sliding windows (try to get independent SNPs)

#first get list of snps to extract according to this criteria
plink --bfile ${base}.MIND${MaxMissingRatePerInd}.GENO${MaxMissingRatePerSnp}.MAF${MinorAlleleFrequency} --indep-pairwise 50 5 0.5 --out ${base}.MIND${MaxMissingRatePerInd}.GENO${MaxMissingRatePerSnp}.MAF${MinorAlleleFrequency}.pruning

#then we extract them
plink --bfile ${base}.MIND${MaxMissingRatePerInd}.GENO${MaxMissingRatePerSnp}.MAF${MinorAlleleFrequency} --extract ${base}.MIND${MaxMissingRatePerInd}.GENO${MaxMissingRatePerSnp}.MAF${MinorAlleleFrequency}.pruning.extract.in --make-bed --out ${base}.MIND${MaxMissingRatePerInd}.GENO${MaxMissingRatePerSnp}.MAF${MinorAlleleFrequency}.pruned


