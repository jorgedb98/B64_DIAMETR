rm(list=ls())

date()

print("libraries")
library(parallel)

setwd("~/B64_DIAMETR/Scripts/REGICOR/sv_cpgs_bmi_MRS/epic/mmds/")
print("loading files")
pheno.file="./pheno_sva_2.csv"
print(pheno.file)
mt_val.file="./mvalues_sd_mmds.RData"
print(mt_val.file)
num_covar.file="./num_covar_mmds.sh"
print(num_covar.file)
chr_covar.file="./chr_covar.sh"
print(chr_covar.file)
free_text="./"
print(free_text)
out.file="model_mmds_cpgs_bmi_MRS"
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
mt_val <- load(mt_val.file)
mt_val <- get(mt_val)
print(mt_val[1:3,1:3])


print("Same dim")
if(identical(rownames(mt_val), pheno$sample_name)==T)
{
  mt_val <- mt_val[pheno$sample_name,]
  identical(rownames(mt_val), pheno$sample_name)
}

if(identical(pheno$sample_name, rownames(mt_val))==F)
{
  mt_val <- mt_val[which(rownames(mt_val)%in%pheno$sample_name==T),]
  pheno <- pheno[which(pheno$sample_name%in%rownames(mt_val)==T),]
  mt_val <- mt_val[pheno$sample_name,]
  identical(pheno$sample_name, rownames(mt_val))
}

print("Dims de mt_val")
print(dim(mt_val))

print("Pheno variables")
pheno <- pheno[c(num_covariates, chr_covariates, "sample_name", "imc_s1","mmds_mrs")]
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
print(identical(rownames(mt_val), pheno$sample_name))
print(dim(mt_val))

print(dim(na.omit(mt_val)))
print(dim(pheno))
print(dim(na.omit(pheno)))
print(str(pheno))

print("Linear regresion - EWAS")

overal_pheno <- cbind(pheno, mt_val)

y <- overal_pheno[,"imc_s1"]
x1 <- overal_pheno[,"mmds_mrs"]
mod <- glm(y ~ x1 + X,family="gaussian",  data = overal_pheno)
coef <- (summary(mod)$coefficients)[2,"Estimate"]
sd <- (summary(mod)$coefficients)[2,"Std. Error"]
pval <- (summary(mod)$coefficients)[2,4]
out <- c(coef, sd,pval)
names(out) <- c("Coefficient", "Sd", "P value")
out

names(out) <- c("Coefficient","SE", "Pvalue")
save(out, file=paste(free_text, out.file, ".RData", sep=""))
write.table(out, file=paste(free_text, out.file, ".csv", sep=""), row.names=F, col.names=T, sep=";", quote=F)



date()

print("###############################################THE END###############################################")
