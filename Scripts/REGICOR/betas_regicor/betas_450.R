#####################################
## Jorge Domínguez-Barragán
## Script for betas 450
## November 2021
##
#####################################

rm(list=ls())
cat("Starting analysis on ", date())

cat("\n\n\n")

cat("##################################################################\n")
cat("####                 GETTING BETTAS FOR 450                   ####\n")
cat("##################################################################\n\n")

suppressWarnings(library(minfi))
cat("\n\nMinfi loaded successfully\n")
cat("\nLoading dasen objects for 450\n")

loadRData <- function(fileName){
  #loads an RData file, and returns it
  load(fileName)
  get(ls()[ls() != "fileName"])
}

dasen_450 <- loadRData("/home/jdominguez1/meth/450k_dasen.RData")
cat("\ndasen_450 loaded\n")

## Need to conver the Methyl set objects into GenomicMethylset
cat("\nConverting objects into GenomicMethylSet\n\n")
dasen_450_gmset <- mapToGenome(dasen_450)
cat("dasen_450 done\n")


cat("\n\nCalculating betas...\n")
betas_450 <- getBeta(dasen_450_gmset)
cat("\ndasen_450 done.\n")


cat("\n\nSaving betas...\n")
save(betas_450, file = "/home/jdominguez1/meth/betas_450.RData")
cat("\nbetas_450 done\n")

cat("Analysis finished on ", date(),"\n")
