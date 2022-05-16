# Methylation risk score 

library(data.table)
library(purrr)
library(tidyverse)
library(tibble)

rm(list=ls())
setwd("/home/jdominguez1/B64_DIAMETR/Scripts/")

# DASHF #
dashf <- get(load("./Meta_Airwave_ICL/dashf/metagen_whole_fdrSig.RData"))
dashf <- dashf[,c(1,8)]
dashf <- dashf %>% remove_rownames %>% column_to_rownames(var="SNP")
dashf_t <- t(dashf)



# HPDI #
hpdi <- get(load("./Meta_Airwave_ICL/hpdi/metagen_whole_fdrSig.RData"))
hpdi <- hpdi[,c(1,8)]
hpdi <- hpdi %>% remove_rownames %>% column_to_rownames(var="SNP")
hpdi_t <- t(hpdi)
# MMDS #
mmds <- get(load("./Meta_Airwave_ICL/mmds/metagen_whole_fdrSig.RData"))
mmds <- mmds[,c(1,8)]
mmds <- mmds %>% remove_rownames %>% column_to_rownames(var="SNP")
mmds_t <- t(mmds)

##### WHI ####
pheno_whi <- get(load("../Dades/WHI/phenofood_whi22022022.RData"))

mv_values_dashf_whi <- get(load("./WHI/sv_bmi_pa_et/dashf/mvalues_sd_dashf.RData"))
dashf_whi <- t(as.matrix(dashf_t[,colnames(dashf_t)%in%colnames(mv_values_dashf_whi)]))

for(i in 1:nrow(mvalues_sd_dashf)){
  mv_values_dashf_whi[i,]<-mvalues_sd_dashf[i,]*dashf_whi
}

mv_values_dashf_whi$dashf_mrs <- rowSums(mv_values_dashf_whi, na.rm = T)
mv_values_dashf_whi$Slide <- row.names(mv_values_dashf_whi)
MRS_whi_dashf <- mv_values_dashf_whi[,c(104:105)]

### 

mv_values_hpdi_whi <- get(load("./WHI/sv_bmi_pa_et/hpdi/mvalues_sd_hpdi.RData"))
hpdi_whi <- t(as.matrix(hpdi_t[,colnames(hpdi_t)%in%colnames(mv_values_hpdi_whi)]))

for(i in 1:nrow(mvalues_sd_hpdi)){
  mv_values_hpdi_whi[i,]<-mvalues_sd_hpdi[i,]*hpdi_whi
}

mv_values_hpdi_whi$hpdi_mrs <- rowSums(mv_values_hpdi_whi, na.rm = T)
mv_values_hpdi_whi$Slide <- row.names(mv_values_hpdi_whi)
MRS_whi_hpdi <- mv_values_hpdi_whi[,c(46,47)]

###

mv_values_mmds_whi <- get(load("./WHI/sv_bmi_pa_et/mmds/mvalues_sd_mmds.RData"))
mmds_whi <- t(as.matrix(mmds_t[,colnames(mmds_t)%in%colnames(mv_values_mmds_whi)]))

for(i in 1:nrow(mvalues_sd_mmds)){
  mv_values_mmds_whi[i,]<-mvalues_sd_mmds[i,]*mmds_whi
}

mv_values_mmds_whi$mmds_mrs <- rowSums(mv_values_mmds_whi, na.rm = T)
mv_values_mmds_whi$Slide <- row.names(mv_values_mmds_whi)
MRS_whi_mmds <- mv_values_mmds_whi[,c(54,55)]

## Merge three scores diet for WHI by Slide
MRS_whi_dashf_hpdi <- merge(MRS_whi_dashf, MRS_whi_hpdi, by="Slide")
MRS_whi_all <- merge(MRS_whi_dashf_hpdi, MRS_whi_mmds, by="Slide")

pheno_whi_2 <- merge(pheno_whi, MRS_whi_all, by="Slide")
save(pheno_whi_2, file="/home/jdominguez1/B64_DIAMETR/Dades/WHI/phenofood_whi05052022.RData")


##### FHS ####
rm(list=setdiff(ls(),c("dashf_t","hpdi_t","mmds_t")))
pheno_fhs <- get(load("../Dades/FHS/phenofood_fhs_23022022.RData"))


mv_values_dashf_fhs <- get(load("./FHS/sv_bmi_pa_et/dashf/mvalues_sd_dashf.RData"))
dashf_fhs <- t(as.matrix(dashf_t[,colnames(dashf_t)%in%colnames(mv_values_dashf_fhs)]))

for(i in 1:nrow(mv_values_dashf_fhs)){
  mv_values_dashf_fhs[i,]<-mv_values_dashf_fhs[i,]*dashf_fhs
}

mv_values_dashf_fhs$dashf_mrs <- rowSums(mv_values_dashf_fhs, na.rm = T)
mv_values_dashf_fhs$Slide <- row.names(mv_values_dashf_fhs)
MRS_fhs_dashf <- mv_values_dashf_fhs[,c(104,105)]

##

mv_values_hpdi_fhs <- get(load("./FHS/sv_bmi_pa_et/hpdi/mvalues_sd_hpdi.RData"))
hpdi_fhs <- t(as.matrix(hpdi_t[,colnames(hpdi_t)%in%colnames(mv_values_hpdi_fhs)]))

for(i in 1:nrow(mv_values_hpdi_fhs)){
  mv_values_hpdi_fhs[i,]<-mv_values_hpdi_fhs[i,]*hpdi_fhs
}

mv_values_hpdi_fhs$hpdi_mrs <- rowSums(mv_values_hpdi_fhs, na.rm = T)
mv_values_hpdi_fhs$Slide <- row.names(mv_values_hpdi_fhs)
MRS_fhs_hpdi <- mv_values_hpdi_fhs[,c(46,47)]

##

mv_values_mmds_fhs <- get(load("./FHS/sv_bmi_pa_et/mmds/mvalues_sd_mmds.RData"))
mmds_fhs <- t(as.matrix(mmds_t[,colnames(mmds_t)%in%colnames(mv_values_mmds_fhs)]))

for(i in 1:nrow(mv_values_mmds_fhs)){
  mv_values_mmds_fhs[i,]<-mv_values_mmds_fhs[i,]*mmds_fhs
}

mv_values_mmds_fhs$mmds_mrs <- rowSums(mv_values_mmds_fhs, na.rm = T)
mv_values_mmds_fhs$Slide <- row.names(mv_values_mmds_fhs)
MRS_fhs_mmds <- mv_values_mmds_fhs[,c(54,55)]


## Merge three scores diet for FHS by Slide
MRS_fhs_dashf_hpdi <- merge(MRS_fhs_dashf, MRS_fhs_hpdi, by="Slide")
MRS_fhs_all <- merge(MRS_fhs_dashf_hpdi, MRS_fhs_mmds, by="Slide")

pheno_fhs_2 <- merge(pheno_fhs, MRS_fhs_all, by="Slide")
save(pheno_fhs_2, file="/home/jdominguez1/B64_DIAMETR/Dades/FHS/phenofood_fhs_05052022.RData")


##### REG 450k ####
rm(list=setdiff(ls(),c("dashf_t","hpdi_t","mmds_t")))
reg450 <- get(load("../Dades/REGICOR/metildiet_with_cells_and_rightVars_450.RData"))


mv_values_dashf_reg450 <- get(load("./REGICOR/sv_bmi_pa_et/450k/dashf/mvalues_sd_dashf.RData"))
dashf_reg450 <- t(as.matrix(dashf_t[,colnames(dashf_t)%in%colnames(mv_values_dashf_reg450)]))

for(i in 1:nrow(mv_values_dashf_reg450)){
  mv_values_dashf_reg450[i,]<-mv_values_dashf_reg450[i,]*dashf_reg450
}

mv_values_dashf_reg450$dashf_mrs <- rowSums(mv_values_dashf_reg450, na.rm = T)
mv_values_dashf_reg450$Slide <- row.names(mv_values_dashf_reg450)
MRS_reg450_dashf <- mv_values_dashf_reg450[,c(100,101)]

##

mv_values_hpdi_reg450 <- get(load("./REGICOR/sv_bmi_pa_et/450k/hpdi/mvalues_sd_hpdi.RData"))
hpdi_reg450 <- t(as.matrix(hpdi_t[,colnames(hpdi_t)%in%colnames(mv_values_hpdi_reg450)]))

for(i in 1:nrow(mv_values_hpdi_reg450)){
  mv_values_hpdi_reg450[i,]<-mv_values_hpdi_reg450[i,]*hpdi_reg450
}

mv_values_hpdi_reg450$hpdi_mrs <- rowSums(mv_values_hpdi_reg450, na.rm = T)
mv_values_hpdi_reg450$Slide <- row.names(mv_values_hpdi_reg450)
MRS_reg450_hpdi <- mv_values_hpdi_reg450[,c(43,44)]

##

mv_values_mmds_reg450 <- get(load("./REGICOR/sv_bmi_pa_et/450k/mmds/mvalues_sd_mmds.RData"))
mmds_reg450 <- t(as.matrix(mmds_t[,colnames(mmds_t)%in%colnames(mv_values_mmds_reg450)]))

for(i in 1:nrow(mv_values_mmds_reg450)){
  mv_values_mmds_reg450[i,]<-mv_values_mmds_reg450[i,]*mmds_reg450
}

mv_values_mmds_reg450$mmds_mrs <- rowSums(mv_values_mmds_reg450, na.rm = T)
mv_values_mmds_reg450$Slide <- row.names(mv_values_mmds_reg450)
MRS_reg450_mmds <- mv_values_mmds_reg450[,c(49,50)]

## Merge three scores diet for REGICOR 450k by Slide
MRS_reg450_dashf_hpdi <- merge(MRS_reg450_dashf, MRS_reg450_hpdi, by="Slide")
MRS_reg450_all <- merge(MRS_reg450_dashf_hpdi, MRS_reg450_mmds, by="Slide")
names(MRS_reg450_all)[1] <- "sample_name"

pheno_reg450_2 <- merge(reg450, MRS_reg450_all, by="sample_name")
save(pheno_reg450_2, file="/home/jdominguez1/B64_DIAMETR/Dades/REGICOR/metildiet_with_cells_and_rightVars_450_05052022.RData")


#### REG epic ####
rm(list=setdiff(ls(),c("dashf_t","hpdi_t","mmds_t")))
epic <- get(load("../Dades/REGICOR/metildiet_with_cells_and_rightVars_epic.RData"))

mv_values_dashf_epic <- get(load("./REGICOR/sv_bmi_pa_et/epic/dashf/mvalues_sd_dashf.RData"))
dashf_epic <- t(as.matrix(dashf_t[,colnames(dashf_t)%in%colnames(mv_values_dashf_epic)]))

for(i in 1:nrow(mv_values_dashf_epic)){
  mv_values_dashf_epic[i,]<-mv_values_dashf_epic[i,]*dashf_epic
}

mv_values_dashf_epic$dashf_mrs <- rowSums(mv_values_dashf_epic, na.rm = T)
mv_values_dashf_epic$Slide <- row.names(mv_values_dashf_epic)
MRS_epic_dashf <- mv_values_dashf_epic[,c(101,102)]

##

mv_values_hpdi_epic <- get(load("./REGICOR/sv_bmi_pa_et/epic/hpdi/mvalues_sd_hpdi.RData"))
hpdi_epic <- t(as.matrix(hpdi_t[,colnames(hpdi_t)%in%colnames(mv_values_hpdi_epic)]))

for(i in 1:nrow(mv_values_hpdi_epic)){
  mv_values_hpdi_epic[i,]<-mv_values_hpdi_epic[i,]*hpdi_epic
}

mv_values_hpdi_epic$hpdi_mrs <- rowSums(mv_values_hpdi_epic, na.rm = T)
mv_values_hpdi_epic$Slide <- row.names(mv_values_hpdi_epic)
MRS_epic_hpdi <- mv_values_hpdi_epic[,c(42,43)]


##

mv_values_mmds_epic <- get(load("./REGICOR/sv_bmi_pa_et/epic/mmds/mvalues_sd_mmds.RData"))
mmds_epic <- t(as.matrix(mmds_t[,colnames(mmds_t)%in%colnames(mv_values_mmds_epic)]))

for(i in 1:nrow(mv_values_mmds_epic)){
  mv_values_mmds_epic[i,]<-mv_values_mmds_epic[i,]*mmds_epic
}

mv_values_mmds_epic$mmds_mrs <- rowSums(mv_values_mmds_epic, na.rm = T)
mv_values_mmds_epic$Slide <- row.names(mv_values_mmds_epic)
MRS_epic_mmds <- mv_values_mmds_epic[,c(50,51)]

## Merge three scores diet for REGICOR epic by Slide
MRS_epic_dashf_hpdi <- merge(MRS_epic_dashf, MRS_epic_hpdi, by="Slide")
MRS_epic_all <- merge(MRS_epic_dashf_hpdi, MRS_epic_mmds, by="Slide")
names(MRS_epic_all)[1] <- "sample_name"

pheno_epic_2 <- merge(epic, MRS_epic_all, by="sample_name")
save(pheno_epic_2, file="/home/jdominguez1/B64_DIAMETR/Dades/REGICOR/metildiet_with_cells_and_rightVars_epic_05052022.RData")
