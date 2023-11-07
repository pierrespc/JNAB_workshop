#!/bin/Rscript

#params<-commandArgs(trailingOnly=T)
params=c("Outputs/F3/F3_BtwInds.Cleaned",
	 "StartingData/ModernAncient_ForFstats.ind.txt",
	"ColorFiles/ColorCode.tsv")
if(length(params)!=3){
  stop("<prefF3file> <INDfile> <colorFile>")
}

prefF3file<-params[1]
INDfile<-params[2]
COLORfile=params[3]



###########################################################################
###########################################################################
###########################################################################
###########################################################################

change<-function(string,split,pos){
  return(strsplit(string,split = split,fixed=T)[[1]][pos])
  
}

###########################################################################
###########################################################################


f3<-read.table(paste(prefF3file,".txt",sep=""),stringsAsFactors = F,header=T)
fam<-read.table(INDfile,stringsAsFactors = F,header=F)
fam<-fam[,c(3,1)]
names(fam)<-c("Population","Individual")
Colors<-read.table(COLORfile,stringsAsFactors = F,header=T,sep="\t",comment.char = "@")
listInd<-unique(c(f3$Source1,f3$Source2))

##generate distance matrix
dm<-data.frame(matrix(NA,length(listInd),length(listInd)))
names(dm)<-listInd
rownames(dm)<-listInd
for(p1 in c(1:(length(listInd)-1))){
  print(p1)
  dm[p1,p1]<-0
  for(p2 in c((p1+1):length(listInd))){
	  print(paste(p1,p2))
    print(na.omit(c(f3$f_3[ f3$Source1==listInd[p1] & f3$Source2==listInd[p2]],f3$f_3[ f3$Source1==listInd[p2] & f3$Source2==listInd[p1]])))
    dm[p2,p1]<-dm[p1,p2]<-1 -na.omit(c(f3$f_3[ f3$Source1==listInd[p1] & f3$Source2==listInd[p2]],f3$f_3[ f3$Source1==listInd[p2] & f3$Source2==listInd[p1]]))
  }
  
}
p1=p1+1
dm[p1,p1]<-0


##################

mds<-cmdscale(dm,6)
mds<-data.frame(mds)
mds$Individual<-row.names(mds)
print(dim(mds))
mds<-merge(mds,fam,by="Individual")
print(dim(mds))
mds<-merge(mds,Colors,by="Population")
print(dim(mds))

pdf(paste(prefF3file,".pdf",sep=""))
for(i in seq(1,sum(str_starts(names(mds),"X")),2)){
      plot(mds[,paste("X",i,sep="")],mds[,paste("X",i+1,sep="")],"n",
           main="MDS based on 1-F3(Ind1,Ind2;Mbuti)",
           xlab=paste("Dim.",i),
           ylab=paste("Dim.",i+1))
      points(mds[,paste("X",i,sep="")],mds[,paste("X",i+1,sep="")],
             pch=mds$Point,
             col=ifelse(mds$Point<21,mds$Color,"black"),
             bg=mds$Color)
}
Leg<-unique(mds[,c("Region","Population","Color","Point")])
legend("center",pch=Leg$Point,col=ifelse(Leg$Point<21,Leg$Color,"black"),
         pt.bg=Leg$Color,
         legend = paste(Leg$Region,": ",Leg$Population,sep=""),
         ncol=2,
         cex=0.5)
dev.off()
write.table(mds,paste(prefF3,"_MDS.tsv",sep=""),col.names=T,row.names=F,sep="\t",quote=F)
