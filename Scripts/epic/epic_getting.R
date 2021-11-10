#####################################
## Jorge Domínguez-Barragán
## Script for getting the samples for A22 from the epic studies
## October 2021
##
#####################################

rm(list=ls())
cat("Starting analysis on ", date())

cat("\n\n\n")

cat("##################################################################\n")
cat("####            ANALYSIS OF RGSET OBJECT FOR epic1            ####\n")
cat("####                 AND METHYLSET FOR epic2                  ####\n")
cat("##################################################################\n\n")

suppressMessages(library(wateRmelon))
suppressMessages(library(minfi))
suppressMessages(library(dplyr))

cat("Packages loaded successfully...\n")

loadRData <- function(fileName){
  #loads an RData file, and returns it
  load(fileName)
  get(ls()[ls() != "fileName"])
}

regicor_ids <- loadRData("B64_DIAMETR/Dades/REGICOR/regicor_ids.RData")
cat("\nREGICOR ids loaded successfully...\n")


epic1 <- loadRData("metiam_391_Methylset.RData")
epic1_f <- colData(epic1)[colData(epic1)$Sample_Name %in% regicor_ids$Sample_ID,]
cat("\nepic1 is a MethylSet object\n")

epic2 <- loadRData("metiam_data_ext_208.RData")
epic2_f <- colData(epic2)[colData(epic2)$Sample_Name %in% regicor_ids$Sample_ID,]
cat("\nepic2 is a RGSet object\n")
cat("\n\n\n")

cat("####################################################\n")
cat("####          Getting MSet from RGSet           ####\n")
cat("####################################################\n")

epic2_mset <- preprocessRaw(epic2) 

cat("\nFor normalization, dasen will be applied\n")
dasen(epic1_f,fudge=100,ret2=FALSE)
cat("Dasen done in epic1\n")
dasen(epic2_mset, fudge=100,ret2=FALSE)
cat("Dasen done in epic2\n")