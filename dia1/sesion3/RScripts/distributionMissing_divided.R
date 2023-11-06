#!/bin/Rscript

###we read the parameters:
params<-commandArgs(trailingOnly=T)
prefin=params[1]
print(prefin)
#PER INDIVIDUAL


###we start a pdf where all graphs will be saved (one page per graph)
pdf(paste(prefin,"_missing.pdf",sep=""))


###we read the file for missingness per individual
missIND<-read.table(paste(prefin,".imiss",sep=""),header=T,stringsAsFactors=F)
#we plot the histogram
hist(missIND$F_MISS,main="Missing Rate per Individual\nAll",ylab="Missing Rate")
print(" some statistics for missingness per ind")
print(summary(missIND$F_MISS))


#PER SNP
missSNP<-read.table(paste(prefin,".lmiss",sep=""),header=T,stringsAsFactors=F)
hist(missSNP$F_MISS,main="Missing Rate per SNP",ylab="Missing Rate")

print(" some statistics for missingness per snp")
print(summary(missSNP$F_MISS))

###we close the pdf
dev.off()


