rm(list=ls())

date()

print("libraries")
library(parallel)
library(lme4)
library(nlme)
library(lmerTest)
library(geepack)

setwd("/home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv_bmi/dashf/")
print("loading files")
pheno.file="./pheno_sva_2.csv"
print(pheno.file)
mt_val.file="./mvalues_sd_dashf.RData"
print(mt_val.file)
num_covar.file="./num_covar.sh"
print(num_covar.file)
chr_covar.file="./chr_covar.sh"
print(chr_covar.file)
free_text="./"
print(free_text)
out.file="model_dashf_bmi"
print(out.file)


print("Load Pheno")
pheno <- read.table(pheno.file, header=T, stringsAsFactors = F, sep=",")
print(head(pheno))


print("Load covariates")
num_covariates <- try(read.table(num_covar.file, header=F, stringsAsFactors = F, sep=","))
chr_covariates <- try(read.table(chr_covar.file, header=F, stringsAsFactors = F, sep=","))

print(num_covariates)
if(inherits(num_covariates, 'try-error')){
  num_covariates=NULL
}

print(chr_covariates)
if(inherits(chr_covariates, 'try-error')){
  chr_covariates=NULL
}

num_covariates <- num_covariates$V1
chr_covariates <- chr_covariates$V1


print("free_text")
slash <- substring(free_text, nchar(free_text), nchar(free_text))

if(slash!="/")
{
  free_text=paste(free_text, "/", sep = "")
}


print("Load methylation data - mvals")
mt_val <- get(load(mt_val.file))
mt_val <- na.omit(mt_val)
dim(mt_val)
print(mt_val[1:3,1:3])


print("Same dim")
if(identical(rownames(mt_val), pheno$slide)==T)
{
  mt_val <- mt_val[pheno$slide,]
  identical(rownames(mt_val), pheno$slide)
}

if(identical(pheno$slide, rownames(mt_val))==F)
{
  mt_val <- mt_val[which(rownames(mt_val)%in%pheno$slide==T),]
  pheno <- pheno[which(pheno$slide%in%rownames(mt_val)==T),]
  mt_val <- mt_val[pheno$slide,]
  identical(pheno$slide, rownames(mt_val))
}

print("Dims de mt_val")
print(dim(mt_val))

print("Pheno variables")
pheno <- pheno[c(num_covariates, chr_covariates, "slide","dashf")]
print(head(pheno))
print(names(pheno)) 
pheno <- na.omit(pheno)
print(dim(pheno))


print("cpgs to analyze")
cpg<-names(mt_val)
print(dim(mt_val))
print(length(cpg))

print("covar=X")
X <- "cbind("
if (!is.null(num_covariates)) {for (covi in num_covariates) X=paste(X, paste("pheno$", covi,",", sep=""), sep="") }
if (!is.null(chr_covariates)) {for (covi in chr_covariates) X=paste(X, paste("factor(pheno$", covi, "),", sep=""), sep="") }
X <- substring(X, 1, nchar(X)-1)
X <- paste(X,")", sep="")
print(X)
X <- eval(parse(text=X))

print("Trying what is in X")
colnames(X)<-c(num_covariates, chr_covariates)
colnames(X)

print("info prior to ewas")
print(identical(rownames(mt_val), pheno$slide))
print(dim(mt_val))

print("Linear regresion - EWAS")

overal_pheno <- cbind(pheno, mt_val)
overal_pheno <- na.omit(overal_pheno)
overal_pheno$family_ID <- sort(overal_pheno$family_ID)
res <- mclapply(cpg, function(i){
  y <- overal_pheno[,i]
  x1 <- overal_pheno[,"dashf"]
  mod <- geeglm(y~x1+X, family=gaussian, id=family_ID, data=overal_pheno)
  coefficiente <- coef(summary(mod))[2,1]
  se <- coef(summary(mod))[2,2]
  pval <- coef(summary(mod))[2,4]
  out <- c(coefficiente, se, pval)
  names(out) <- c("Coefficient", "Sd", "P value")
  out
})

head(res)
print("Let's save it!")
res <- matrix(unlist(res), ncol=3, byrow=T)
head(res)
colnames(res) <- c("Coefficient","SE", "Pvalue")
rownames(res) <- cpg
res <- as.data.frame(res)
res$cpg<-rownames(res)
res<-res[order(res[,3]),]
res<-res[,c(4,1:3)]
head(res)
save(res, file=paste(free_text, out.file, ".RData", sep=""))
write.table(res, file=paste(free_text, out.file, ".csv", sep=""), row.names=F, col.names=T, sep=";", quote=F)


date()


print("###############################################THE END###############################################")
