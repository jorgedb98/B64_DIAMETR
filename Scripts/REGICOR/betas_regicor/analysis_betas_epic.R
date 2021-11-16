#####################################
## Jorge Domínguez-Barragán
## analysis for betas epic
## November 2021
##
#####################################

rm(list=ls())
cat("Starting analysis on ", date())

cat("\n\n\n")

cat("##################################################################\n")
cat("####                ANALYZING BETAS FOR EPIC                  ####\n")
cat("##################################################################\n\n")

suppressWarnings(library(minfi))
cat("\n\nMinfi loaded successfully\n")
library(limma)
cat("limma\n")
library(dplyr)
cat("dplyr\n")
library("IlluminaHumanMethylation450kmanifest")
cat("IlluminaHumanMethylation450kmanifest\n")
library("IlluminaHumanMethylation450kanno.ilmn12.hg19")
cat("IlluminaHumanMethylation450kanno.ilmn12.hg19\n")
cat("\nLoading BETAS for epic\n")

loadRData <- function(fileName){
  #loads an RData file, and returns it
  load(fileName)
  get(ls()[ls() != "fileName"])
}

betas_epic1 <- loadRData("/home/jdominguez1/meth/betas_epic1.RData")
cat("\nBETAS epic 1\n")
dim(betas_epic1)
betas_epic2 <- loadRData("/home/jdominguez1/meth/betas_epic2.RData")
cat("\nBETAS epic 2\n")
dim(betas_epic2)

# join into one dataframe. CAREFUL! A new first column is introduced having the rownames..!!!!
betas_epic <- merge(betas_epic1, betas_epic2, by="row.names")
# betas_epic_small <- betas_epic[1:4,]
# save(betas_epic_small, file = "/home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/betas_regicor/betas_epic.RData")
row.names(betas_epic) <- betas_epic$Row.names
betas_epic <- betas_epic[,-1]
cat("\nbetas_epic loaded and merged\n")
dim(betas_epic)
cat("\nLoading epic database\n\n")
regicor_epic_pheno <- loadRData(fileName = "/home/jdominguez1/B64_DIAMETR/Dades/REGICOR/metildiet_with_cells_and_rightVars_epic.RData")
cat("\nRegicor database loaded!\n\n")

#Remove from betas the samples that we are not considering in the pheno
betas_epic <- as.matrix(betas_epic[,regicor_epic_pheno$sample_name])
cat("\nbetas reduced to new size...\n")
dim(betas_epic)
ncol(betas_epic)
head(betas_epic, n=3)
cat("\nDMP analysis...\n")

mds_b <- regicor_epic_pheno$mds_b
length(mds_b)
dmp <- dmpFinder(betas_epic, pheno = mds_b  , type = "continuous")
head(dmp)
save(dmp, file="/home/jdominguez1/B64_DIAMETR/Dades/REGICOR/dmp_mds_epic.RData")

cat("Analysis finished on ", date(),"\n")
