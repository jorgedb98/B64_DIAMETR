rm(list=ls())

date()

print("libraries")
library(parallel)

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
pheno <- pheno[c(num_covariates, chr_covariates, "sample_name", x)]
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
print(identical(rownames(mt_val), pheno$sample_name))
print(dim(mt_val))

print(dim(na.omit(mt_val)))
print(dim(pheno))
print(dim(na.omit(pheno)))
print(str(pheno))

print("Linear regresion - EWAS")

res <- mclapply(cpg, function(i){
  y <- mt_val[,i]
  mod <- glm(y ~ x1 + X,family="gaussian",  data = cbind(pheno, mt_val))
  coef <- (summary(mod)$coefficients)[2,"Estimate"]
  sd <- (summary(mod)$coefficients)[2,"Std. Error"]
  pval <- (summary(mod)$coefficients)[2,4]
  out <- c(coef, sd,pval)
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
save(res, file=paste(free_text, out.file, ".RData", sep=""))
write.table(res, file=paste(free_text, out.file, ".csv", sep=""), row.names=F, col.names=T, sep=";", quote=F)



date()

print("###############################################THE END###############################################")