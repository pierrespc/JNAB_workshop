#!/bin/Rscript

change<-function(string,split,pos){
  return(strsplit(string,split = split)[[1]][pos])
}

#params<-commandArgs(trailingOnly=T)
params=c("Outputs/PCA/PCAwithProjection.evec",
	 "Outputs/PCA/PCAwithProjection.eval",
	"ColorFiles/ColorCode.tsv",
       "Outputs/PCA/PCAwithProjection.pdf")


if(length(params)!=4){
  stop("evec eval colors outpdf")
}

evec<-read.table(params[1],stringsAsFactors = F,header=F)
numEvec=dim(evec)[2]-2

eval<-read.table(params[2],stringsAsFactors = F,header=F)


evec$Ind=sapply(evec$V1,change,split=":",pos=2)
evec$Population=sapply(evec$V1,change,split=":",pos=1)
print(dim(evec))
Colors<-read.table(params[3],stringsAsFactors = F,header=T,sep="\t",comment.char = "@")
Colors$Point<-as.numeric(Colors$Point)
evec<-merge(evec,Colors[,c("Region","Population","Color","Point")],by=c("Population"))
print(dim(evec))

eval$Pourcent=eval$V1/sum(eval$V1)*100
print(head(eval$Pourcent))
sum(is.na(evec$Point))
sum(is.na(evec$Color))

print(head(evec))

pdf(params[4])
for( i in seq (1,(numEvec-1),2)){
  plot(evec[,paste("V",i+1,sep="")],evec[,paste("V",i+2,sep="")],
     col=ifelse(evec$Point<21,evec$Color,"black"),pch=as.numeric(evec$Point),
     bg=evec$Color,
     xlab=paste("PC",i," (",round(eval$Pourcent[i],digits=2),"%)",sep=""),
     ylab=paste("PC",i+1," (",round(eval$Pourcent[i+1],digits=2),"%)",sep=""),
     main=paste("PC",i+1," vs PC",i,sep=""))
  
}



plot(0,0,"n",axes=F,ann=F)
legend("center",ncol = 2,cex=0.5,pch=Colors$Point,col = ifelse(Colors$Point<21,Colors$Color,"black"),pt.bg=Colors$Color,legend = paste(Colors$Region,":",Colors$Population))
dev.off()
