##########################
####
##    Surrogate variables
####
##    Jorge Dominguez
##    November 2021
##########################



rm(list=ls())

date()


print("libraries")
library(sva)


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
pheno <- load(pheno.file)
pheno <- get(pheno)
str(pheno)


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
length(num_covariates)
length(chr_covariates)

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
print(dim(pheno))
num_covariates
chr_covariates
print("Pheno variables")
pheno <- pheno[,c(num_covariates, chr_covariates, "sample_name", x)]
print(head(pheno))
print(names(pheno)) 
pheno <- na.omit(pheno)
print(dim(pheno))


print("mt_val_matrix_t")
mt_val <- mt_val[which(rownames(mt_val)%in%pheno$sample_name),]
pheno <- pheno[which(pheno$sample_name%in%rownames(mt_val)),]
mt_val <- as.matrix(mt_val)
mt_val <- t(mt_val)


print("models")
mod <- paste("model.matrix(~", x)
if (!is.null(num_covariates)) {for (covi in num_covariates) mod = paste(mod, "+", covi) }
if (!is.null(chr_covariates)) {for (covi in chr_covariates) mod = paste(mod, "+", "factor(", covi, ")") }
mod <- paste(mod, ",data=pheno)", sep="")

mod0 <- NULL
if (!is.null(num_covariates)) {for (covi in num_covariates) mod0 = paste(mod0, "+", covi) }
if (!is.null(chr_covariates)) {for (covi in chr_covariates) mod0 = paste(mod0, "+", "factor(", covi, ")") }
mod0 <- substring(mod0, 3, nchar(mod0))
mod0 <- paste("model.matrix(~", mod0, ",data=pheno)", sep="")

part1 <- mod
part2 <- mod0
 
mod <- eval(parse(text = mod))
mod0 <- eval(parse(text = mod0))

print(paste('num.sv(na.omit(mt_val),', part1, 'method="leek",seed=123)', sep=""))
print(paste('sva(na.omit(mt_val),', part1, ',', part2, 'method="leek")', sep=""))

print(head(mod))
print(head(mod0))

print(str(pheno))

print(identical(pheno$sample_name, colnames(mt_val)))

dim(mt_val)
dim(na.omit(mt_val))
dim(mod)
dim(mod0)


print("svas")
part1
n.sv <- num.sv(na.omit(mt_val), mod, method="leek",seed=123)
n.sv
print("aqui1")
svobj <- sva(na.omit(mt_val), mod, mod0, n.sv = n.sv)
print(("aqui2"))
pheno_sv <- cbind(pheno, svobj$sv)
print("hi2")

n.sv = n.sv


print("Let's save it!")

j <- ncol(pheno)+1

for(i in 1:n.sv){
  names(pheno_sv)[j] <- paste("sva", i, sep="")
  j <- j+1
}


# # Select where to save the file
# if(x == "mds"){
#   free.text <- "/home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/mds"
# } else if(x =="mmds"){
#   free.text <- "/home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/mmds"
# } else if(x == "rmed"){
#   free.text <- "/home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/rmed"
# } else if(x == "hdi2015"){
#   free.text <- "/home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/hdi2015"
# } else if(x =="dashf"){
#   free.text <- "/home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/dashf"
# } else if(x=="hpdi"){
#   free.text <- "/home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/hpdi"
# }

write.table(pheno_sv, file=paste(free_text, out.file, n.sv, ".csv", sep=""), row.names=F, col.names=T, sep=",")


date()


print("###############################################THE END###############################################")

