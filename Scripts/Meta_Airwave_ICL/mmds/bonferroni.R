# bonferroni correction
rm(list=ls())
mmds_completo <- get(load("~/B64_DIAMETR/Scripts/Meta_Airwave_ICL/mmds/metagen_whole.RData"))
mmds_completo_filtered <- mmds_completo[,c(1,14,17,20,23,26)]
mmds_completo_filtered$Nas <- with(mmds_completo_filtered, ifelse(rowSums(is.na(mmds_completo_filtered))>2,1,0)) # At least 3 populations with info
mmds_completo_filtered <- mmds_completo_filtered[mmds_completo_filtered$Nas==0,]

mmds_completo_I2 <- get(load("~/B64_DIAMETR/Scripts/Meta_Airwave_ICL/mmds/metagen.RData"))
mmds_completo_I2 <- mmds_completo_I2[mmds_completo_I2$SNP%in%mmds_completo_filtered$SNP,]

mmds_completo[2:11] <- sapply(mmds_completo[2:11],as.numeric)

mmds_completo$`Fixed Bonferroni` <- p.adjust(mmds_completo$`Fixed Pvalue`, method="bonferroni")
mmds_completo$`Random Bonferroni` <- p.adjust(mmds_completo$`Random Pvalue`, method="bonferroni")

corte <- 0.05/length(mmds_completo_I2$SNP)
mmds_completo$bonfe_sig<- with(mmds_completo, ifelse((mmds_completo$`Fixed Pvalue` <=corte | mmds_completo$`Random Pvalue`<=corte), 1,0))
mmds_completo_bonfe_sig <- subset(mmds_completo, bonfe_sig==1)
mmds_completo_bonfe_sig_final <- mmds_completo_bonfe_sig[mmds_completo_bonfe_sig$`Random Pvalue`<0.000001 | mmds_completo_bonfe_sig$I2<0.5 | mmds_completo_bonfe_sig$`Pvalue Q`>0.05,]


save(mmds_completo_bonfe_sig_final, file="~/B64_DIAMETR/Scripts/Meta_Airwave_ICL/mmds/metagen_whole_bonfe_sig_ICL.RData")
write.table(mmds_completo_bonfe_sig_final, "~/B64_DIAMETR/Scripts/Meta_Airwave_ICL/mmds/metagen_whole_bonfe_sig_ICL.csv", row.names=F, col.names=T, sep=",")
