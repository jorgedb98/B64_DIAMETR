# Script for retreiving all CpGs from the 3 scores and rbind them for Table 2 of the paper

rm(list=ls())

library(dplyr)

setwd("/home/jdominguez1/B64_DIAMETR/Scripts/Meta_Airwave_ICL/")

dashf_cpgs <- get(load("dashf/metagen_whole_fdrSig.RData"))
dashf_cpgs$SCORE <- "DASHF"
hpdi_cpgs <- get(load("hpdi/metagen_whole_fdrSig.RData"))
hpdi_cpgs$SCORE <- "HPDI"
mmds_cpgs <- get(load("mmds/metagen_whole_fdrSig.RData"))
mmds_cpgs$SCORE <- "MMDS"


all_cpgs <- rbind(dashf_cpgs, hpdi_cpgs)
all_cpgs <- rbind(all_cpgs, mmds_cpgs)
all_cpgs <- all_cpgs[,c(1,30,2:29)]
all_cpgs<-all_cpgs[order(all_cpgs[,1]),]
rownames(all_cpgs) <- NULL
all_cpgs <- all_cpgs %>% 
  mutate_at(c(3:30), as.numeric)

### Filter by I2
all_cpgs$het <- with(all_cpgs, ifelse(I2>0.5 & `Pvalue Q`<0.05 & `Random Pvalue`>0.00001, 0, 1))
all_cpgs_clean<- all_cpgs[all_cpgs$het==1,c(1:4, 9:14,15,18,21,24,27)]

### Create directions
all_cpgs_clean$`FHS|WHI|REG450|REGepic|Airwave` <- paste(ifelse(all_cpgs_clean$`Coefficient FHS`>0,"+|","-|"),
                                                 ifelse(all_cpgs_clean$`Coefficient WHI`>0,"+|","-|"),
                                                 ifelse(all_cpgs_clean$`Coefficient REG450`>0,"+|","-|"),
                                                 ifelse(all_cpgs_clean$`Coefficient REGepic`>0,"+|","-|"),
                                                 ifelse(all_cpgs_clean$`Coefficient Airwave`>0,"+","-"))

save(all_cpgs_clean, file="./table_2/tabla_2.RData")
write.table(all_cpgs_clean, file="./table_2/tabla_2.csv", sep=",", quote = F, col.names = T, row.names = F)


## Bonferroni threshold <- 0.05/469761 (number of CpGs from metanalysis, go to
## B64_DIAMETR/Scripts/Meta_Airwave_ICL/any_score and load metagen.RData object)

cpgs_total_metagen <- get(load("/home/jdominguez1/B64_DIAMETR/Scripts/Meta_Airwave_ICL/dashf/metagen.RData"))
bonfe_thrs <- 0.05/length(cpgs_total_metagen$SNP) # 1.064371e-07

all_cpgs_clean_bonferroni <- all_cpgs_clean[all_cpgs_clean$`Fixed Pvalue`<=bonfe_thrs,]
save(all_cpgs_clean_bonferroni, file="./table_2/tabla_2_bonferroni.RData")
write.table(all_cpgs_clean_bonferroni, file="./table_2/tabla_2_bonferroni.csv",
            col.names = T, row.names = F, quote = F, sep = ",")
