#####################################
## Jorge Domínguez-Barragán
## Script for trial betas
## November 2021
##
#####################################

rm(list=ls())
cat("Starting analysis on ", date())

cat("\n\n\n")

cat("##################################################################\n")
cat("####            GETTING BETTAS FOR EPIC1 Y EPIC2              ####\n")
cat("##################################################################\n\n")

suppressWarnings(library(minfi))
cat("\n\nMinfi loaded successfully\n")
cat("\nLoading dasen objects for epic\n")

loadRData <- function(fileName){
  #loads an RData file, and returns it
  load(fileName)
  get(ls()[ls() != "fileName"])
}

epic1_dasen <- loadRData("/home/jdominguez1/meth/epic1_dasen.RData")
cat("\nEpic1_dasen loaded\n")
epic2_dasen <- loadRData("/home/jdominguez1/meth/epic2_dasen.RData")
cat("\nEpic2_dasen loaded\n")

## Need to conver the Methyl set objects into GenomicMethylset
cat("\nConverting objects into GenomicMethylSet\n\n")
epic1_dasen_gmset <- mapToGenome(epic1_dasen)
cat("epic1 done\n")
epic2_dasen_gmset <- mapToGenome(epic2_dasen)
cat("epic2 done\n")

cat("\n\nCalculating betas...\n")
betas_epic1 <- getBeta(epic1_dasen_gmset)
cat("\nepic1 done.\n")
betas_epic2 <- getBeta(epic2_dasen_gmset)
cat("\nepic1 done.\n")

cat("\n\nSaving betas...\n")
save(betas_epic1, file = "/home/jdominguez1/meth/betas_epic1.RData")
cat("\nepic1 done\n")
save(betas_epic2, file = "/home/jdominguez1/meth/betas_epic2.RData")
cat("epic2 done\n")

cat("Analysis finished on ", date(),"\n")
