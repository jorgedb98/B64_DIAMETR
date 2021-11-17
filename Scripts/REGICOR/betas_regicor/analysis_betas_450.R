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
cat("\nRegicor database loaded!\n\n")

#Remove from betas the samples that we are not considering in the pheno
betas_450 <- betas_450[,regicor_450_pheno$sample_name]
cat("\nbetas reduced to new size...\n")
dim(betas_450)
head(betas_450)
cat("\nDMP analysis...\n")

# mds_b <- regicor_450_pheno$mds_b
# length(mds_b)
# dmp <- dmpFinder(betas_450, pheno = mds_b  , type = "continuous")
# head(dmp)
# save(dmp, file="/home/jdominguez1/B64_DIAMETR/Dades/REGICOR/dmp_mds_450.RData")

#
#

# Considering diet
design <- model.matrix(~0+CD8T+CD4T+Bcell+Mono+NK+Gran+edat_b+diab_b+mds_b+mmds_b+rmed_b+hdi_b+dashf_b+hpdi_b,data=pheno_fhs)
cat("\nDesign matrix build...\n")
cat("Some information on the design matrix\n\n")
colnames(design)
head(design)
dim(design)

# Some diab rows have NA's so, we delete this individuals also in B matrix. Get the names
# from pheno and disselect from B those samples. En regicor no puedo usar esto
# porque hay variables que no creo que miremos que tiene NAS pero q a lo mejor si
# tienen valores de dieta

# regicor_450_pheno<- na.omit(regicor_450_pheno)
# dim(regicor_450_pheno)
# betas_450_filt <- as.matrix(betas_450[,regicor_450_pheno$Slide])
# dim(betas_450_filt)

cat("\nFitting the model\n")
#fit the linear model
fit <- lmFit(betas_450_filt, design)
cat("\nnames de fit\n")
names(fit)
cat("\nCalculating moderated t-statistics with the function eBayes()\n")
fit2 <- eBayes(fit)
cat("\nnames de fit2\n")
names(fit2)
cat("\nA summary of the output\n\n")
summary(decideTests(fit2))

# The function decideTests() by default does not impose any cutoff on the
# fold-change, it adjusts p-values using FDR and calls DE genes at 5% FDR.
# This can be changed through the arguments lfc, adjust.method and p.value,
# respectively. For instance, we can call DE genes at 10% FDR by setting p.value=0.1:

cat("\nSummary providing pvalue cut-off\n")
summary(decideTests(fit2, p.value=0.1))

cat("\n\nMetadata of CpGs from Illumina\n")
# Metadata of CpGs from Illumina
cat("\npeta aqui?????\n")
ann450k <- getAnnotation(IlluminaHumanMethylation450kanno.ilmn12.hg19)
head(ann450k)
# ann450kSub <- ann450k[match(rownames(t(betas_fhs_filt)),ann450k$Name),
#                       c(1:4,18:21,24:ncol(ann450k))]

#top Table for first coefficient 1 (diabetes)
DMPs <- topTable(fit2, num=Inf, coef=1, genelist = ann450k, sort.by="p")
head(DMPs)

# Extract Chr, pos, and adjusted p-value columns

DMPs2 <- DMPs[,c(1:2,27)]
head(DMPs2)

write.csv(DMPs2,"/home/jdominguez1/B64_DIAMETR/Dades/REGICOR/DMPs2.csv",
          row.names = TRUE, sep = ",")
#
#


cat("Analysis finished on ", date(),"\n")
