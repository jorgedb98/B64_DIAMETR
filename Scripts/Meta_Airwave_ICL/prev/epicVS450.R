###################################
#### Intercepting the CpG common
###################################

# If data comes from bacon, need to remove the 2,3,4 columns and change names of the
# new data frame

rm(list = ls())

###################
# MMDS
###################

mmds_FHS <- get(load("~/B64_DIAMETR/Scripts/FHS/sv/mmds/results_mixed/bacon_noxy.RData"))

mmds_WHI <- get(load("~/B64_DIAMETR/Scripts/WHI/sv/mmds/bacon_noxy.RData"))

mmds_450 <- get(load("~/B64_DIAMETR/Scripts/REGICOR/sv/450k/mmds/model_2sva_noxy_mmds.RData"))

mmds_FHS_WHI <- merge(mmds_FHS, mmds_WHI, by="SNP",all=T)
mmds_FHS_WHI <- mmds_FHS_WHI[,c(1:6,9:11)]
names(mmds_FHS_WHI) <- c("SNP", "CHR", "BP", "Coefficient FHS","SE FHS","Pvalue FHS","Coefficient WHI", "SE WHI", "Pvalue WHI")

mmds_FHS_WHI_REG450 <- merge(mmds_FHS_WHI, mmds_450, by="SNP",all=T)
mmds_FHS_WHI_REG450 <- mmds_FHS_WHI_REG450[,c(1:9,12:14)]
names(mmds_FHS_WHI_REG450) <- c("SNP", "CHR", "BP", "Coefficient FHS","SE FHS","Pvalue FHS","Coefficient WHI", "SE WHI", "Pvalue WHI",
                                 "Coefficient REG450", "SE REG450", "Pvalue REG450")

mmds_epic <- get(load("~/B64_DIAMETR/Scripts/REGICOR/sv/epic/mmds/bacon_noxy.RData"))

mmds_FHS_WHI_REG450_REGepic <- merge(mmds_FHS_WHI_REG450, mmds_epic, by="SNP",all.x = T) # only include 450k's cpgs
mmds_FHS_WHI_REG450_REGepic <- mmds_FHS_WHI_REG450_REGepic[,c(1:12,15:17)]
names(mmds_FHS_WHI_REG450_REGepic) <- c("SNP", "CHR", "BP", "Coefficient FHS","SE FHS","Pvalue FHS","Coefficient WHI", "SE WHI", "Pvalue WHI",
                                         "Coefficient REG450", "SE REG450", "Pvalue REG450","Coefficient REGepic", "SE REGepic", "Pvalue REGepic" )

mmds_airwave <- get(load("/home/jdominguez1/B64_DIAMETR/Scripts/Airwave/results_models_ICL/mmds/bacon_noxy.RData"))
mmds_whole <- merge(mmds_FHS_WHI_REG450_REGepic, mmds_airwave, by="SNP", all.x=T) # only include 450k's cpgs
mmds_whole <-mmds_whole[, c(1:15,18:20)]
names(mmds_whole) <- c("SNP", "CHR", "BP", "Coefficient FHS","SE FHS","Pvalue FHS","Coefficient WHI", "SE WHI", "Pvalue WHI",
                        "Coefficient REG450", "SE REG450", "Pvalue REG450","Coefficient REGepic", "SE REGepic", "Pvalue REGepic",
                        "Coefficient Airwave", "SE Airwave", "Pvalue Airwave")
###################
# DASHF
###################

dashf_FHS <- get(load("~/B64_DIAMETR/Scripts/FHS/sv/dashf/results_mixed/bacon_noxy.RData"))

dashf_WHI <- get(load("~/B64_DIAMETR/Scripts/WHI/sv/dashf/bacon_noxy.RData"))

dashf_450 <- get(load("~/B64_DIAMETR/Scripts/REGICOR/sv/450k/dashf/model_2sva_noxy_dashf.RData"))

dashf_FHS_WHI <- merge(dashf_FHS, dashf_WHI, by="SNP",all=T)
dashf_FHS_WHI <- dashf_FHS_WHI[,c(1:6,9:11)]
names(dashf_FHS_WHI) <- c("SNP", "CHR", "BP", "Coefficient FHS","SE FHS","Pvalue FHS","Coefficient WHI", "SE WHI", "Pvalue WHI")

dashf_FHS_WHI_REG450 <- merge(dashf_FHS_WHI, dashf_450, by="SNP",all=T)
dashf_FHS_WHI_REG450 <- dashf_FHS_WHI_REG450[,c(1:9,12:14)]
names(dashf_FHS_WHI_REG450) <- c("SNP", "CHR", "BP", "Coefficient FHS","SE FHS","Pvalue FHS","Coefficient WHI", "SE WHI", "Pvalue WHI",
                                "Coefficient REG450", "SE REG450", "Pvalue REG450")

dashf_epic <- get(load("~/B64_DIAMETR/Scripts/REGICOR/sv/epic/dashf/bacon_noxy.RData"))

dashf_FHS_WHI_REG450_REGepic <- merge(dashf_FHS_WHI_REG450, dashf_epic, by="SNP",all.x = T) # only include 450k's cpgs
dashf_FHS_WHI_REG450_REGepic <- dashf_FHS_WHI_REG450_REGepic[,c(1:12,15:17)]
names(dashf_FHS_WHI_REG450_REGepic) <- c("SNP", "CHR", "BP", "Coefficient FHS","SE FHS","Pvalue FHS","Coefficient WHI", "SE WHI", "Pvalue WHI",
                       "Coefficient REG450", "SE REG450", "Pvalue REG450","Coefficient REGepic", "SE REGepic", "Pvalue REGepic" )

dashf_airwave <- get(load("/home/jdominguez1/B64_DIAMETR/Scripts/Airwave/results_models_ICL/dashf/bacon_noxy.RData"))
dashf_whole <- merge(dashf_FHS_WHI_REG450_REGepic, dashf_airwave, by="SNP", all.x=T) # only include 450k's cpgs
dashf_whole <-dashf_whole[, c(1:15,18:20)]
names(dashf_whole) <- c("SNP", "CHR", "BP", "Coefficient FHS","SE FHS","Pvalue FHS","Coefficient WHI", "SE WHI", "Pvalue WHI",
                                         "Coefficient REG450", "SE REG450", "Pvalue REG450","Coefficient REGepic", "SE REGepic", "Pvalue REGepic",
                                         "Coefficient Airwave", "SE Airwave", "Pvalue Airwave")
###################
# HPDI
###################

hpdi_FHS <- get(load("~/B64_DIAMETR/Scripts/FHS/sv/hpdi/results_mixed/bacon_noxy.RData"))

hpdi_WHI <- get(load("~/B64_DIAMETR/Scripts/WHI/sv/hpdi/bacon_noxy.RData"))

hpdi_450 <- get(load("~/B64_DIAMETR/Scripts/REGICOR/sv/450k/hpdi/model_2sva_noxy_hpdi.RData"))

hpdi_FHS_WHI <- merge(hpdi_FHS, hpdi_WHI, by="SNP",all=T)
hpdi_FHS_WHI <- hpdi_FHS_WHI[,c(1:6,9:11)]
names(hpdi_FHS_WHI) <- c("SNP", "CHR", "BP", "Coefficient FHS","SE FHS","Pvalue FHS","Coefficient WHI", "SE WHI", "Pvalue WHI")

hpdi_FHS_WHI_REG450 <- merge(hpdi_FHS_WHI, hpdi_450, by="SNP",all=T)
hpdi_FHS_WHI_REG450 <- hpdi_FHS_WHI_REG450[,c(1:9,12:14)]
names(hpdi_FHS_WHI_REG450) <- c("SNP", "CHR", "BP", "Coefficient FHS","SE FHS","Pvalue FHS","Coefficient WHI", "SE WHI", "Pvalue WHI",
                                 "Coefficient REG450", "SE REG450", "Pvalue REG450")

hpdi_epic <- get(load("~/B64_DIAMETR/Scripts/REGICOR/sv/epic/hpdi/bacon_noxy.RData"))

hpdi_FHS_WHI_REG450_REGepic <- merge(hpdi_FHS_WHI_REG450, hpdi_epic, by="SNP",all.x = T) # only include 450k's cpgs
hpdi_FHS_WHI_REG450_REGepic <- hpdi_FHS_WHI_REG450_REGepic[,c(1:12,15:17)]
names(hpdi_FHS_WHI_REG450_REGepic) <- c("SNP", "CHR", "BP", "Coefficient FHS","SE FHS","Pvalue FHS","Coefficient WHI", "SE WHI", "Pvalue WHI",
                                         "Coefficient REG450", "SE REG450", "Pvalue REG450","Coefficient REGepic", "SE REGepic", "Pvalue REGepic" )

hpdi_airwave <- get(load("/home/jdominguez1/B64_DIAMETR/Scripts/Airwave/results_models_ICL/hpdi/bacon_noxy.RData"))
hpdi_whole <- merge(hpdi_FHS_WHI_REG450_REGepic, hpdi_airwave, by="SNP", all.x=T) # only include 450k's cpgs
hpdi_whole <-hpdi_whole[, c(1:15,18:20)]
names(hpdi_whole) <- c("SNP", "CHR", "BP", "Coefficient FHS","SE FHS","Pvalue FHS","Coefficient WHI", "SE WHI", "Pvalue WHI",
                        "Coefficient REG450", "SE REG450", "Pvalue REG450","Coefficient REGepic", "SE REGepic", "Pvalue REGepic",
                        "Coefficient Airwave", "SE Airwave", "Pvalue Airwave")

#################################################################################################


#################################################################################################
#### Adjust for multiple comparisons (FDR)
#################################################################################################

# hpdi_whole$`Q FHS` <- p.adjust(hpdi_whole$`Pvalue FHS`, method = "fdr")
# hpdi_whole$`Q WHI` <- p.adjust(hpdi_whole$`Pvalue WHI`, method = "fdr")
# hpdi_whole$`Q REG450` <- p.adjust(hpdi_whole$`Pvalue REG450`, method = "fdr")
# hpdi_whole$`Q REGepic` <- p.adjust(hpdi_whole$`Pvalue REGepic`, method = "fdr")
# 
# dashf_whole$`Q FHS` <- p.adjust(dashf_whole$`Pvalue FHS`, method = "fdr")
# dashf_whole$`Q WHI` <- p.adjust(dashf_whole$`Pvalue WHI`, method = "fdr")
# dashf_whole$`Q REG450` <- p.adjust(dashf_whole$`Pvalue REG450`, method = "fdr")
# dashf_whole$`Q REGepic` <- p.adjust(dashf_whole$`Pvalue REGepic`, method = "fdr")
# 
# mds_whole$`Q FHS` <- p.adjust(mds_whole$`Pvalue FHS`, method = "fdr")
# mds_whole$`Q WHI` <- p.adjust(mds_whole$`Pvalue WHI`, method = "fdr")
# mds_whole$`Q REG450` <- p.adjust(mds_whole$`Pvalue REG450`, method = "fdr")
# mds_whole$`Q REGepic` <- p.adjust(mds_whole$`Pvalue REGepic`, method = "fdr")
# 
# 
# mmds_whole$`Q FHS` <- p.adjust(mmds_whole$`Pvalue FHS`, method = "fdr")
# mmds_whole$`Q WHI` <- p.adjust(mmds_whole$`Pvalue WHI`, method = "fdr")
# mmds_whole$`Q REG450` <- p.adjust(mmds_whole$`Pvalue REG450`, method = "fdr")
# mmds_whole$`Q REGepic` <- p.adjust(mmds_whole$`Pvalue REGepic`, method = "fdr")
# 
# rmed_whole$`Q FHS` <- p.adjust(rmed_whole$`Pvalue FHS`, method = "fdr")
# rmed_whole$`Q WHI` <- p.adjust(rmed_whole$`Pvalue WHI`, method = "fdr")
# rmed_whole$`Q REG450` <- p.adjust(rmed_whole$`Pvalue REG450`, method = "fdr")
# rmed_whole$`Q REGepic` <- p.adjust(rmed_whole$`Pvalue REGepic`, method = "fdr")

#################################################################################################
#### Save
#################################################################################################

save(hpdi_whole, file="~/B64_DIAMETR/Scripts/Meta_Airwave_ICL//hpdi/model_whole.RData")
save(mmds_whole, file="~/B64_DIAMETR/Scripts/Meta_Airwave_ICL//mmds/model_whole.RData")
save(dashf_whole, file="~/B64_DIAMETR/Scripts/Meta_Airwave_ICL//dashf/model_whole.RData")

#################################################################################################
#### GET THOS WITH PVALUE AT LEAST <= 10e-5
#################################################################################################

hpdi_whole$keepfdr <- with(hpdi_whole, ifelse((`Q WHI`<=0.05 | `Q FHS`<=0.05 | `Q REG450`<=0.05 | `Q REGepic`<=0.05), 1,0))
rmed_whole$keepfdr <- with(rmed_whole, ifelse((`Q WHI`<=0.05 | `Q FHS`<=0.05 | `Q REG450`<=0.05 | `Q REGepic`<=0.05), 1,0))
mds_whole$keepfdr <- with(mds_whole, ifelse((`Q WHI`<=0.05 | `Q FHS`<=0.05 | `Q REG450`<=0.05 | `Q REGepic`<=0.05), 1,0))
mmds_whole$keepfdr <- with(mmds_whole, ifelse((`Q WHI`<=0.05 | `Q FHS`<=0.05 | `Q REG450`<=0.05 | `Q REGepic`<=0.05), 1,0))
dashf_whole$keepfdr <- with(dashf_whole, ifelse((`Q WHI`<=0.05 | `Q FHS`<=0.05 | `Q REG450`<=0.05 | `Q REGepic`<=0.05), 1,0))

hpdi_whole$keeppval <- with(hpdi_whole, ifelse((`Pvalue WHI`<=0.00001 | `Pvalue FHS`<=0.00001 | `Pvalue REG450`<=0.00001 | `Pvalue REGepic`<=0.00001), 1,0))
rmed_whole$keeppval <- with(rmed_whole, ifelse((`Pvalue WHI`<=0.00001 | `Pvalue FHS`<=0.00001 | `Pvalue REG450`<=0.00001 | `Pvalue REGepic`<=0.00001), 1,0))
mds_whole$keeppval <- with(mds_whole, ifelse((`Pvalue WHI`<=0.00001 | `Pvalue FHS`<=0.00001 | `Pvalue REG450`<=0.00001 | `Pvalue REGepic`<=0.00001), 1,0))
mmds_whole$keeppval <- with(mmds_whole, ifelse((`Pvalue WHI`<=0.00001 | `Pvalue FHS`<=0.00001 | `Pvalue REG450`<=0.00001 | `Pvalue REGepic`<=0.00001), 1,0))
dashf_whole$keeppval <- with(dashf_whole, ifelse((`Pvalue WHI`<=0.00001 | `Pvalue FHS`<=0.00001 | `Pvalue REG450`<=0.00001 | `Pvalue REGepic`<=0.00001), 1,0))

hpdi_whole_sig_fdr <- subset(hpdi_whole, keepfdr==1)
rmed_whole_sig_fdr <- subset(rmed_whole, keepfdr==1)
mds_whole_sig_fdr <- subset(mds_whole, keepfdr==1)
mmds_whole_sig_fdr <- subset(mmds_whole, keepfdr==1)
dashf_whole_sig_fdr <- subset(dashf_whole, keepfdr==1)

hpdi_whole_sig_pval <- subset(hpdi_whole, keeppval==1)
rmed_whole_sig_pval <- subset(rmed_whole, keeppval==1)
mds_whole_sig_pval <- subset(mds_whole, keeppval==1)
mmds_whole_sig_pval <- subset(mmds_whole, keeppval==1)
dashf_whole_sig_pval <- subset(dashf_whole, keeppval==1)


#################################################################################################

save(hpdi_whole_sig_fdr, file="~/B64_DIAMETR/Scripts/Meta/hpdi/fdr/model_sig_fdr.RData")
save(rmed_whole_sig_fdr, file="~/B64_DIAMETR/Scripts/Meta/rmed/fdr/model_sig_fdr.RData")
save(mds_whole_sig_fdr, file="~/B64_DIAMETR/Scripts/Meta/mds/fdr/model_sig_fdr.RData")
save(mmds_whole_sig_fdr, file="~/B64_DIAMETR/Scripts/Meta/mmds/fdr/model_sig_fdr.RData")
save(dashf_whole_sig_fdr, file="~/B64_DIAMETR/Scripts/Meta/dashf/fdr/model_sig_fdr.RData")

save(hpdi_whole_sig_pval, file="~/B64_DIAMETR/Scripts/Meta/hpdi/no_fdr/model_sig_pval.RData")
save(rmed_whole_sig_pval, file="~/B64_DIAMETR/Scripts/Meta/rmed/no_fdr/model_sig_pval.RData")
save(mds_whole_sig_pval, file="~/B64_DIAMETR/Scripts/Meta/mds/no_fdr/model_sig_pval.RData")
save(mmds_whole_sig_pval, file="~/B64_DIAMETR/Scripts/Meta/mmds/no_fdr/model_sig_pval.RData")
save(dashf_whole_sig_pval, file="~/B64_DIAMETR/Scripts/Meta/dashf/no_fdr/model_sig_pval.RData")
