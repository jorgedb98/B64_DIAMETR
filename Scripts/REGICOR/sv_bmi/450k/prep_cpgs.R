# Script to get common cpgs with FHS M values and meta-analysis from 5 cohorts
rm(list=ls())
mt <- get(load("/home/jdominguez1/meth/mt_regicor_450.RData"))
all_cpgs <- colnames(mt)

####
# DASHF
####

dashf <- get(load("/home/jdominguez1/B64_DIAMETR/Scripts/Meta_Airwave_ICL/dashf/metagen_whole_fdrSig_ICL.RData"))
dashf_cpgs <- dashf$SNP

common_dashf <- unique(all_cpgs[all_cpgs%in%dashf_cpgs])
mvalues_sd_dashf <- mt[,common_dashf]
save(mvalues_sd_dashf, file="/home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv_bmi_pa_airwave/450k/dashf/mvalues_sd_dashf.RData")

####
# HPDI
####

hpdi <- get(load("/home/jdominguez1/B64_DIAMETR/Scripts/Meta_Airwave_ICL/hpdi/metagen_whole_fdrSig.RData"))
hpdi_cpgs <- hpdi$SNP

common_hpdi <- unique(all_cpgs[all_cpgs%in%hpdi_cpgs])
mvalues_sd_hpdi <- mt[,common_hpdi]
save(mvalues_sd_hpdi, file="/home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv_bmi_pa_airwave/450k/hpdi/mvalues_sd_hpdi.RData")

####
# MMDS
####

mmds <- get(load("/home/jdominguez1/B64_DIAMETR/Scripts/Meta_Airwave_ICL/mmds/metagen_whole_fdrSig.RData"))
mmds_cpgs <- mmds$SNP

common_mmds <- unique(all_cpgs[all_cpgs%in%mmds_cpgs])
mvalues_sd_mmds <- mt[,common_mmds]
save(mvalues_sd_mmds, file="/home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv_bmi_pa_airwave/450k/mmds/mvalues_sd_mmds.RData")

