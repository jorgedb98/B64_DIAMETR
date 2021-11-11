#####################################
## Jorge Domínguez-Barragán
## Script for trial betas
## November 2021
##
#####################################

## From epic2
cat("Start")
suppressMessages(library(wateRmelon))
suppressMessages(library(minfi))
suppressMessages(library(dplyr))

loadRData <- function(fileName){
  #loads an RData file, and returns it
  load(fileName)
  get(ls()[ls() != "fileName"])
}

epic2_dasen <- load("/home/jdominguez1/meth/epic2_dasen.RData")
epic2_dasen
cat("\nepic loaded")
ecpi2_betas <- getBeta(epic2_dasen)
cat("\nbetas calculated")
save(epic2_dasen, file ="/home/jdominguez1/meth/epic2_betas.RData")
cat("\nbetas saved")