# Subset for the SNPs that are related with out CpGs
rm(list=ls())
setwd(dir = "/home/jdominguez1/B64_DIAMETR/Scripts/MR/T2D/")
all_T2D <- read.table("./Mahajan.NatGenet2018b.T2Dbmiadj.European.txt", header = T, sep="\t", dec = ".")
my_snps <- get(load("../find_snps/exposure_data.RData"))
my_snps$concatenate <- paste(my_snps$`SNP Chr`,my_snps$`SNP Pos`,sep=":")

my_T2D_snps <- all_T2D[all_T2D$SNP%in%my_snps$concatenate,]
names(my_T2D_snps)[1] <- "concatenate"

my_T2D_snps_rs <- merge(my_snps, my_T2D_snps, by="concatenate")
my_T2D_snps_rs <- my_T2D_snps_rs[,c(2,14:22)]

write.table(my_T2D_snps_rs, file="./my_T2D_SNPS.csv", sep=",", quote = F, col.names = T, row.names = F)
