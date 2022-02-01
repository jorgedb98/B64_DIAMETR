# Script for creating 3 smoking groups

fhs_pheno <- load("/home/jdominguez1/B64_DIAMETR/Dades/FHS/fhs_diet_cellsVarsFam.RData")
fhs_pheno <- get(fhs_pheno)
head(fhs_pheno)
fhs_pheno <- as.data.frame(na.omit(fhs_pheno))
table(fhs_pheno$smoke)
fhs_pheno$smoke <- as.character(fhs_pheno$smoke)

fhs_pheno[fhs_pheno == "f1-5" | fhs_pheno == "f>5"] <- "ex-smoker"
fhs_pheno$smoke <- as.factor(fhs_pheno$smoke)
table(fhs_pheno$smoke)
fhs_pheno$family_ID <- as.factor(fhs_pheno$family_ID)
str(fhs_pheno)

# BMI
# fhs_pheno$BMI <- NA
# for(i in 1:nrow(fhs_pheno)){
#   fhs_pheno[i, which(colnames(fhs_pheno)=="BMI")] <- fhs_pheno[i, which(colnames(fhs_pheno)=="weight")] / ((fhs_pheno[i, which(colnames(fhs_pheno)=="height")])/100)^2
# }
# fhs_pheno <- fhs_pheno[,-52]
# fhs_pheno$family_ID <- as.character(fhs_pheno$family_ID)
# fhs_pheno$smoke <- as.character(fhs_pheno$smoke)
save(fhs_pheno, file = "/home/jdominguez1/B64_DIAMETR/Dades/FHS/fhs_diet_cellsVarsFam.RData")
