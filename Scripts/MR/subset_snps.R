# Subset for the SNPs that are related with out CpGs

setwd(dir = "/home/jdominguez1/B64_DIAMETR/Scripts/MR/CVD/")
all_CVD <- read.table("./cad.add.160614.website.txt", header = T, sep="\t", dec = ".")
names(all_CVD)[1] <- "SNP"
my_snps <- get(load("../find_snps/exposure_data.RData"))

my_CVD_snps <- all_CVD[all_CVD$SNP%in%my_snps$SNP,]

write.table(my_CVD_snps, file="./my_CVD_SNPS.csv", sep=",", quote = F, col.names = T, row.names = F)
