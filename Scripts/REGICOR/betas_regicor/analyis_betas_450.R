#####################################
## Jorge Domínguez-Barragán
## analysis for betas 450
## November 2021
##
#####################################

rm(list=ls())
cat("Starting analysis on ", date())

cat("\n\n\n")

cat("##################################################################\n")
cat("####                ANALYZING BETAS FOR 450                   ####\n")
cat("##################################################################\n\n")

suppressWarnings(library(minfi))
cat("\n\nMinfi loaded successfully\n")
library(limma)
cat("limma")
library("IlluminaHumanMethylation450kmanifest")
cat("IlluminaHumanMethylation450kmanifest\n")
library("IlluminaHumanMethylation450kanno.ilmn12.hg19")
cat("IlluminaHumanMethylation450kanno.ilmn12.hg19\n")
cat("\nLoading BETAS for 450\n")

loadRData <- function(fileName){
  #loads an RData file, and returns it
  load(fileName)
  get(ls()[ls() != "fileName"])
}

betas_450 <- loadRData("/home/jdominguez1/meth/betas_450.RData")
dim(betas_450)
cat("\nbetas_450 loaded\n")
cat("\nLoading regicor database\n\n")
regicor_450_pheno <- loadRData(fileName = "/home/jdominguez1/B64_DIAMETR/Dades/REGICOR/metildiet_with_cells_and_rightVars_450.RData")
betas_450 <- betas_450[,betas_450%in%regicor_450_pheno$sample_name]
cat("\nDMP analysis...\n")

mds_b <- regicor_450_pheno$mds_b
dmp <- dmpFinder(betas_450, pheno = mds_b  , type = "continuous")
head(dmp)
save(dmp, file="/home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/betas_regicor/dmp_mds.RData")

cat("Analysis finished on ", date(),"\n")
