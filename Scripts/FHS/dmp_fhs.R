#####################################
## Jorge Domínguez-Barragán
## Script for getting the dasen on FHS
## November 2021
##
#####################################

rm(list=ls())
cat("Starting analysis on ", date())

cat("\n\n\n")

cat("##################################################################\n")
cat("####                  ANALYSIS OF FHS 450K                    ####\n")
cat("##################################################################\n\n")

suppressMessages(library(wateRmelon))
suppressMessages(library(minfi))
suppressMessages(library(dplyr))

cat("\nLoading betas for FHS...\n")
loadRData <- function(fileName){
  #loads an RData file, and returns it
  load(fileName)
  get(ls()[ls() != "fileName"])
}
betas_fhs <- loadRData(fileName = "/projects/regicor/data/FHS/methylation/450k/betas_meth/beta_fhs.RData")
cat("Data loaded successfully!\n\n")
cat("\nLoading phenotype data...\n")

pheno_fhs <- loadRData("/home/jdominguez1/B64_DIAMETR/Dades/FHS/fhs_diet_cellsVarsFam.RData")
cat("\nPheno loaded successfully\n")
cat("\n\nSelecting from beta dataframe those participants in the pheno data...\n")

#Remove participants not in pheno
betas_fhs <- betas_fhs[,pheno_fhs$Slide]
cat("\nbetas reduced to new size...\n")
dim(betas_fhs)
head(betas_fhs)
cat("\nDMP analysis...\n")

mds <- pheno_fhs$mds
length(mds)
dmp <- dmpFinder(betas_fhs, pheno = mds  , type = "continuous")
head(dmp)
save(dmp, file="/home/jdominguez1/B64_DIAMETR/Dades/FHS/dmp_mds.RData")


cat("Analysis finished on ", date(),"\n")
