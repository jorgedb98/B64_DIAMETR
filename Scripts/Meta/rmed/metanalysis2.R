rm(list=ls())

#Cargar las bases de datos a metaanalizar y converger los cpgs con los valores estadísticos de cada base de datos
Regicor <- read.table("/projects/regicor/METIAM/EPIC/EWAS/discovery/mvals_z_4sd/2svas/Model_smoke_celltype_svas/model2_2sva.csv", header=T, stringsAsFactors = F, sep=";")
Regicor <- Regicor[order(Regicor[,1]),]

FHS <- read.table("/projects/regicor/METIAM/EPIC/EWAS_fhs/discov_fhs/mvals_z_4sd/2svas/incid_chd/model_smoke_celltype_svas/n2540/model2_2sva.csv", header=T, stringsAsFactors = F, sep=";")

tabla <- merge(Regicor, FHS, by="cpg")
tabla

metaa<-function(x){
  names(x)=c("cpg","coef_x","SE_x","pval_x","coef_y","HR_y","SE_y","pval_y")
  # 1-. Es calculen els pesos per a cada cohort com:
  w_mod_x<-1/(x$SE_x^2)
  w_mod_y<-1/(x$SE_y^2)
  
  # 2-. Despres es calcula la mitjana ponderada per a tenir l'efecte comu (meta-analitzat
  coefcomu_mod=(x$coef_x*w_mod_x+x$coef_y*w_mod_y)/(w_mod_x+w_mod_y)
  
  # 3-. La variancia comuna
  varcomu_mod=1/(w_mod_x+w_mod_y)
  SEcomu_mod=sqrt(varcomu_mod)
  
  # 4-. Finalment el p-valor es
  pval_meta_mod=2*(1-pnorm(abs(coefcomu_mod/SEcomu_mod)))
  
  ## table
  ##metaanalisis efectes fixes
  x$coef_meta<-coefcomu_mod
  x$SE_meta<-SEcomu_mod
  x$pval_meta<-pval_meta_mod
  
  ###comparacio de coeficients
  pval_coef_comp_mod=2*(1-pnorm(abs((x$coef_x-x$coef_y)/sqrt(x$SE_x^2+x$SE_y^2))))
  
  ###metaanalisis efectes aleatoris
  # 1-. Es calculen els pesos per a cada cohort
  w_mod_x<-1/(x$SE_x^2)
  w_mod_y<-1/(x$SE_y^2)
  
  # 2-. Es calcula la quantitat c
  c_mod=(w_mod_x+w_mod_y)-(w_mod_x^2+w_mod_y^2)/(w_mod_x+w_mod_y)
  
  # 3-. Es calcula lefecte ponderat Tbar pels pesos w1 i w2:
  Tbar_mod=(x$coef_x*w_mod_x+x$coef_y*w_mod_y)/(w_mod_x+w_mod_y)
  
  # 4-. Es calcula l'estad?stic Q (que servira per a testar lheterogene?tat)
  Q_mod=w_mod_x*(x$coef_x-Tbar_mod)^2+w_mod_y*(x$coef_y-Tbar_mod)^2
  
  # 5-. Sestima la variabilitat entre estudis a partir de Q:
  # k es igual el numero d'estudis'
  k<-2
  #tau2_mod=(Q_mod-(k-1))/c_mod
  tau2_mod=ifelse((Q_mod-(k-1)/c_mod)>0,(Q_mod-(k-1)/c_mod),0)
  
  # 6-. Es recalculen els pesos w tenint en compte la variabilitat entre estudis:
  w1r_mod=1/(x$SE_x+tau2_mod)
  w2r_mod=1/(x$SE_y+tau2_mod)
  
  # 7-. Es calcula lefecte comu (beta meta-analitzada)
  coefcomu_mod=(w1r_mod*x$coef_x+w2r_mod*x$coef_y)/(w1r_mod+w2r_mod)
  
  # 8-. Es calcula la variancia comuna (var meta-analitzada)
  varcomu_mod=1/(w1r_mod+w2r_mod)
  SEcomu_mod=sqrt(varcomu_mod)
  
  # 9-. Finalment el p-valor del metaanalisis
  pval_meta_rand_mod=2*(1-pnorm(abs(coefcomu_mod/SEcomu_mod)))
  
  # 10-. Lindex dheterogeneitat I2 es calcula com:
  # k es igual al numero destudis
  k=2
  I2_mod=ifelse(((Q_mod-(k-1))/Q_mod)>0,((Q_mod-(k-1))/Q_mod),0)
  
  # 11-. I per  a testar si la heterogeneitat es significativa o no, es calcula el pvalor de la heteregeneitat
  # k es igual al numero destudis
  k=2
  pval.het_mod=1-pchisq(Q_mod,k-1)
  
  ## table
  ##coef_comp
  x$pval_coef_comp<-pval_coef_comp_mod
  ##metaanalisis efectes aleatoris
  x$coef_meta_rand<-coefcomu_mod
  x$SE_meta_rand<-SEcomu_mod
  x$pval_meta_rand<-pval_meta_rand_mod
  ##heterogeneitat
  x$I2<-I2_mod
  x$pval.het<-pval.het_mod
  return(x)
}

resmeta <- metaa(tabla)

write.table(resmeta, file="/projects/regicor/METIAM/EPIC/EWAS_meta/mvals_z_4sd/2svas/incid_chd/n2540/model2.csv", 
            col.names=T, 
            row.names=F, 
            quote=T, 
            sep=";")

#Tabla con CpGs significativos:

###Manifiesto de Illumina 450k
mani <- readRDS("/projects/regicor/METIAM/EPIC/manifest450k.rds")
mani <- mani[1:485577,] ### Remove some rows about QC
rownames(mani) <- mani$IlmnID

###Comprobar que los CpGs del manifiesto estén en el mismo orden que la DB
k450 <- mani[resmeta$cpg,]
identical(resmeta$cpg, rownames(k450))

###DB con datos genómicos
gdata <- as.data.frame(cbind(as.character(k450$IlmnID), as.character(k450$CHR), k450$MAPINFO, as.character(k450$UCSC_RefGene_Name), as.character(k450$UCSC_RefGene_Accession)))
names(gdata) <- c("CpG","Chromosome","Position","Gene","UCSC_ref")

###Añadir a datos metaanalisis
names(resmeta)[1] <- "CpG"
res <- as.data.frame(merge(gdata, resmeta, by="CpG"))
res <- res[order(res[,"pval_meta"]),]
head(res)

#Cromosomas sexuales
res <- res[-which(res$Chromosome=="X"),] #9376
res <- res[-which(res$Chromosome=="Y"),] #18
# 412546 cpgs no sexuales en la lista de genes iniciales 

write.table(res, file="/projects/regicor/METIAM/EPIC/EWAS_meta/mvals_z_4sd/2svas/incid_chd/n2540/model2_noxy.csv", 
            col.names=T, 
            row.names=F, 
            quote=T, 
            sep=";")

###Quedarnos con los CpGs que se asocian con Casos/Controles con un pval corregido por Bonferroni de los CpGs que pasaron el QC del EPIC y están en el 450k
bonf_xy <- read.table("/projects/regicor/METIAM/EPIC/EWAS/validation/mvals_z_4sd/bonferroni_xy.csv", header=T, stringsAsFactors=F, sep=";") # 421940 cpgs del qc EPIC en 450k
res_xy <- res[-which(res$pval_meta>(0.05/dim(bonf_xy)[1])),] 
write.table(res_xy,
            file="/projects/regicor/METIAM/EPIC/EWAS_meta/mvals_z_4sd/2svas/incid_chd/n2540/signif_bonferroni_model2_xy.csv",
            col.names=T,
            row.names=F,
            quote=T,
            sep=";")

###Quedarnos con los CpGs autosomicos que se asocian con Casos/Controles con un pval corregido por Bonferroni de los CpGs que pasaron el QC del EPIC y están en el 450k 
bonf <- read.table("/projects/regicor/METIAM/EPIC/EWAS/validation/mvals_z_4sd/bonferroni.csv", header=T, stringsAsFactors=F, sep=";") # 421940 cpgs del qc EPIC en 450k
res <- res[-which(res$pval_meta>(0.05/dim(bonf)[1])),] 
write.table(res,
            file="/projects/regicor/METIAM/EPIC/EWAS_meta/mvals_z_4sd/2svas/incid_chd/n2540/signif_bonferroni_model2.csv",
            col.names=T,
            row.names=F,
            quote=T,
            sep=";")
