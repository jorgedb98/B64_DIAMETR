# Script to get common cpgs with M values and meta-analysis from 5 cohorts
rm(list=ls())
WHI <- get(load("/home/jdominguez1/meth/mvals_z_4sd.RData"))
all_cpgs <- colnames(WHI)

####
# DASHF
####

dashf <- get(load("/home/jdominguez1/B64_DIAMETR/Scripts/Meta_Airwave_ICL/dashf/metagen_whole_fdrSig_ICL.RData"))
dashf_cpgs <- dashf$SNP

common_dashf <- unique(all_cpgs[all_cpgs%in%dashf_cpgs])
mvalues_sd_dashf <- WHI[,common_dashf]
save(mvalues_sd_dashf, file="/home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv_bmi_pa_airwave/dashf/mvalues_sd_dashf.RData")

####
# HPDI
####

hpdi <- get(load("/home/jdominguez1/B64_DIAMETR/Scripts/Meta_Airwave_ICL/hpdi/metagen_whole_fdrSig.RData"))
hpdi_cpgs <- hpdi$SNP

common_hpdi <- unique(all_cpgs[all_cpgs%in%hpdi_cpgs])
mvalues_sd_hpdi <- WHI[,common_hpdi]
save(mvalues_sd_hpdi, file="/home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv_bmi_pa_airwave/hpdi/mvalues_sd_hpdi.RData")

####
# MMDS
####

mmds <- get(load("/home/jdominguez1/B64_DIAMETR/Scripts/Meta_Airwave_ICL/mmds/metagen_whole_fdrSig.RData"))
mmds_cpgs <- mmds$SNP

common_mmds <- unique(all_cpgs[all_cpgs%in%mmds_cpgs])
mvalues_sd_mmds <- WHI[,common_mmds]
save(mvalues_sd_mmds, file="/home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv_bmi_pa_airwave/mmds/mvalues_sd_mmds.RData")

