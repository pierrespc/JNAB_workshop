#!/usr/bin/Rscript


#params<-commandArgs(trailingOnly=T)
root=getwd()
params<-c(paste(root,"/Outputs/Admixture/",sep=""),
	  paste(root,"/StartingData/",sep=""),
	  "ModernAncient_withOutgroups.MIND0.5.GENO0.3.MAF0.05.pruned",
	   paste(root,"/ColorFiles/OrderInd_Admixture.txt",sep=""),
	   paste(root,"/ColorFiles/ColorCode.tsv",sep=""))

if(length(params)!= 5){
	stop("<folderAdm> <folderPlink> <pref> <OrderIND> <regionFile>")
}


listKNUM=c(2:10)
setwd(params[1])

orderRegions<-c("Africa","Europe",
		"Catamarca_Modern","Jujuy_Modern","LaRioja_Modern","Salta_Modern","SanJuan_Modern","Tucuman_Modern",
		"AMBA_Modern","BsAs_Modern","EntreRios_Modern","Cordoba_Modern","SanLuis_Modern",
		"Corrientes_Modern","Formosa_Modern","Misiones_Modern",
		"CentralChile_Modern",
		"Bariloche_Modern","Chubut_Modern","TierraDelFuego_Modern",
		 "SouthPatagonia_Modern",
		"CentralAndes_EH","CentralAndes_MH",
		"Brazil_EH","Brazil_MH","Pampa_MH",
		"CentralChile_MH",
		"SouthPatagonia_MH","SouthPatagonia_LH")

listPLOTregion<-list("Modern"=c("Africa","Europe",
                                "Catamarca_Modern","Jujuy_Modern","LaRioja_Modern","Salta_Modern","SanJuan_Modern","Tucuman_Modern",
                                "AMBA_Modern","BsAs_Modern","EntreRios_Modern","Cordoba_Modern","SanLuis_Modern",
                                "Corrientes_Modern","Formosa_Modern","Misiones_Modern",
                                "CentralChile_Modern",
                                "Bariloche_Modern","Chubut_Modern","TierraDelFuego_Modern",
                                "SouthPatagonia_Modern"),
                       "Ancient"=c("CentralAndes_EH","CentralAndes_MH",
                                   "Brazil_EH","Brazil_MH","Pampa_MH",
                                   "CentralChile_MH",
                                   "SouthPatagonia_MH","SouthPatagonia_LH"))
pref=params[3]
OrderIND=params[4]
#FocusReg<-c("Ancient Central Chile","Central Chile","Patagonia","Ancient Patagonia","Tierra del Fuego","Ancient Tierra del Fuego")
fam<-read.table(paste(params[2],"/",pref,".fam",sep=""),stringsAsFactors = F,header=F)
regions<-read.table(params[5],stringsAsFactors=F,header=T,comment.char = "@",sep="\t")
orderRegions<-orderRegions[ orderRegions %in% regions$Region]
adjustTextRight=300

MyColors<-c("rosybrown","brown","darkolivegreen","darkorange","goldenrod","limegreen","saddlebrown","seagreen","palegreen","cadetblue")
for(KNUM in listKNUM){
  #a<-read.table(paste("chr1.1KG.PopArg.pruned.",KNUM,".Q",sep=""),stringsAsFactors=F,header=F)
  getFile=paste(pref,".",KNUM,".Q",sep="")
  a<-read.table(getFile,stringsAsFactors=F,header=F)
#	outfile<-paste("chr1.1KG.PopArg.pruned.K",KNUM,".pdf",sep="")
  outfile<-paste(pref,".",KNUM,sep="")

  print(paste("plotting K = ",KNUM,sep=""))

  numberK=dim(a)[2]
  numberInd=dim(a)[1]

  if(KNUM==2){
    MyColors<-c("limegreen","cadetblue3")
  }
  if(KNUM==3){
    MyColors<-c("cadetblue3","limegreen","darkorange")
  }
  if(KNUM==4){
    MyColors<-c("darkorange","cadetblue3","limegreen","cadetblue")
  }
  if(KNUM==5){
    MyColors<-c("skyblue1","limegreen","cadetblue3","darkorange","cadetblue")
  }
  if(KNUM==6){
    MyColors<-c("lightgreen","darkorange","cadetblue","limegreen","skyblue1","cadetblue3")
  }
  if(KNUM==7){
    
    MyColors<-c("skyblue1","pink2","limegreen","darkorange","lightgreen","cadetblue","cadetblue3")
  }
  if(KNUM==8){
    MyColors<-c("darkorange","cadetblue","pink2","lightgreen","skyblue1","cadetblue3","limegreen","lightblue1")
  }
  if(KNUM==9){
    MyColors<-c("pink2","limegreen","cadetblue3","skyblue1","violet","lightgreen","cadetblue","darkorange","lightblue1")
  }
  if(KNUM==10){
    
    MyColors<-c("darkorange","violet","lightblue1","lightgreen","blue1","skyblue1","pink2","cadetblue","limegreen","cadetblue3")
  }
  
  if(length(unique(MyColors))!=KNUM){
    print(MyColors[duplicated(MyColors)])
    stop("pb num col")
  }
  a$Ind<-fam$V2
  a$Population<-fam$V1
  
  a<-merge(a,regions,by="Population")

  #a$Region[ is.na(a$Region)]<-a$

  numPops<-length(unique(a$Pops))
  numRegions<-length(unique(a$Region))
  numInds<-nrow(a)
  if(dim(a)[1] != numberInd){
	  stop("your regions file and admixture output do not coincide: do not have the same number of Pops")
  }

  out<-c()
  for(reg in orderRegions){
    temp<-a[ a$Region == reg,]
    if(dim(temp)[1]==0){
      print(paste(reg,"skipped"))
      
      next
    }	
	  meanOverRegion<-vector(length=numberK)
	  names(meanOverRegion)<-paste("V",c(1:numberK),sep="")
	
	
	  meanOverPop<-data.frame(matrix(NA,length(unique(temp$Population)),numberK))
	  names(meanOverPop)<-paste("V",c(1:numberK),sep="")
	  rownames(meanOverPop)<-unique(temp$Population)
	
	  for(K in c(1:numberK)){
		  meanOverRegion[paste("V",K,sep="")]<-mean(temp[,paste("V",K,sep="")])
		  for(pop in unique(temp$Population)){
			  meanOverPop[pop,paste("V",K,sep="")]<-mean(temp[temp$Population==pop,paste("V",K,sep="")])
		  }
	  }
	
	  meanOverRegion<-meanOverRegion[order(as.numeric(meanOverRegion),decreasing=T)]
	  meanOverPop<-meanOverPop[,names(meanOverRegion)]
	  meanOverPop<-meanOverPop[order(meanOverPop[,1],decreasing=T),]
	  for(pop in rownames(meanOverPop)){
		  temp2<-a[ a$Population == pop,]
		  temp2<-temp2[order(temp2[,names(meanOverRegion)[1]],decreasing=T),]
		  out<-rbind(out,temp2)
	  }
  }

  if(OrderIND !="None"){
    orderInd<-read.table(OrderIND,stringsAsFactors=F,header=F)
    rownames(out)<-out$Ind
    out<-out[ orderInd$V1,]
    
  }
  

  #separ<-ceiling(numberInd/500)
  #separPop<-ceiling(numberInd/1000)
  separPop=1
  separ=1
  pdf(paste(outfile,".pdf",sep=""), width=180,height=20)
  par(mar=c(1, 2, 50, 2) + 0.1)
  for(plotname in names(listPLOTregion)){  
    plot(0,0,"n",ylim=c(0,1),xlim=c(0,(numInds+separPop*(numPops-numRegions)+numRegions*(separ)))*1.1,main=paste("K =", numberK),ann=F,axes=F)
    xleft=0
    atPop<-c()
    dimPrevRegion<- 0
    atRegion<-c()
    ITER = 0
    for(reg in listPLOTregion[[plotname]]){
   	  temp<-out[ out$Region == reg,]
	    Population=temp$Population[1]
	    ITER=ITER+1
	
	    Population2=strsplit(Population,split="_Modern")[[1]][1]
	    #axis(3,at=xleft+mean(c(0,sum(temp$Population==Population))),label=Population,cex.axis=6,las=2,col.axis=unique(temp$Color[temp$Population==Population]),tick=T)
	    axis(3,at=xleft+mean(c(0,sum(temp$Population==Population))),label=Population2,cex.axis=4,las=2,tick=T)
	    #axis(3,at=xleft+mean(c(0,sum(temp$Population==Population))),label=ITER,cex.axis=6,las=2,col.axis=unique(temp$Color[temp$Population==Population]),tick=T)
	    for(ind in unique(temp$Ind)){
  		  ybottom=0
	  	  if(temp$Population[ temp$Ind==ind] != Population){
		  	  Population=temp$Population[ temp$Ind==ind]
          #rect(xleft=xleft,xright=xleft+separPop,ybottom=0,ytop=1,col="black",border=NA)
			    xleft=xleft+separPop
			    ITER=ITER+1
			
	  		  #axis(3,at=xleft+mean(c(0,sum(temp$Population==Population))),label=Population,cex.axis=6,las=2,col.axis=unique(temp$Color[temp$Population==Population]),tick=T)
			    Population2=Population
			    axis(3,at=xleft+mean(c(0,sum(temp$Population==Population))),label=Population2,cex.axis=4,las=2,tick=T)
		  	  #axis(3,at=xleft+mean(c(0,sum(temp$Population==Population))),label=ITER,cex.axis=6,las=2,col.axis=unique(temp$Color[temp$Population==Population]),tick=T)
			    dimPrevRegion=dimPrevRegion+separPop
		    }
		    for(k in c(1:numberK)){
			    ytop=ybottom+temp[ temp$Ind==ind,paste("V",k,sep="")]
			    rect(xleft=xleft,xright=xleft+1,ybottom=ybottom,ytop=ytop,col=MyColors[k],border=NA)
			    ybottom=ytop
		    }
		    xleft=xleft+1
	    }
	    xleft=xleft+separ
	    atRegion[reg]<-mean(c(0,sum(temp$Region==reg)))+dimPrevRegion
	    dimPrevRegion=atRegion[reg]+mean(c(0,sum(temp$Region==reg)))+separ
    }
    text(x=(numInds+separPop*(numPops-numRegions)+numRegions*(separ))*1.05,y=0.5,labels = plotname,cex=10)
    
  }
  dev.off()
  meanByPop=data.frame(matrix(NA,0,KNUM))
  names(meanByPop)=paste(c(1:KNUM),sep="")
  iterP=0
  for(region in unique(out$Region)){
    iterP=iterP+1
    meanByPop[iterP,]<-apply(out[out$Region==region,paste("V",c(1:KNUM),sep="")],2,mean)
    rownames(meanByPop)[iterP]<-region
    for(pop in unique(out$Population[out$Region==region])){
      iterP=iterP+1
      meanByPop[iterP,]<-apply(out[out$Population==pop,paste("V",c(1:KNUM),sep="")],2,mean)
      rownames(meanByPop)[iterP]<-pop
    }
  }
  #write.table(meanByPop,paste("chr1.1KG.PopArg.pruned.",KNUM,".MeanByGroup.txt",sep=""),col.names=T,row.names=T,sep="\t",quote=F)
  names(meanByPop)<-MyColors
  write.table(meanByPop,paste(outfile,".MeanByGroup.txt",sep=""),col.names=T,row.names=T,sep="\t",quote=F)
  #  write.table(out,paste("chr1.1KG.PopArg.pruned.",KNUM,".AncestryComponentByIndividual.txt",sep=""),col.names=T,row.names=T,sep="\t",quote=F)  
  names(out)[names(out) %in% paste("V",c(1:KNUM),sep="")]<-MyColors
  write.table(out,paste(outfile,".AncestryComponentByIndividual.txt",sep=""),col.names=T,row.names=F,sep="\t",quote=F)
}

