rm(list=ls())

modelo = commandArgs()[6]
##Manifiesto de Illumina EPIC
mani <- read.csv("/home/jdominguez1/manifest450k.csv", 
                 skip=7, 
                 stringsAsFactors=F, 
                 header=T, 
                 sep=",",
                 quote="")

rownames(mani) <- mani$IlmnID

##Funciones
manhattan <- function(dataframe, colors=c("gray10", "gray50"), ymax="max", limitchromosomes=1:23, genomewideline=-log10(0.05/length(cpg)), annotate=NULL, ...) {
  
  d=dataframe
  if (!("CHR" %in% names(d) & "BP" %in% names(d) & "P" %in% names(d))) stop("Make sure your data frame contains columns CHR, BP, and P")
  
  if (any(limitchromosomes)) d=d[d$CHR %in% limitchromosomes, ]
  d=subset(na.omit(d[order(d$CHR, d$BP), ]), (P>0 & P<=1)) # remove na's, sort, and keep only 0<P<=1
  d$logp = -log10(d$P)
  d$pos=NA
  ticks=NULL
  lastbase=0
  colors <- rep(colors,max(d$CHR))[1:max(d$CHR)]
  if (ymax=="max") ymax<-ceiling(max(d$logp))
  if (ymax<8) ymax<-8
  
  numchroms=length(unique(d$CHR))
  if (numchroms==1) {
    d$pos=d$BP
    ticks=floor(length(d$pos))/2+1
  } else {
    for (i in unique(d$CHR)) {
      if (i==1) {
        d[d$CHR==i, ]$pos=d[d$CHR==i, ]$BP
      } else {
        lastbase=lastbase+tail(subset(d,CHR==i-1)$BP, 1)
        d[d$CHR==i, ]$pos=d[d$CHR==i, ]$BP+lastbase
      }
      ticks=c(ticks, d[d$CHR==i, ]$pos[floor(length(d[d$CHR==i, ]$pos)/2)+1])
    }
  }
  
  if (numchroms==1) {
    with(d, plot(pos, logp, ylim=c(0,ymax), ylab=expression(-log[10](italic(p))), xlab=paste("Chromosome",unique(d$CHR),"position"), ...))
  }  else {
    with(d, plot(pos, logp, ylim=c(0,ymax), ylab=expression(-log[10](italic(p))), xlab="Chromosome", xaxt="n", type="n", ...))
    axis(1, at=ticks, lab=unique(d$CHR), ...)
    icol=1
    for (i in unique(d$CHR)) {
      with(d[d$CHR==i, ],points(pos, logp, col=colors[icol], ...))
      icol=icol+1
    }
  }
  
  if (!is.null(annotate)) {
    d.annotate=d[which(d$SNP %in% annotate), ]
    with(d.annotate, points(pos, logp, col="green3", ...)) 
  }
  
  
  if (genomewideline) abline(h=genomewideline, col="red")
}

#Resultados EWAS

#Modelo 1
res1 = get(load("/home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv/dashf/bacon.RData"))

#Lista de CpGs analizados
cpg <- rownames(res1)

mani1 <- mani[cpg,]

#DB para el Manhattan plot
SNP <- cpg
CHR <- as.character(mani1$CHR)
BP <- mani1$MAPINFO
P <- res1$Pvalue
manh1 <- as.data.frame(cbind(SNP,CHR,BP,P))

#Cromosomas sexuales
manh1 <- manh1[-which(manh1$CHR=="X"),]
manh1 <- manh1[-which(manh1$CHR=="Y"),]


#Convertir variables a numéricas (SNP-cpg y cromosoma a carácter)
manh1$CHR <- as.character(manh1$CHR)
manh1$SNP <- as.character(manh1$SNP)
manh1$CHR <- as.numeric(manh1$CHR)  
manh1$BP <- as.numeric(as.character(manh1$BP))
manh1$P <- as.numeric(as.character(manh1$P))


#Manhattan Plot:
png("/home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv/dashf/manhattanplot_bacon.png", 
    height=3600, 
    width=6000, 
    res=600,
    units = "px")

###Añadir línea de corte del pval=10-5
manhattan(manh1, 
          genomewideline=-log10(1E-5))

###Añadir línea de corte del pval corregido por Bonferroni
abline(h=-log10(0.05/length(cpg)), 
       col="black",
       lty=2)
title(main = "Manhattan plot WHI dashf")

dev.off()

