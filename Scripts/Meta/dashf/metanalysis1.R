rm(list=ls())
##LINEA38
#Cargar las bases de datos a metaanalizar y converger los cpgs con los valores estadísticos de cada base de datos
R450k <- read.table("/home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/450k/dashf/model_2sva_dashf.csv", header=T, stringsAsFactors = F, sep=";")
R450k <- R450k[order(R450k[,1]),]

FHS <- read.table("/home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/dashf/results_linear/model_2sva_dashf.csv", header=T, stringsAsFactors = F, sep=";")

WHI <- read.table("/home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv/dashf/model_6sva_dashf.csv", header=T, stringsAsFactors = F, sep=";")

tabla <- merge(R450k, FHS, by="cpg")
tabla <- merge(tabla, WHI, by = "cpg")

metaa<-function(x){
  names(x)=c("cpg","coef_R","SE_R","pval_R","coef_F","pval_F","SE_F","coef_W","SE_W", "pval_W")
  # 1-. Es calculen els pesos per a cada cohort com:
  w_mod_R<-1/(x$SE_R^2)
  w_mod_F<-1/(x$SE_F^2)
  w_mod_W<-1/(x$SE_W^2)
  
  # 2-. Despres es calcula la mitjana ponderada per a tenir l'efecte comu (meta-analitzat
  coefcomu_mod=(x$coef_R*w_mod_R+x$coef_F*w_mod_F+x$coef_W*w_mod_W)/(w_mod_R+w_mod_F+w_mod_W)
  
  # 3-. La variancia comuna
  varcomu_mod=1/(w_mod_R+w_mod_F+w_mod_W)
  SEcomu_mod=sqrt(varcomu_mod)
  
  # 4-. Finalment el p-valor es
  pval_meta_mod=3*(1-pnorm(abs(coefcomu_mod/SEcomu_mod)))
  
  ## table
  ##metaanalisis efectes fixes
  x$coef_meta<-coefcomu_mod
  x$SE_meta<-SEcomu_mod
  x$pval_meta<-pval_meta_mod
  
  ###comparacio de coeficients
  # pval_coef_comp_mod=2*(1-pnorm(abs((x$coef_R-x$coef_y)/sqrt(x$SE_x^2+x$SE_y^2))))
  
  ###metaanalisis efectes aleatoris
  # 1-. Es calculen els pesos per a cada cohort
  w_mod_R<-1/(x$SE_R^2)
  w_mod_F<-1/(x$SE_F^2)
  w_mod_W<-1/(x$SE_W^2)
  
  # 2-. Es calcula la quantitat c
  c_mod=(w_mod_R+w_mod_F+w_mod_W)-(w_mod_R^2+w_mod_F^2+w_mod_W^2)/(w_mod_R+w_mod_F+w_mod_W)
  
  # 3-. Es calcula lefecte ponderat Tbar pels pesos w1 i w2:
  Tbar_mod=(x$coef_R*w_mod_R+x$coef_F*w_mod_F+x$coef_w*w_mod_W)/(w_mod_R+w_mod_F+w_mod_W)
  
  # 4-. Es calcula l'estad?stic Q (que servira per a testar lheterogene?tat)
  Q_mod=w_mod_R*(x$coef_R-Tbar_mod)^2+w_mod_F*(x$coef_F-Tbar_mod)^2+w_mod_W*(x$coef_W-Tbar_mod)^2
  
  # 5-. Sestima la variabilitat entre estudis a partir de Q:
  # k es igual el numero d'estudis'
  k<-3
  #tau2_mod=(Q_mod-(k-1))/c_mod
  tau2_mod=ifelse((Q_mod-(k-1)/c_mod)>0,(Q_mod-(k-1)/c_mod),0)
  
  # 6-. Es recalculen els pesos w tenint en compte la variabilitat entre estudis:
  w1r_mod=1/(x$SE_R+tau2_mod)
  w2r_mod=1/(x$SE_F+tau2_mod)
  w3r_mod=1/(x$SE_W+tau2_mod)
  
  # 7-. Es calcula lefecte comu (beta meta-analitzada)
  coefcomu_mod=(w1r_mod*x$coef_R+w2r_mod*x$coef_F+w3r_mod*x$coef_w)/(w1r_mod+w2r_mod+w3r_mod)
  
  # 8-. Es calcula la variancia comuna (var meta-analitzada)
  varcomu_mod=1/(w1r_mod+w2r_mod+w3r_mod)
  SEcomu_mod=sqrt(varcomu_mod)
  
  # 9-. Finalment el p-valor del metaanalisis
  pval_meta_rand_mod=3*(1-pnorm(abs(coefcomu_mod/SEcomu_mod)))
  
  # 10-. Lindex dheterogeneitat I2 es calcula com:
  # k es igual al numero destudis
  k=3
  I2_mod=ifelse(((Q_mod-(k-1))/Q_mod)>0,((Q_mod-(k-1))/Q_mod),0)
  
  # 11-. I per  a testar si la heterogeneitat es significativa o no, es calcula el pvalor de la heteregeneitat
  # k es igual al numero destudis
  k=3
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

write.table(resmeta, file="/home/jdominguez1/B64_DIAMETR/Scripts/Meta/dashf/model_dashf.csv", 
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

write.table(res, file="/home/jdominguez1/B64_DIAMETR/Scripts/Meta/dashf/model_dashf_noxy.csv", 
            col.names=T, 
            row.names=F, 
            quote=T, 
            sep=";")

# ###Quedarnos con los CpGs que se asocian con Casos/Controles con un pval corregido por Bonferroni de los CpGs que pasaron el QC del EPIC y están en el 450k
# bonf_xy <- read.table("/projects/regicor/METIAM/EPIC/EWAS/validation/mvals_z_4sd/bonferroni_xy.csv", header=T, stringsAsFactors=F, sep=";") # 421940 cpgs del qc EPIC en 450k
# res_xy <- res[-which(res$pval_meta>(0.05/dim(bonf_xy)[1])),] 
# write.table(res_xy,
#             file="/projects/regicor/METIAM/EPIC/EWAS_meta/mvals_z_4sd/2svas/incid_chd/n2540/signif_bonferroni_model1_xy.csv",
#             col.names=T,
#             row.names=F,
#             quote=T,
#             sep=";")
# 
# ###Quedarnos con los CpGs autosomicos que se asocian con Casos/Controles con un pval corregido por Bonferroni de los CpGs que pasaron el QC del EPIC y están en el 450k 
# bonf <- read.table("/projects/regicor/METIAM/EPIC/EWAS/validation/mvals_z_4sd/bonferroni.csv", header=T, stringsAsFactors=F, sep=";") # 421940 cpgs del qc EPIC en 450k
# res <- res[-which(res$pval_meta>(0.05/dim(bonf)[1])),] 
# write.table(res,
#             file="/projects/regicor/METIAM/EPIC/EWAS_meta/mvals_z_4sd/2svas/incid_chd/n2540/signif_bonferroni_model1.csv",
#             col.names=T,
#             row.names=F,
#             quote=T,
#             sep=";")
