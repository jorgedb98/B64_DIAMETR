rm(list=ls())

date()

print("libraries")
library(parallel)
library(lme4)
library(nlme)
library(lmerTest)

print("loading files")
pheno.file=commandArgs()[6]
print(pheno.file)
mt_val.file=commandArgs()[7]
print(mt_val.file)
x=commandArgs()[8]
print(x)
num_covar.file=commandArgs()[9]
print(num_covar.file)
chr_covar.file=commandArgs()[10]
print(chr_covar.file)
free_text=commandArgs()[11]
print(free_text)
out.file=commandArgs()[12]
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
dim(mt_val)
# mt_val <- mt_val[,1:10000]
# save(mt_val, file="/home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/mds/small_mt.RData")
print(mt_val[1:3,1:3])


print("Same dim")
if(identical(rownames(mt_val), pheno$Slide)==T)
{
  mt_val <- mt_val[pheno$Slide,]
  identical(rownames(mt_val), pheno$Slide)
}

if(identical(pheno$Slide, rownames(mt_val))==F)
{
  mt_val <- mt_val[which(rownames(mt_val)%in%pheno$Slide==T),]
  pheno <- pheno[which(pheno$Slide%in%rownames(mt_val)==T),]
  mt_val <- mt_val[pheno$Slide,]
  identical(pheno$Slide, rownames(mt_val))
}

print("Dims de mt_val")
print(dim(mt_val))

print("Pheno variables")
pheno <- pheno[c(num_covariates, chr_covariates, "Slide", x)]
print(head(pheno))
print(names(pheno)) 
pheno <- na.omit(pheno)
print(dim(pheno))


print("cpgs to analyze")
cpg<-names(mt_val)
print(dim(mt_val))
print(length(cpg))


print("diet=x1")
x1 <- as.numeric(pheno[,x])
head(x1,5)

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
print(identical(rownames(mt_val), pheno$Slide))
print(dim(mt_val))

print(dim(na.omit(mt_val)))
print(dim(pheno))
print(dim(na.omit(pheno)))
pheno$NUT_CALOR <- (pheno$NUT_CALOR)/1000
pheno$family_ID <- as.factor(pheno$family_ID)
pheno$sex <- as.factor(pheno$sex)
pheno$smoke <- as.factor(pheno$smoke)
print(str(pheno))

print("Linear regresion - EWAS")


###############
#### otra forma de hacerlo CON SOLO EL PRIMER CPG
###############


# dim(mt_val)
# 
# 
# print("lengths")
# print(length(x1))
# print(length(y))
# print(nrow(X))

# summary(pheno)
# 
# mod <- lmer(y ~ x1 + X + (1|family_ID), data = cbind(pheno, mt_val))
# mod
# print("results")
# coef <- summary(mod)$coeff[2,1]
# sd <- summary(mod)$coeff[2,2]
# tval <- summary(mod)$coeff[2,5]
# pval <- anova(mod)[1,6]
# out <- c(coef, sd, tval, pval)
# names(out)<-c("coef", "sd", "tval", "pval")
# out


# res <- mclapply(cpg, function(i){
#   y <- mt_val[,i]
#   mod <- glmer(y ~ x1 + X + (1|family_ID), family="gaussian", data = cbind(pheno, mt_val))
#   coef <- (summary(mod)$coeff)[2,1]
#   sd <- (summary(mod)$coeff)[2,2]
#   pval <- (summary(mod)$coeff)[2,3]
#   out <- c(coef, sd,pval)
#   names(out) <- c("Coefficient", "Sd", "P value")
#   out
# })

overal_pheno <- cbind(pheno, mt_val)
print("centering the data")
pheno$age <- scale(pheno$age, scale=F)


y <- mt_val[,10]
mod <- lmer(y ~ x1 + X + (1|family_ID), data=overal_pheno)
print("comparing models")
anova(mod)

summary(mod)
coef <- (summary(mod)$coeff)[2,1]
sd <- (summary(mod)$coeff)[2,2]
pval <- (summary(mod)$coeff)[2,3]
out <- c(coef, sd,pval)
names(out) <- c("Coefficient", "Sd", "P value")
out
# head(res)
# 
# print("Let's save it!")
# res <- matrix(unlist(res), ncol=3, byrow=T)
# head(res)
# colnames(res) <- c("Coefficient","SE", "Pvalue")
# rownames(res) <- cpg
# res <- as.data.frame(res)
# res$cpg<-rownames(res)
# res<-res[order(res[,3]),]
# res<-res[,c(4,1:3)]
# save(res, file=paste(free_text, out.file, ".RData", sep=""))
# write.table(res, file=paste(free_text, out.file, ".csv", sep=""), row.names=F, col.names=T, sep=";", quote=F)
# 
# date()

print("###############################################THE END###############################################")

