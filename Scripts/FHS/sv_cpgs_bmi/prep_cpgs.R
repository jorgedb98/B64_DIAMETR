# Script to get common cpgs with FHS M values and meta-analysis from 5 cohorts
rm(list=ls())
FHS <- get(load("/home/jdominguez1/meth/mt_value_n_no_extrem_value_analysis.RData"))
all_cpgs <- colnames(FHS)

####
# DASHF
####

dashf <- get(load("/home/jdominguez1/B64_DIAMETR/Scripts/Meta_Airwave_ICL/dashf/metagen_whole_fdrSig_ICL.RData"))
dashf_cpgs <- dashf$SNP

common_dashf <- unique(all_cpgs[all_cpgs%in%dashf_cpgs])
mvalues_sd_dashf <- FHS[,common_dashf]
save(mvalues_sd_dashf, file="/home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv_bmi_pa_airwave/dashf/mvalues_sd_dashf.RData")

####
# HPDI
####

hpdi <- get(load("/home/jdominguez1/B64_DIAMETR/Scripts/Meta_Airwave_ICL/hpdi/metagen_whole_fdrSig.RData"))
hpdi_cpgs <- hpdi$SNP

common_hpdi <- unique(all_cpgs[all_cpgs%in%hpdi_cpgs])
mvalues_sd_hpdi <- FHS[,common_hpdi]
save(mvalues_sd_hpdi, file="/home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv_bmi_pa_airwave/hpdi/mvalues_sd_hpdi.RData")

####
# MMDS
####

mmds <- get(load("/home/jdominguez1/B64_DIAMETR/Scripts/Meta_Airwave_ICL/mmds/metagen_whole_fdrSig.RData"))
mmds_cpgs <- mmds$SNP

common_mmds <- unique(all_cpgs[all_cpgs%in%mmds_cpgs])
mvalues_sd_mmds <- FHS[,common_mmds]
save(mvalues_sd_mmds, file="/home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv_bmi_pa_airwave/mmds/mvalues_sd_mmds.RData")

