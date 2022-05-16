# bonferroni correction
rm(list=ls())
hpdi_completo <- get(load("~/B64_DIAMETR/Scripts/Meta_Airwave_ICL/hpdi/metagen_whole.RData"))
hpdi_completo_filtered <- hpdi_completo[,c(1,14,17,20,23,26)]
hpdi_completo_filtered$Nas <- with(hpdi_completo_filtered, ifelse(rowSums(is.na(hpdi_completo_filtered))>2,1,0)) # At least 3 populations with info
hpdi_completo_filtered <- hpdi_completo_filtered[hpdi_completo_filtered$Nas==0,]

hpdi_completo_I2 <- get(load("~/B64_DIAMETR/Scripts/Meta_Airwave_ICL/hpdi/metagen.RData"))
hpdi_completo_I2 <- hpdi_completo_I2[hpdi_completo_I2$SNP%in%hpdi_completo_filtered$SNP,]

hpdi_completo[2:11] <- sapply(hpdi_completo[2:11],as.numeric)

hpdi_completo$`Fixed Bonferroni` <- p.adjust(hpdi_completo$`Fixed Pvalue`, method="bonferroni")
hpdi_completo$`Random Bonferroni` <- p.adjust(hpdi_completo$`Random Pvalue`, method="bonferroni")

corte <- 0.05/length(hpdi_completo_I2$SNP)
hpdi_completo$bonfe_sig<- with(hpdi_completo, ifelse((hpdi_completo$`Fixed Pvalue` <=corte | hpdi_completo$`Random Pvalue`<=corte), 1,0))
hpdi_completo_bonfe_sig <- subset(hpdi_completo, bonfe_sig==1)
hpdi_completo_bonfe_sig_final <- hpdi_completo_bonfe_sig[hpdi_completo_bonfe_sig$`Random Pvalue`<0.000001 | hpdi_completo_bonfe_sig$I2<0.5 | hpdi_completo_bonfe_sig$`Pvalue Q`>0.05,]


save(hpdi_completo_bonfe_sig_final, file="~/B64_DIAMETR/Scripts/Meta_Airwave_ICL/hpdi/metagen_whole_bonfe_sig_ICL.RData")
write.table(hpdi_completo_bonfe_sig_final, "~/B64_DIAMETR/Scripts/Meta_Airwave_ICL/hpdi/metagen_whole_bonfe_sig_ICL.csv", row.names=F, col.names=T, sep=",")
