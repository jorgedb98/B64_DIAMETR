# Calculate attenuation coefficients

rm(list=ls())
setwd("/home/jdominguez1/B64_DIAMETR/Scripts/")
##########################################################################
#################                                        #################
#################       ANALSYSIS WITH ALL 5 COHORTS     #################
#################                                        #################
##########################################################################

########## ~~ dashf ~~ ##########

dashf_model1 <- get(load("./Meta_Airwave_ICL/dashf/metagen_whole_fdrSig.RData"))
dashf_model2 <- get(load("./Meta_bmi/dashf/metagen_dashf_whole.RData"))
names(dashf_model2)[1] <- "SNP"

attenuation_dashf <- merge(dashf_model1, dashf_model2, by="SNP")
attenuation_dashf <- attenuation_dashf[,c(1:6,8:10,12:13,30:37)]

names(attenuation_dashf) <- c("SNP", 
                              "CHR",
                              "BP",
                              "Random Coefficient M1",
                              "Random SE M1",
                              "Random Pvalue M1",
                              "Fixed Coefficient M1",
                              "Fixed SE M1",
                              "Fixed Pvalue M1",
                              "I2 M1",
                              "Pvalue Q M1",
                              "Random Coefficient M2",
                              "Random SE M2",
                              "Random Pvalue M2",
                              "Fixed Coefficient M2",
                              "Fixed SE M2",
                              "Fixed Pvalue M2",
                              "I2 M2",
                              "Pvalue Q M2")

attenuation_dashf <- attenuation_dashf %>% 
  mutate(`Attenuation Random` = 100*((`Random Coefficient M1` - `Random Coefficient M2`)/`Random Coefficient M1`)) %>%
  mutate(`Attenuation Fixed` = 100*((`Fixed Coefficient M1` - `Fixed Coefficient M2`)/`Fixed Coefficient M1`))

attenuation_dashf_sig <- attenuation_dashf[ attenuation_dashf$`Attenuation Fixed`<=10,]

save(attenuation_dashf, file="./Attenuation/dashf/dashf_attenuation_2.RData")
write.table(attenuation_dashf, file="./Attenuation/dashf/dashf_attenuation_2.csv", sep=",", col.names = T, row.names = F, quote = F)

save(attenuation_dashf_sig, file="./Attenuation/dashf/dashf_attenuation_2_sig.RData")
write.table(attenuation_dashf_sig, file="./Attenuation/dashf/dashf_attenuation_2_sig.csv", sep=",", col.names = T, row.names = F, quote = F)

########## ~~ hpdi ~~ ##########

hpdi_model1 <- get(load("./Meta_Airwave_ICL/hpdi/metagen_whole_fdrSig.RData"))
hpdi_model2 <- get(load("./Meta_bmi/hpdi/metagen_hpdi_whole.RData"))
names(hpdi_model2)[1] <- "SNP"

attenuation_hpdi <- merge(hpdi_model1, hpdi_model2, by="SNP")
attenuation_hpdi <- attenuation_hpdi[,c(1:6,8:10,12:13,30:37)]

names(attenuation_hpdi) <- c("SNP", 
                              "CHR",
                              "BP",
                              "Random Coefficient M1",
                              "Random SE M1",
                              "Random Pvalue M1",
                              "Fixed Coefficient M1",
                              "Fixed SE M1",
                              "Fixed Pvalue M1",
                              "I2 M1",
                              "Pvalue Q M1",
                              "Random Coefficient M2",
                              "Random SE M2",
                              "Random Pvalue M2",
                              "Fixed Coefficient M2",
                              "Fixed SE M2",
                              "Fixed Pvalue M2",
                              "I2 M2",
                              "Pvalue Q M2")

attenuation_hpdi <- attenuation_hpdi %>% 
  mutate(`Attenuation Random` = 100*((`Random Coefficient M1` - `Random Coefficient M2`)/`Random Coefficient M1`)) %>%
  mutate(`Attenuation Fixed` = 100*((`Fixed Coefficient M1` - `Fixed Coefficient M2`)/`Fixed Coefficient M1`))

attenuation_hpdi_sig <- attenuation_hpdi[attenuation_hpdi$`Attenuation Fixed`<=10,]


save(attenuation_hpdi, file="./Attenuation/hpdi/hpdi_attenuation_2.RData")
write.table(attenuation_hpdi, file="./Attenuation/hpdi/hpdi_attenuation_2.csv", sep=",", col.names = T, row.names = F, quote = F)

save(attenuation_hpdi_sig, file="./Attenuation/hpdi/hpdi_attenuation_2_sig.RData")
write.table(attenuation_hpdi_sig, file="./Attenuation/hpdi/hpdi_attenuation_2_sig.csv", sep=",", col.names = T, row.names = F, quote = F)

########## ~~ mmds ~~ ##########

mmds_model1 <- get(load("./Meta_Airwave_ICL/mmds/metagen_whole_fdrSig.RData"))
mmds_model2 <- get(load("./Meta_bmi/mmds/metagen_mmds_whole.RData"))
names(mmds_model2)[1] <- "SNP"

attenuation_mmds <- merge(mmds_model1, mmds_model2, by="SNP")
attenuation_mmds <- attenuation_mmds[,c(1:6,8:10,12:13,30:37)]

names(attenuation_mmds) <- c("SNP", 
                             "CHR",
                             "BP",
                             "Random Coefficient M1",
                             "Random SE M1",
                             "Random Pvalue M1",
                             "Fixed Coefficient M1",
                             "Fixed SE M1",
                             "Fixed Pvalue M1",
                             "I2 M1",
                             "Pvalue Q M1",
                             "Random Coefficient M2",
                             "Random SE M2",
                             "Random Pvalue M2",
                             "Fixed Coefficient M2",
                             "Fixed SE M2",
                             "Fixed Pvalue M2",
                             "I2 M2",
                             "Pvalue Q M2")

attenuation_mmds <- attenuation_mmds %>% 
  mutate(`Attenuation Random` = 100*((`Random Coefficient M1` - `Random Coefficient M2`)/`Random Coefficient M1`)) %>%
  mutate(`Attenuation Fixed` = 100*((`Fixed Coefficient M1` - `Fixed Coefficient M2`)/`Fixed Coefficient M1`))

attenuation_mmds_sig <- attenuation_mmds[attenuation_mmds$`Attenuation Fixed`<=10,] # Not including <0 Attenuation because
                                                                                    # negative A means higher magnitude of B
                                                                                    # in model 2.


save(attenuation_mmds, file="./Attenuation/mmds/mmds_attenuation_2.RData")
write.table(attenuation_mmds, file="./Attenuation/mmds/mmds_attenuation_2.csv", sep=",", col.names = T, row.names = F, quote = F)

save(attenuation_mmds_sig, file="./Attenuation/mmds/mmds_attenuation_2_sig.RData")
write.table(attenuation_mmds_sig, file="./Attenuation/mmds/mmds_attenuation_2_sig.csv", sep=",", col.names = T, row.names = F, quote = F)

# attenuation_dashf_clean <- attenuation_dashf[,c(1,8:10,17:19,23)]
attenuation_dashf_sig$`Diet` <- "DASHF"
attenuation_dashf$`Diet` <- "DASHF"
# attenuation_hpdi_clean <- attenuation_hpdi[,c(1,8:10,17:19,23)]
attenuation_hpdi_sig$`Diet` <- "HPDI"
attenuation_hpdi$`Diet` <- "HPDI"
# attenuation_mmds_clean <- attenuation_mmds[,c(1,8:10,17:19,23)]
attenuation_mmds_sig$`Diet` <- "MMDS"
attenuation_mmds$`Diet` <- "MMDS"

all_attenuation<- rbind(attenuation_dashf, attenuation_hpdi)
all_attenuation <- rbind(all_attenuation, attenuation_mmds)
all_attenuation$het <- with(all_attenuation, ifelse(`I2 M1`>0.5 & `Pvalue Q M1`<0.05 & `Random Pvalue M1`>0.00001, 0, 1))
all_attenuation_clean<- all_attenuation[all_attenuation$het==1,c(1:22)]


save(all_attenuation_clean, file="Attenuation/tabla3_2.RData")
write.table(all_attenuation_clean, file="Attenuation/tabla3_2.csv", quote = F, col.names = T, row.names = F, sep=",")


all_attenuation_sig <- rbind(attenuation_dashf_sig, attenuation_hpdi_sig)
all_attenuation_sig <- rbind(all_attenuation_sig, attenuation_mmds_sig)
all_attenuation_sig$het <- with(all_attenuation_sig, ifelse(`I2 M1`>0.5 & `Pvalue Q M1`<0.05 & `Random Pvalue M1`>0.00001, 0, 1))
all_attenuation_sig_clean<- all_attenuation_sig[all_attenuation_sig$het==1,c(1:22)]
length(unique(all_attenuation_sig_clean$SNP)) # 70

save(all_attenuation_sig_clean, file="Attenuation/tabla3_2_sig.RData")
write.table(all_attenuation_sig_clean, file="Attenuation/tabla3_2_sig.csv", quote = F, col.names = T, row.names = F, sep=",")

## Load significant bonferroni to check
bonferroni <- get(load("/home/jdominguez1/B64_DIAMETR/Scripts/Meta_Airwave_ICL/table_2/tabla_2_bonferroni.RData"))
attenuation_bonfe <- all_attenuation_sig_clean[all_attenuation_sig_clean$SNP%in%all_cpgs_clean_bonferroni$SNP,]
save(attenuation_bonfe, file="Attenuation/tabla_bonfe.RData")
write.table(attenuation_bonfe, file="Attenuation/tabla_bonfe.csv", quote = F, col.names = T, row.names = F, sep=",")

sort(unique(attenuation_bonfe$SNP)) # "cg00711496" "cg02079413" "cg02650017" "cg13518625" "cg18181703" "cg23900905"
