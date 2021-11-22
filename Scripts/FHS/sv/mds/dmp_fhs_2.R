#####################################
## Jorge Domínguez-Barragán
## Script for getting the dasen on FHS
## November 2021
##
#####################################


rm(list=ls())

cat("Starting analysis on ", date())

cat("\n\n\n")

cat("##################################################################\n")
cat("####                  ANALYSIS OF FHS 450K                    ####\n")
cat("##################################################################\n\n")

cat("###################\n")
cat(" Loading libraries \n")
cat("###################\n\n")

library(sva)

cat("\n###################\n")
cat("    Input files    \n")
cat("###################\n\n")

pheno.file=commandArgs()[6]
cat("Pheno file: ")
cat(pheno.file)

betas.file=commandArgs()[7]
cat("\nBetas file: ")
cat(betas.file)

x=commandArgs()[8]
cat("\nDependent Var: ")
cat(x)

num_covar.file=commandArgs()[9]
cat("\nNumerical covars: ")
cat(num_covar.file)

chr_covar.file=commandArgs()[10]
cat("\nCharacter covars: ")
cat(chr_covar.file)

free_text=commandArgs()[11]
cat("\nFree text: ")
cat(free_text)

out.file=commandArgs()[12]
cat("\nOutput file: ")
cat(out.file)

cat("\n###################\n")
cat(" Starting analysis \n")
cat("###################\n")

cat("\nPheno file:\n\n")

pheno <- load(pheno.file)
pheno <- get(pheno)
pheno$mds <- as.factor(pheno$mds)
pheno$mmds <- as.factor(pheno$mmds)
pheno$rmed <- as.factor(pheno$rmed)
pheno$hdi2015 <- as.factor(pheno$hdi2015)
pheno$dashf <- as.factor(pheno$dashf)
pheno$hpdi <- as.factor(pheno$hpdi)
pheno$Slide <- as.character(pheno$Slide)
cat(head(pheno,2))


cat("\nCovariables\n\n")
num_covariates <- try(read.table(num_covar.file, header=F, stringsAsFactors = F, sep=","))
chr_covariates <- try(read.table(chr_covar.file, header=F, stringsAsFactors = F, sep=","))

cat(num_covariates)
if(inherits(num_covariates, 'try-error')){
  num_covariates=NULL
}

cat(chr_covariates)
if(inherits(chr_covariates, 'try-error')){
  chr_covariates=NULL
}

num_covariates <- num_covariates$V1
chr_covariates <- chr_covariates$V1


cat("\nFree text\n\n")
slash <- substring(free_text, nchar(free_text), nchar(free_text))

if(slash!="/")
{
  free_text=paste(free_text, "/", sep = "")
}


cat("\nBetas_z\n\n")
betas <- load(betas.file)
betas <- get(betas)
# rm(betas_z)
cat(betas[1:3,1:3])


if(identical(rownames(betas), pheno$Slide)==T)
{
  betas <- betas[pheno$Slide,]
  identical(rownames(betas), pheno$Slide)
}

if(identical(pheno$Slide, rownames(betas))==F)
{
  betas <- betas[which(rownames(betas)%in%pheno$Slide==T),]
  pheno <- pheno[which(pheno$Slide%in%rownames(betas)==T),]
  betas <- betas[pheno$Slide,]
  identical(pheno$Slide, rownames(betas))
}

pheno <- pheno[, c(num_covariates, chr_covariates, "Slide", x)]
cat(head(pheno))
cat(names(pheno)) 
pheno <- na.omit(pheno)
cat(dim(pheno))

cat("\ncpgs to analyze\n\n")
cpg<-names(betas)
cat(cpg)

cat("\nVar of interest=x1\n\n")
x1 <- pheno[,x]

cat("\ncovars=X\n\n")
X <- "cbind("
if (!is.null(num_covariates)) {for (covi in num_covariates) X=paste(X, paste("pheno$", covi,",", sep=""), sep="") }
if (!is.null(chr_covariates)) {for (covi in chr_covariates) X=paste(X, paste("factor(pheno$", covi, "),", sep=""), sep="") }
X <- substring(X, 1, nchar(X)-1)
X <- paste(X,")", sep="")
cat(X)
X <- eval(parse(text=X))


cat("identical(rownames(betas), pheno$Slide)")
cat(identical(rownames(betas), pheno$Slide))
cat(dim(betas))
cat(dim(na.omit(betas)))
cat(dim(pheno))
cat(dim(na.omit(pheno)))

library(compareGroups)
library(parallel)

cat("EWAS linear regression")
res <- mclapply(cpg, function(i){
  y <- betas[,i]
  mod <- glm(x1 ~ y + X , family="gaussian")
  coef<- summary(mod)$coefficients[2,"Estimate"]
  se <- summary(mod)$coefficients[2,"Std. Error"]
  pval <- summary(mod)$coefficients[2,"Pr(>|z|)"]
  out <- c(coef, se, pval)
  names(out) <- c("Coefficient","SE", "Pvalue")
  out
})

cat("Let's save it!")
res <- matrix(unlist(res), ncol=3, byrow=T)
colnames(res) <- c("Coefficient","SE", "Pvalue")
rownames(res) <- cpg
res <- as.data.frame(res)
res$cpg<-rownames(res)
res<-res[order(res[,3]),]
res<-res[,c(4,1:3)]
save(res, file=paste(free_text, out.file, ".RData", sep=""))
write.table(res, file=paste(free_text, out.file, ".csv", sep=""), row.names=F, col.names=T, sep=";", quote=F)

date()

cat("###############################################THE END###############################################")


