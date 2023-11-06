#!/bin/bash

famIN<-read.table("Outputs/ModernAncient_withOutgroups.fam",stringsAsFactors=F,header=F)
#famIN$V2<-sapply(famIN$V2,change,USE.NAMES=F)
indModern<-read.table("StartingData/MaskedModernData/Luisi2020_delaFuente2018_GW.TH0.9.Nat.Phased.Mind1_Ditypes.eigen.ind.txt",stringsAsFactors=F,header=F)
indAADR<-read.table("StartingData/AADR/AADR_selected.ind.txt",stringsAsFactors=F,header=F)
indOutgroup<-read.table("StartingData/Outgroup/Outgroups.ind.txt",stringsAsFactors=F,header=F)

indRef<-rbind(indModern,indAADR,indOutgroup)
head(indRef)
head(famIN)
system("cp Outputs/ModernAncient_withOutgroups.fam Outputs/ModernAncient_withOutgroups.NoPopInfo.fam")
for(i in c(1:nrow(famIN))){
	famIN$V1[i]<-famIN$V6[i]<-indRef$V3[ indRef$V1==famIN$V2[i]]
}

write.table(famIN,"Outputs/ModernAncient_withOutgroups.fam",col.names=F,row.names=F,quote=F)
