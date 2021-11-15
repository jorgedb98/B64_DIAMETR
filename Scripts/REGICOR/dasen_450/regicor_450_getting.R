#####################################
## Jorge Domínguez-Barragán
## Script for getting the dasen on 450k
## November 2021
##
#####################################

rm(list=ls())
cat("Starting analysis on ", date())

cat("\n\n\n")

cat("##################################################################\n")
cat("####            ANALYSIS OF RGSET OBJECT FOR 450K             ####\n")
cat("##################################################################\n\n")

suppressMessages(library(wateRmelon))
suppressMessages(library(minfi))
suppressMessages(library(dplyr))

loadRData <- function(fileName){
  #loads an RData file, and returns it
  load(fileName)
  get(ls()[ls() != "fileName"])
}
regicor_RGSet <- loadRData(fileName = "/projects/regicor/data/REGICOR/methylation/450k/RGChannelSetExtended/RGset_updated.RData")
cat("Data loaded successfully!\n\n")
cat("Converting into mset object...\n\n")

regicor_mset <- preprocessRaw(regicor_RGSet)

cat("\nFor normalization, dasen will be applied\n")
regicor_mset_dasen <- dasen(regicor_mset,fudge=100,ret2=FALSE)
cat("\nDasen done in regicor_mset\n")

cat("\nSaving dasen object...")
save(regicor_mset_dasen, file ="/home/jdominguez1/meth/450k_dasen.RData")

cat("\nFile saved successfully...\n")
cat("Analysis finished on ", date(),"\n")