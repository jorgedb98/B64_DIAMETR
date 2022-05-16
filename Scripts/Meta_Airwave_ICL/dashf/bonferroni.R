# bonferroni correction
rm(list=ls())
dashf_completo <- get(load("~/B64_DIAMETR/Scripts/Meta_Airwave_ICL/dashf/metagen_whole.RData"))
dashf_completo_filtered <- dashf_completo[,c(1,14,17,20,23,26)]
dashf_completo_filtered$Nas <- with(dashf_completo_filtered, ifelse(rowSums(is.na(dashf_completo_filtered))>2,1,0)) # At least 3 populations with info
dashf_completo_filtered <- dashf_completo_filtered[dashf_completo_filtered$Nas==0,]

dashf_completo_I2 <- get(load("~/B64_DIAMETR/Scripts/Meta_Airwave_ICL/dashf/metagen.RData"))
dashf_completo_I2 <- dashf_completo_I2[dashf_completo_I2$SNP%in%dashf_completo_filtered$SNP,]

dashf_completo[2:11] <- sapply(dashf_completo[2:11],as.numeric)

dashf_completo$`Fixed Bonferroni` <- p.adjust(dashf_completo$`Fixed Pvalue`, method="bonferroni")
dashf_completo$`Random Bonferroni` <- p.adjust(dashf_completo$`Random Pvalue`, method="bonferroni")

corte <- 0.05/length(dashf_completo_I2$SNP)
dashf_completo$bonfe_sig<- with(dashf_completo, ifelse((dashf_completo$`Fixed Pvalue` <=corte | dashf_completo$`Random Pvalue`<=corte), 1,0))
dashf_completo_bonfe_sig <- subset(dashf_completo, bonfe_sig==1)
dashf_completo_bonfe_sig_final <- dashf_completo_bonfe_sig[dashf_completo_bonfe_sig$`Random Pvalue`<0.000001 | dashf_completo_bonfe_sig$I2<0.5 | dashf_completo_bonfe_sig$`Pvalue Q`>0.05,]


save(dashf_completo_bonfe_sig_final, file="~/B64_DIAMETR/Scripts/Meta_Airwave_ICL/dashf/metagen_whole_bonfe_sig_ICL.RData")
write.table(dashf_completo_bonfe_sig_final, "~/B64_DIAMETR/Scripts/Meta_Airwave_ICL/dashf/metagen_whole_bonfe_sig_ICL.csv", row.names=F, col.names=T, sep=",")
