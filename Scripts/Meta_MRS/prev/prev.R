###################################
#### Intercepting the CpG common
###################################

# no data from bacon, very little number of CpGs

rm(list = ls())

###################
# MMDS
###################

mmds_FHS <- get(load("~/B64_DIAMETR/Scripts/FHS/sv_cpgs_bmi_MRS/mmds/model_mmds_cpgs_bmi_mrs.RData"))
mmds_WHI <- get(load("~/B64_DIAMETR/Scripts/WHI/sv_cpgs_bmi_MRS/mmds/model_mmds_cpgs_bmi_mrs.RData"))
mmds_450 <- get(load("~/B64_DIAMETR/Scripts/REGICOR/sv_cpgs_bmi_MRS/450k/mmds/model_mmds_cpgs_bmi_MRS.RData"))
mmds_epic <- get(load("~/B64_DIAMETR/Scripts/REGICOR/sv_cpgs_bmi_MRS/epic/mmds/model_mmds_cpgs_bmi_MRS.RData"))
mmds_airwave <- get(load("/home/jdominguez1/B64_DIAMETR/Scripts/Airwave/results_models_MRS/dashf/model_dashf_mixed_MRS.RData"))

mmds_whole <- t(as.data.frame(c(mmds_FHS, mmds_WHI, mmds_450,mmds_epic, mmds_airwave)))
colnames(mmds_whole) <- c("Coefficient FHS","SE FHS","Pvalue FHS","Coefficient WHI", "SE WHI", "Pvalue WHI",
                       "Coefficient REG450", "SE REG450", "Pvalue REG450","Coefficient REGepic", "SE REGepic", "Pvalue REGepic",
                       "Coefficient Airwave", "SE Airwave", "Pvalue Airwave")
rownames(mmds_whole) <- "mmds_mrs"
###################
# DASHF
###################
dashf_FHS <- get(load("~/B64_DIAMETR/Scripts/FHS/sv_cpgs_bmi_MRS/dashf/model_dashf_cpgs_bmi_mrs.RData"))
dashf_WHI <- get(load("~/B64_DIAMETR/Scripts/WHI/sv_cpgs_bmi_MRS/dashf/model_dashf_cpgs_bmi_mrs.RData"))
dashf_450 <- get(load("~/B64_DIAMETR/Scripts/REGICOR/sv_cpgs_bmi_MRS/450k/dashf/model_dashf_cpgs_bmi_MRS.RData"))
dashf_epic <- get(load("~/B64_DIAMETR/Scripts/REGICOR/sv_cpgs_bmi_MRS/epic/dashf/model_dashf_cpgs_bmi_MRS.RData"))
dashf_airwave <- get(load("/home/jdominguez1/B64_DIAMETR/Scripts/Airwave/results_models_MRS/dashf/model_dashf_mixed_MRS.RData"))

dashf_whole <- t(as.data.frame(c(dashf_FHS, dashf_WHI, dashf_450,dashf_epic, dashf_airwave)))
colnames(dashf_whole) <- c("Coefficient FHS","SE FHS","Pvalue FHS","Coefficient WHI", "SE WHI", "Pvalue WHI",
                          "Coefficient REG450", "SE REG450", "Pvalue REG450","Coefficient REGepic", "SE REGepic", "Pvalue REGepic",
                          "Coefficient Airwave", "SE Airwave", "Pvalue Airwave")
rownames(dashf_whole) <- "dashf_mrs"
###################
# HPDI
###################
hpdi_FHS <- get(load("~/B64_DIAMETR/Scripts/FHS/sv_cpgs_bmi_MRS/hpdi/model_hpdi_cpgs_bmi_mrs.RData"))
hpdi_WHI <- get(load("~/B64_DIAMETR/Scripts/WHI/sv_cpgs_bmi_MRS/hpdi/model_hpdi_cpgs_bmi_mrs.RData"))
hpdi_450 <- get(load("~/B64_DIAMETR/Scripts/REGICOR/sv_cpgs_bmi_MRS/450k/hpdi/model_hpdi_cpgs_bmi_MRS.RData"))
hpdi_epic <- get(load("~/B64_DIAMETR/Scripts/REGICOR/sv_cpgs_bmi_MRS/epic/hpdi/model_hpdi_cpgs_bmi_MRS.RData"))
hpdi_airwave <- get(load("/home/jdominguez1/B64_DIAMETR/Scripts/Airwave/results_models_MRS/dashf/model_dashf_mixed_MRS.RData"))

hpdi_whole <- t(as.data.frame(c(hpdi_FHS, hpdi_WHI, hpdi_450,hpdi_epic, hpdi_airwave)))
colnames(hpdi_whole) <- c("Coefficient FHS","SE FHS","Pvalue FHS","Coefficient WHI", "SE WHI", "Pvalue WHI",
                          "Coefficient REG450", "SE REG450", "Pvalue REG450","Coefficient REGepic", "SE REGepic", "Pvalue REGepic",
                          "Coefficient Airwave", "SE Airwave", "Pvalue Airwave")
rownames(hpdi_whole) <- "hpdi_mrs"

#################################################################################################



#################################################################################################
#### Save
#################################################################################################

save(hpdi_whole, file="~/B64_DIAMETR/Scripts/Meta_MRS/hpdi/model_whole.RData")
save(mmds_whole, file="~/B64_DIAMETR/Scripts/Meta_MRS/mmds/model_whole.RData")
save(dashf_whole, file="~/B64_DIAMETR/Scripts/Meta_MRS/dashf/model_whole.RData")

