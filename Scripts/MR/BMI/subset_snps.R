# Subset for the SNPs that are related with out CpGs

setwd(dir = "/home/jdominguez1/B64_DIAMETR/Scripts/MR/BMI/")
all_BMI <- read.table("./bmi.giant-ukbb.meta-analysis.combined.23May2018.HapMap2_only.txt", header = T, sep=" ", dec = ".")
all_BMI$SNP<- gsub("\\:.*","",all_BMI$SNP) # trimming the :Allele_1:Allele_2 from SNP
my_snps <- get(load("../find_snps/exposure_data.RData"))

my_BMI_snps <- all_BMI[all_BMI$SNP%in%my_snps$SNP,]

write.table(my_BMI_snps, file="./my_BMI_SNPS.csv", sep=",", quote = F, col.names = T, row.names = F)
