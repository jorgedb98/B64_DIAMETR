#####################################
## Jorge Domínguez-Barragán
## Analysis RGSet object REGICOR data
## October 2021
##
#####################################
rm(list=ls())

cat("Starting analysis on ", date())
# sink('bartlett-output.txt', append = F, type = c("output", "message"))

cat("\n\n\n")

cat("##################################################################\n")
cat("####                 ANALYSIS OF RGSET OBJECT                 ####\n")
cat("##################################################################\n\n")


cat("Loading minfi package...\n")
suppressMessages(library(minfi))
cat("minfi package loaded successfully!\n\n")

cat("Loading data from projects folder\n")
cat("###################################\n\n\n")
# Function for loading data with desired name
loadRData <- function(fileName){
  #loads an RData file, and returns it
  load(fileName)
  get(ls()[ls() != "fileName"])
}
betas_regicor450 <- loadRData(fileName = "/projects/regicor/data/REGICOR/methylation/450k/RGChannelSetExtended/RGset_updated.RData")
cat("Data loaded successfully!\n\n")

cat("This is the phenotypic data associated with the RGSet object\n")
phenoData <- pData(betas_regicor450)
colnames(phenoData)
cat("\n\n")

cat("The manifest object contains the probe design information of the array:\n")
manifest <- getManifest(betas_regicor450)
manifest
cat("\n\n")
head(getProbeInfo(manifest))
cat("\n\n")

cat("Quality control\n")
cat("###################################\n\n\n")

cat("Getting methylated intensities matrix...\n")
MSet <- preprocessRaw(betas_regicor450) 
head(getMeth(MSet)[,1:3])
cat(ncol(getMeth(MSet)))
cat("\nColumn number 1...\n")
cat("\n\n")

cat("Getting unmethylated intensities matrix...\n")
head(getUnmeth(MSet)[,1:3])
cat("\nColumn number 2...\n")
cat(ncol(getUnmeth(MSet)))
cat("\n\n")

cat("Getting quality control plots...\n\n")

qc <- getQC(MSet)

png(file="/home/jdominguez1/B64_DIAMETR/Scripts/RGSet_analysis/results/qc.png",
    width=600, height=350)
plotQC(qc)
garbage <- dev.off()

png(file="/home/jdominguez1/B64_DIAMETR/Scripts/RGSet_analysis/results/density.png",
    width=600, height=350)
densityPlot(MSet, sampGroups = phenoData$sexe)
garbage <- dev.off()


png(file="/home/jdominguez1/B64_DIAMETR/Scripts/RGSet_analysis/results/bean.png",
    width=600, height=350)
densityBeanPlot(MSet, sampGroups = phenoData$sexe)
garbage <- dev.off()


png(file="/home/jdominguez1/B64_DIAMETR/Scripts/RGSet_analysis/results/strip.png",
    width=600, height=350)
controlStripPlot(betas_regicor450, controls="BISULFITE CONVERSION II")
garbage <- dev.off()

cat("Individual plots done!\n\n")
# cat("Individual plots done! Building pdf report\n\n")
# 
# qcReport(betas_regicor450, pdf= "qcReport.pdf")
# cat("pdf report done!\n\n")

cat("Getting sex prediction...\n\n")
GRset <- mapToGenome(betas_regicor450)
estSex <- getSex(GRset, cutoff = -2)
GRset <- addSex(GRset, sex = estSex)

png(file="/home/jdominguez1/B64_DIAMETR/Scripts/RGSet_analysis/results/sex.png",
    width=600, height=350)
plotSex(GRset)
garbage <- dev.off()

cat("Sex prediction done\n\n")

cat("Quality control done\t*\n")

cat("Preprocessing and normalization\n")
cat("###################################\n\n\n")

cat("Starting quantile preprocessing...\n\n")

GRset.quantile <- preprocessQuantile(betas_regicor450, fixOutliers = TRUE,
                                     removeBadSamples = TRUE, badSampleCutoff = 10.5,
                                     quantileNormalize = TRUE, stratified = TRUE, 
                                     mergeManifest = FALSE, sex = NULL)

cat("Quantile preprocessing done!\t*\n\n")

cat("Genetics variants removal\n")
cat("###################################\n\n\n")

snps <- getSnpInfo(GRset)
head(snps,10)
GRset <- addSnpInfo(GRset)
GRset <- dropLociWithSnps(GRset, snps=c("SBE","CpG"), maf=0)

cat("\nGenetics variants removal done!\t*\n")

cat("\nFinding differentially methylated points\n\n")

beta <- getBeta(GRset.quantile)
sex  <- pData(GRset.quantile)$sexe
dmp <- dmpFinder(beta, pheno = sex  , type = "categorical")
cat("These are some of them\n")
head(dmp)

cat("\nSaving DMPs...\n")
save(dmp, file = "/home/jdominguez1/B64_DIAMETR/Scripts/RGSet_analysis/results/DMPs.RData")

cat("\nAnalysis finished on ", date(),"\n")

# rm(list=ls())
# 
# library(minfi)
# library(wateRmelon)
# library(RnBeads)
# library(IlluminaHumanMethylationEPICmanifest)
# 
# print("MethylSet from Minfi")
# epic1 <- load("/projects/regicor/METIAM/EPIC/QC/singularity/n416_repes/4.sex/metiam_391_Methylset.RData")
# epic1 <- get(epic1)
# epic2 <- load("/projects/regicor/data/REGICOR/methylation/epic2/qc/2.pfilter/metiam_pf_208.RData")
# epic2 <- get(epic2)
# 
# pheno <- read.table("/projects/regicor/diabetes_wided/db_epic.csv", header=T, stringsAsFactors = F, sep=";")
# 
# epic1 <- epic1[,which(epic1@colData@rownames%in%pheno$Slide)]
# epic2 <- epic2[,which(epic2@colData@rownames%in%pheno$Slide)]
# 
# epic1 <- epic1[which(names(epic1)%in%names(epic2)),]            #810793
# epic2 <- epic2[which(names(epic2)%in%names(epic1)),]
# 
# epic <- combineArrays(epic1, epic2, outType="IlluminaHumanMethylationEPIC")
# save(epic, file="/projects/regicor/data/REGICOR/methylation/methylset_epics12_controls.RData")
# 
# print("methylumi")
# methylumi <- as.methylumi(epic)
# 
# print("Dasen_normalization_wateRmelon")
# norm_dasen <- dasen(methylumi)
# 
# print("Betas Dasen ")
# betas_dasen <- norm_dasen@assayData$betas
# betas_dasen <- t(betas_dasen)
# save(betas_dasen, file="/projects/regicor/data/REGICOR/methylation/betas_dasen_epics12_controls.RData")
# 
# print("end")