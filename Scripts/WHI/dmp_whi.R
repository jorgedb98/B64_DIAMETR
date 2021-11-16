#####################################
## Jorge Domínguez-Barragán
## Script for getting the dasen on WHI
## November 2021
##
#####################################

rm(list=ls())
cat("Starting analysis on ", date())

cat("\n\n\n")

cat("##################################################################\n")
cat("####                  ANALYSIS OF whi 450K                    ####\n")
cat("##################################################################\n\n")

suppressMessages(library(wateRmelon))
suppressMessages(library(minfi))
suppressMessages(library(dplyr))

cat("\nLoading betas for WHI...\n")
loadRData <- function(fileName){
  #loads an RData file, and returns it
  load(fileName)
  get(ls()[ls() != "fileName"])
}
betas_whi <- loadRData(fileName = "/projects/regicor/data/WHI/methylation/betas_dasen.RData")
cat("Data loaded successfully!\n\n")
cat("\nLoading phenotype data...\n")

pheno_whi <- loadRData("/home/jdominguez1/B64_DIAMETR/Dades/WHI/phenofood0_whi.RData")
dim(pheno_whi)
cat("\nPheno loaded successfully\n")
cat("\n\nSelecting from beta dataframe those participants in the pheno data...\n")

#Remove participants not in pheno
betas_whi <- betas_whi[,pheno_whi$Slide]
cat("\nbetas reduced to new size...\n")
dim(betas_whi)
head(betas_whi)
cat("\nDMP analysis...\n")

# mds <- pheno_whi$mds
# length(mds)
# dmp <- dmpFinder(betas_whi, pheno = mds  , type = "continuous")
# head(dmp)
# save(dmp, file="/home/jdominguez1/B64_DIAMETR/Dades/WHI/dmp_mds.RData")
# 
# 


design <- model.matrix(~0+CD8T+CD4T+Bcell+Mono+NK+Gran+AGE+DIAB,data=pheno_whi)
cat("\nDesign matrix build...\n")
cat("Some information on the design matrix\n\n")
colnames(design)
head(design)
dim(design)

# Some diab rows have NA's so, we delete this individuals also in B matrix. Get the names
# from pheno and disselect from B those samples.
pheno_whi <- na.omit(pheno_whi)
dim(pheno_whi)
betas_whi_filt <- as.matrix(betas_whi[,pheno_whi$Slide])
dim(betas_whi_filt)

cat("\nFitting the model\n")
#fit the linear model
fit <- lmFit(betas_whi_filt, design)
fit2 <- eBayes(fit)
cat("\nA summary of the output\n\n")
summary(decideTests(fit2))

cat("\n\nMetadata of CpGs from Illumina\n")
# Metadata of CpGs from Illumina
cat("\npeta aqui?????\n")
ann450k <- getAnnotation(IlluminaHumanMethylation450kanno.ilmn12.hg19)
head(ann450k)
# ann450kSub <- ann450k[match(rownames(t(betas_whi_filt)),ann450k$Name),
#                       c(1:4,18:21,24:ncol(ann450k))]

#top Table for first coefficient 1 (diabetes)
DMPs <- topTable(fit2, num=Inf, coef=1, genelist = ann450k, sort.by="p")
head(DMPs)

# Extract Chr, pos, and adjusted p-value columns

DMPs2 <- DMPs[,c(1:2,27)]
head(DMPs2)

write.csv(DMPs2,"/home/jdominguez1/B64_DIAMETR/Dades/WHI/DMPs2.csv",
          row.names = TRUE)

#
#
cat("Analysis finished on ", date(),"\n")

