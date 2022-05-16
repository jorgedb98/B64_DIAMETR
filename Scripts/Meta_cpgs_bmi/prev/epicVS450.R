###################################
#### Intercepting the CpG common
###################################

# no data from bacon, very little number of CpGs

rm(list = ls())

###################
# MMDS
###################

mmds_FHS <- get(load("~/B64_DIAMETR/Scripts/FHS/sv_cpgs_bmi/mmds/bacon.RData"))
mmds_FHS <- mmds_FHS[,c(1,5:7)]
mmds_WHI <- get(load("~/B64_DIAMETR/Scripts/WHI/sv_cpgs_bmi/mmds/bacon.RData"))
mmds_WHI <- mmds_WHI[,c(1,5:7)]

mmds_450 <- get(load("~/B64_DIAMETR/Scripts/REGICOR/sv_cpgs_bmi//450k/mmds/model_mmds_cpgs_bmi.RData"))
names(mmds_450)[1] <- "cpg"

mmds_FHS_WHI <- merge(mmds_FHS, mmds_WHI, by="cpg",all=T)
names(mmds_FHS_WHI) <- c("cpg","Coefficient FHS","SE FHS","Pvalue FHS","Coefficient WHI", "SE WHI", "Pvalue WHI")

mmds_FHS_WHI_REG450 <- merge(mmds_FHS_WHI, mmds_450, by="cpg",all=T)
names(mmds_FHS_WHI_REG450) <- c("cpg","Coefficient FHS","SE FHS","Pvalue FHS","Coefficient WHI", "SE WHI", "Pvalue WHI",
                                "Coefficient REG450", "SE REG450", "Pvalue REG450")
mmds_epic <- get(load("~/B64_DIAMETR/Scripts/REGICOR/sv_cpgs_bmi/epic/mmds/bacon.RData"))
mmds_epic <- mmds_epic[,c(1,5:7)]

mmds_FHS_WHI_REG450_REGepic <- merge(mmds_FHS_WHI_REG450, mmds_epic, by="cpg",all.x = T) # only include 450k's cpgs
names(mmds_FHS_WHI_REG450_REGepic) <- c("cpg","Coefficient FHS","SE FHS","Pvalue FHS","Coefficient WHI", "SE WHI", "Pvalue WHI",
                                        "Coefficient REG450", "SE REG450", "Pvalue REG450","Coefficient REGepic", "SE REGepic", "Pvalue REGepic" )

mmds_airwave <- get(load("/home/jdominguez1/B64_DIAMETR/Scripts/Airwave/results_models_cpgs_bmi/mmds/bacon.RData"))
mmds_airwave <- mmds_airwave[,c(1,5:7)]
mmds_whole <- merge(mmds_FHS_WHI_REG450_REGepic, mmds_airwave, by="cpg", all.x=T) # only include 450k's cpgs
names(mmds_whole) <- c("cpg","Coefficient FHS","SE FHS","Pvalue FHS","Coefficient WHI", "SE WHI", "Pvalue WHI",
                       "Coefficient REG450", "SE REG450", "Pvalue REG450","Coefficient REGepic", "SE REGepic", "Pvalue REGepic",
                       "Coefficient Airwave", "SE Airwave", "Pvalue Airwave")
###################
# DASHF
###################
dashf_FHS <- get(load("~/B64_DIAMETR/Scripts/FHS/sv_cpgs_bmi/dashf/bacon.RData"))
dashf_FHS <- dashf_FHS[,c(1,5:7)]
dashf_WHI <- get(load("~/B64_DIAMETR/Scripts/WHI/sv_cpgs_bmi/dashf/bacon.RData"))
dashf_WHI <- dashf_WHI[,c(1,5:7)]

dashf_450 <- get(load("~/B64_DIAMETR/Scripts/REGICOR/sv_cpgs_bmi/450k/dashf/model_dashf_cpgs_bmi.RData"))
names(dashf_450)[1] <- "cpg"

dashf_FHS_WHI <- merge(dashf_FHS, dashf_WHI, by="cpg",all=T)
names(dashf_FHS_WHI) <- c("cpg","Coefficient FHS","SE FHS","Pvalue FHS","Coefficient WHI", "SE WHI", "Pvalue WHI")

dashf_FHS_WHI_REG450 <- merge(dashf_FHS_WHI, dashf_450, by="cpg",all=T)
names(dashf_FHS_WHI_REG450) <- c("cpg","Coefficient FHS","SE FHS","Pvalue FHS","Coefficient WHI", "SE WHI", "Pvalue WHI",
                                "Coefficient REG450", "SE REG450", "Pvalue REG450")
dashf_epic <- get(load("~/B64_DIAMETR/Scripts/REGICOR/sv_cpgs_bmi/epic/dashf/bacon.RData"))
dashf_epic <- dashf_epic[,c(1,5:7)]

dashf_FHS_WHI_REG450_REGepic <- merge(dashf_FHS_WHI_REG450, dashf_epic, by="cpg",all.x = T) # only include 450k's cpgs
names(dashf_FHS_WHI_REG450_REGepic) <- c("cpg","Coefficient FHS","SE FHS","Pvalue FHS","Coefficient WHI", "SE WHI", "Pvalue WHI",
                                        "Coefficient REG450", "SE REG450", "Pvalue REG450","Coefficient REGepic", "SE REGepic", "Pvalue REGepic" )

dashf_airwave <- get(load("/home/jdominguez1/B64_DIAMETR/Scripts/Airwave/results_models_cpgs_bmi/dashf/bacon.RData"))
dashf_airwave <- dashf_airwave[,c(1,5:7)]
dashf_whole <- merge(dashf_FHS_WHI_REG450_REGepic, dashf_airwave, by="cpg", all.x=T) # only include 450k's cpgs
names(dashf_whole) <- c("cpg","Coefficient FHS","SE FHS","Pvalue FHS","Coefficient WHI", "SE WHI", "Pvalue WHI",
                       "Coefficient REG450", "SE REG450", "Pvalue REG450","Coefficient REGepic", "SE REGepic", "Pvalue REGepic",
                       "Coefficient Airwave", "SE Airwave", "Pvalue Airwave")
###################
# HPDI
###################
hpdi_FHS <- get(load("~/B64_DIAMETR/Scripts/FHS/sv_cpgs_bmi/hpdi/bacon.RData"))
hpdi_FHS <- hpdi_FHS[,c(1,5:7)]
hpdi_WHI <- get(load("~/B64_DIAMETR/Scripts/WHI/sv_cpgs_bmi/hpdi/bacon.RData"))
hpdi_WHI <- hpdi_WHI[,c(1,5:7)]

hpdi_450 <- get(load("~/B64_DIAMETR/Scripts/REGICOR/sv_cpgs_bmi/450k/hpdi/model_hpdi_cpgs_bmi.RData"))
names(hpdi_450)[1] <- "cpg"

hpdi_FHS_WHI <- merge(hpdi_FHS, hpdi_WHI, by="cpg",all=T)
names(hpdi_FHS_WHI) <- c("cpg","Coefficient FHS","SE FHS","Pvalue FHS","Coefficient WHI", "SE WHI", "Pvalue WHI")

hpdi_FHS_WHI_REG450 <- merge(hpdi_FHS_WHI, hpdi_450, by="cpg",all=T)
names(hpdi_FHS_WHI_REG450) <- c("cpg","Coefficient FHS","SE FHS","Pvalue FHS","Coefficient WHI", "SE WHI", "Pvalue WHI",
                                "Coefficient REG450", "SE REG450", "Pvalue REG450")
hpdi_epic <- get(load("~/B64_DIAMETR/Scripts/REGICOR/sv_cpgs_bmi/epic/hpdi/bacon.RData"))
hpdi_epic <- hpdi_epic[,c(1,5:7)]

hpdi_FHS_WHI_REG450_REGepic <- merge(hpdi_FHS_WHI_REG450, hpdi_epic, by="cpg",all.x = T) # only include 450k's cpgs
names(hpdi_FHS_WHI_REG450_REGepic) <- c("cpg","Coefficient FHS","SE FHS","Pvalue FHS","Coefficient WHI", "SE WHI", "Pvalue WHI",
                                        "Coefficient REG450", "SE REG450", "Pvalue REG450","Coefficient REGepic", "SE REGepic", "Pvalue REGepic" )

hpdi_airwave <- get(load("/home/jdominguez1/B64_DIAMETR/Scripts/Airwave/results_models_cpgs_bmi/hpdi/bacon.RData"))
hpdi_airwave <- hpdi_airwave[,c(1,5:7)]
hpdi_whole <- merge(hpdi_FHS_WHI_REG450_REGepic, hpdi_airwave, by="cpg", all.x=T) # only include 450k's cpgs
names(hpdi_whole) <- c("cpg","Coefficient FHS","SE FHS","Pvalue FHS","Coefficient WHI", "SE WHI", "Pvalue WHI",
                       "Coefficient REG450", "SE REG450", "Pvalue REG450","Coefficient REGepic", "SE REGepic", "Pvalue REGepic",
                       "Coefficient Airwave", "SE Airwave", "Pvalue Airwave")

#################################################################################################



#################################################################################################
#### Save
#################################################################################################

save(hpdi_whole, file="~/B64_DIAMETR/Scripts/Meta_cpgs_bmi/hpdi/model_whole.RData")
save(mmds_whole, file="~/B64_DIAMETR/Scripts/Meta_cpgs_bmi/mmds/model_whole.RData")
save(dashf_whole, file="~/B64_DIAMETR/Scripts/Meta_cpgs_bmi/dashf/model_whole.RData")
