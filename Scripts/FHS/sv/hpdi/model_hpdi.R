rm(list=ls())

date()

print("libraries")
library(parallel)
# library(lme4)


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
rm(mt_value_n)
print(mt_val[1:3,1:3])

mini_mtval <- mt_val
dim(mini_mtval)


print("Same dim")
if(identical(rownames(mini_mtval), pheno$Slide)==T)
{
  mini_mtval <- mini_mtval[pheno$Slide,]
  identical(rownames(mini_mtval), pheno$Slide)
}

if(identical(pheno$Slide, rownames(mini_mtval))==F)
{
  mini_mtval <- mini_mtval[which(rownames(mini_mtval)%in%pheno$Slide==T),]
  pheno <- pheno[which(pheno$Slide%in%rownames(mini_mtval)==T),]
  mini_mtval <- mini_mtval[pheno$Slide,]
  identical(pheno$Slide, rownames(mini_mtval))
}

print("Dims de mt_val")
print(dim(mini_mtval))

print("Pheno variables")
pheno <- pheno[, c(num_covariates, chr_covariates, "Slide", x)]
print(head(pheno))
print(names(pheno)) 
pheno <- na.omit(pheno)
print(dim(pheno))


print("cpgs to analyze")
cpg<-names(mini_mtval)
print(dim(mini_mtval))
print(length(cpg))
print(cpg)


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
print(identical(rownames(mini_mtval), pheno$Slide))
print(dim(mini_mtval))
print(dim(na.omit(mini_mtval)))
print(dim(pheno))
print(dim(na.omit(pheno)))
print(str(pheno))
# mini_cpg <- cpg[1:2]
# mini_mt <- mt_val[1:100,1:2]

print("Linear regresion - EWAS")

# set.seed(123)
# res <- mclapply(cpg, function(i){
#   y <- mini_mtval[,i]
#   mod <- glm(y ~ x1, family="gaussian")
#   coef<- summary(mod)$coefficients[2,"Estimate"]
#   se <- summary(mod)$coefficients[2,"Std. Error"]
#   pval <- summary(mod)$coefficients[2,"Pr(>|z|)"]
#   out <- c(coef, se, pval)
#   names(out) <- c("Coefficient","SE", "Pvalue")
#   out
#   dim(mod)
# })
# 
# res

###############
#### otra forma de hacerlo CON SOLO EL PRIMER CPG
###############



# y <- mini_mtval[,1]
# print("lengths")
# print(length(x1))
# print(length(y))
# print(nrow(X))
# 
# mod <- glm(y ~x1 + X, family = "gaussian", data = cbind(pheno, mini_mtval))
# coef<- summary(mod)$coefficients[2,1]
# se <- summary(mod)$coefficients[2,2]
# pval <- se <- summary(mod)$coefficients[2,4]
# out <- c(coef, se, pval)
# names(out) <- c("Coefficient","SE", "Pvalue")
# out



###############
#### otra forma de hacerlo CON DOS CPG
###############



# set.seed(123)
# res <- mclapply(cpg, function(i){
#   y <- mini_mtval[,i]
#   mod <- glm(y ~x1 + X, family = "gaussian", data = cbind(pheno, mini_mtval))
#   coef<- summary(mod)$coefficients[2,1]
#   se <- summary(mod)$coefficients[2,2]
#   pval <- summary(mod)$coefficients[2,4]
#   out <- c(coef, se, pval)
#   names(out) <- c("Coefficient","SE", "Pvalue")
#   out
#   dim(mod)
# })
# 
# head(res)
out <- as.data.frame(matrix(ncol=4, nrow = length(cpg)))
print(length(cpg))
for(i in 1:length(cpg)){
  y <- mini_mtval[,i]
  mod <- glm(y ~x1 + X, family = "gaussian", data = cbind(pheno, mini_mtval))
  coef <- summary(mod)$coefficients[2,1]
  se <- summary(mod)$coefficients[2,2]
  pval <- summary(mod)$coefficients[2,4]
  out[i,] <- c(cpg[i],coef,se,pval)
}
print("dimensiones")
print(dim(out))
rownames(out)<- out[,1]
out <- out[,-1]
names(out) <- c("Coefficient","SE", "Pvalue")
write.table(out, file=paste(free_text, out.file, ".csv", sep=""), row.names=T, col.names=T, sep=";", quote=F)
##################################################


###############
### RESULTADOS
###############

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
# 
# date()




#########################################################################################

# print("Same dim")
# if(identical(rownames(mt_val), pheno$Slide)==T)
# {
#   mt_val <- mt_val[pheno$Slide,]
#   identical(rownames(mt_val), pheno$Slide)
# }
# 
# if(identical(pheno$Slide, rownames(mt_val))==F)
# {
#   mt_val <- mt_val[which(rownames(mt_val)%in%pheno$Slide==T),]
#   pheno <- pheno[which(pheno$Slide%in%rownames(mt_val)==T),]
#   mt_val <- mt_val[pheno$Slide,]
#   identical(pheno$Slide, rownames(mt_val))
# }
# 
# print("Dims de mt_val")
# print(dim(mt_val))
# 
# print("Pheno variables")
# pheno <- pheno[, c(num_covariates, chr_covariates, "Slide", x)]
# print(head(pheno))
# print(names(pheno)) 
# pheno <- na.omit(pheno)
# print(dim(pheno))
# 
# 
# print("cpgs to analyze")
# cpg<-names(mt_val)
# print(dim(mt_val))
# print(length(cpg))
# print(cpg)
# 
# 
# print("diet=x1")
# x1 <- pheno[,x]
# head(x1,5)
# 
# print("covar=X")
# X <- "cbind("
# if (!is.null(num_covariates)) {for (covi in num_covariates) X=paste(X, paste("pheno$", covi,",", sep=""), sep="") }
# if (!is.null(chr_covariates)) {for (covi in chr_covariates) X=paste(X, paste("factor(pheno$", covi, "),", sep=""), sep="") }
# X <- substring(X, 1, nchar(X)-1)
# X <- paste(X,")", sep="")
# print(X)
# X <- eval(parse(text=X))
# 
# print("Trying what is in X")
# colnames(X)<-c(num_covariates, chr_covariates)
# colnames(X)
# 
# print("info prior to ewas")
# print(identical(rownames(mt_val), pheno$Slide))
# print(dim(mt_val))
# print(dim(na.omit(mt_val)))
# print(dim(pheno))
# print(dim(na.omit(pheno)))
# 
# mini_cpg <- cpg[1:2]
# mini_mt <- mt_val[1:100,1:2]
# 
# print("Linear regresion - EWAS")
# res <- mclapply(mini_cpg, function(i){
#   y <- mini_mt[,i]
#   mod <- glm(y ~ x1 + X, family="gaussian")
#   coef<- summary(mod)$coefficients[2,"Estimate"]
#   se <- summary(mod)$coefficients[2,"Std. Error"]
#   pval <- summary(mod)$coefficients[2,"Pr(>|z|)"]
#   out <- c(coef, se, pval)
#   names(out) <- c("Coefficient","SE", "Pvalue")
#   out
#   dim(mod)
# })
# 
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
# 
# date()

# print("Linear regresion - EWAS")
# res <- mclapply(cpg, function(i){
#   y <- mt[,i]
#   mod <- glm(y ~ x1 + X + (1|pheno_fhs$family_ID), family="gaussian")
#   coef<- summary(mod)$coefficients[2,"Estimate"]
#   se <- summary(mod)$coefficients[2,"Std. Error"]
#   pval <- summary(mod)$coefficients[2,"Pr(>|z|)"]
#   out <- c(coef, se, pval)
#   names(out) <- c("Coefficient","SE", "Pvalue")
#   out
#   dim(mod)
# })
# 
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
# 
# date()


print("###############################################THE END###############################################")

