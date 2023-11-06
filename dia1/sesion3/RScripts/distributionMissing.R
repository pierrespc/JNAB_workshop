#!/bin/Rscript

prefin="Outputs/ModernAncient_withOutgroups"
#PER INDIVIDUAL


###we start a pdf where all graphs will be saved (one page per graph)
pdf(paste(prefin,"_missing.pdf",sep=""))


###we read the file for missingness per individual
missIND<-read.table(paste(prefin,".imiss",sep=""),header=T,stringsAsFactors=F)
#we plot the histogram
hist(missIND$F_MISS,main="Missing Rate per Individual\nAll",ylab="Missing Rate")
print(" some statistics for missingness per ind")
print(summary(missIND$F_MISS))

###now we will divide between modern and ancient
##modern have delaFuente or Luisi in there "family" (pop) name
missINDmodern<-missIND[ grepl("delaFuente",missIND$FID) |  grepl("Luisi",missIND$FID)  ,]
hist(missINDmodern$F_MISS,main="Missing Rate per Individual\nModern",ylab="Missing Rate")
print(" some statistics for missingness per modern sample (no Outgroups here)")
print(summary(missINDmodern$F_MISS))

##now for ancient (they DO NOT have delaFuente or Luisi in there "family" (pop) name (and they are not French, Mbuti, Yoruba)
missINDancient<-missIND[ ! ( grepl("delaFuente",missIND$FID) |  grepl("Luisi",missIND$FID) | grepl("Mbuti",missIND$FID) | grepl("French",missIND$FID ) | grepl("Yoruba",missIND$FID )),]
hist(missINDancient$F_MISS,main="Missing Rate per Individual\nAncient",ylab="Missing Rate")
print(" some statistics for missingness per ancient individual")
print(summary(missINDancient$F_MISS))

###we can do boxplot to compare them : 
#now we put the numbers in a list
listToPlot<-list("All"=missIND$F_MISS,
		 "Modern"=missINDmodern$F_MISS,
		 "Ancient"=missINDancient$F_MISS)

boxplot(listToPlot,main="Missing Rate per Individual",ylab="Missing Rate")



#PER SNP
missSNP<-read.table(paste(prefin,".lmiss",sep=""),header=T,stringsAsFactors=F)
hist(missSNP$F_MISS,main="Missing Rate per SNP",ylab="Missing Rate")

print(" some statistics for missingness per snp")
print(summary(missSNP$F_MISS))

###we close the pdf
dev.off()


