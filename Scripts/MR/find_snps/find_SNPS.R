# Find SNPs associated with the CpGs from the metanalysis of 5 cohorts using model 1.
# Calculate SE using PLINK and GCTA databases

all_cpgs <- get(load("/home/jdominguez1/B64_DIAMETR/Scripts/Meta_Airwave_ICL/table_2/tabla_2.RData"))
all_cpgs_names <- all_cpgs$SNP
all_cpgs_names <- unique(all_cpgs_names)
write.table(all_cpgs_names, file = "/home/jdominguez1/B64_DIAMETR/Scripts/MR/find_snps/all_cpgs.txt", quote = F, col.names = F, row.names = F,
            sep = "\n")


plink <- read.csv("/home/jdominguez1/B64_DIAMETR/Scripts/MR/find_snps/plink.csv", header = T, sep=",")
gcta <- read.csv("/home/jdominguez1/B64_DIAMETR/Scripts/MR/find_snps/gcta.csv", header = T, sep=",")

mqtl <- merge(gcta, plink, by="SNP")
mqtl$SE <-mqtl$beta.y/mqtl$t.stat.y
mqtl <- mqtl[,c(1,3:11,14,30)]
names(mqtl) <- c("SNP",
                 "SNP Chr",
                 "SNP Pos",
                 "A1",
                 "A2",
                 "MAF",
                 "CpG",
                 "CpG Chr",
                 "CpG Pos",
                 "B",
                 "P Value",
                 "SE")
mqtl <- mqtl[,c(1:10,12,11)]
mqtl <- mqtl[!duplicated(mqtl$SNP), ]

# save(mqtl, file = "/home/jdominguez1/B64_DIAMETR/Scripts/MR/find_snps/exposure_data.RData")
# write.table(mqtl, file = "/home/jdominguez1/B64_DIAMETR/Scripts/MR/find_snps/exposure_data.csv",quote = F, col.names = T, row.names = F, sep=",")


### Harmonize so that the presence of allele corresponds to better diet (same sign than
### CpG-diet table 2)

test_direction <- all_cpgs[,c("SNP","Fixed Coefficient")]
names(test_direction)[1] <- "CpG"
mqtl<- merge(mqtl, test_direction, by="CpG")
mqtl <- mqtl[!duplicated(mqtl$SNP), ]

mqtl$A1.new <- with(mqtl, ifelse((B<0 & `Fixed Coefficient`<0) |(B>0 & `Fixed Coefficient`>0),A1,A2))      # If same sign B and Fixed, same value
mqtl$A2.new <- with(mqtl, ifelse((B<0 & `Fixed Coefficient`<0) |(B>0 & `Fixed Coefficient`>0),A2,A1))      # if not, change the allele,
mqtl$MAF.new <- with(mqtl, ifelse((B<0 & `Fixed Coefficient`<0) |(B>0 & `Fixed Coefficient`>0),MAF,1-MAF)) # recalculate MAF
mqtl$B.new <- with(mqtl, ifelse((B<0 & `Fixed Coefficient`<0) |(B>0 & `Fixed Coefficient`>0),B,-B))        # and Recalculate B.
mqtl <- mqtl[,c(1:4,14:16,8,9,17,11,12)]

save(mqtl, file = "/home/jdominguez1/B64_DIAMETR/Scripts/MR/find_snps/exposure_data.RData")
write.table(mqtl, file = "/home/jdominguez1/B64_DIAMETR/Scripts/MR/find_snps/exposure_data.csv",quote = F, col.names = T, row.names = F, sep=",")
