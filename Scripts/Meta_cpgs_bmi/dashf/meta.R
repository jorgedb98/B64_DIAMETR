# Meta Analysis

rm(list=ls())

date()


print("libraries")
library(tidyr)
library(gtools)

print("Loading files")
setwd("~/B64_DIAMETR/Scripts/Meta_cpgs_bmi/dashf/")
model.file = "./model_whole.RData"
print(model.file)
outdir = "./"
print(outdir)
outfile = "dashf_long"
print(outfile)

modelo <- get(load(model.file))
str(modelo)

# Select the variables to keep for the analysis
# Coeff<-as.data.frame(modelo[,c("SNP","Coefficient FHS", "Coefficient WHI", "Coefficient REG450", "Coefficient REGepic")])
# SE<- as.data.frame(modelo[,c("SNP","SE FHS", "SE WHI", "SE REG450", "SE REGepic")])
# PVal <-as.data.frame(modelo[,c("SNP","Pvalue FHS", "Pvalue WHI", "Pvalue REG450", "Pvalue REGepic")])
# QVal<-as.data.frame(modelo[,c("SNP","Q FHS", "Q WHI", "Q REG450", "Q REGepic")])

model_long <- reshape(modelo, direction="long",
        varying=list(c("Coefficient FHS", "Coefficient WHI", "Coefficient REG450", "Coefficient REGepic", "Coefficient Airwave"),
                     c("SE FHS", "SE WHI", "SE REG450", "SE REGepic", "SE Airwave"),
                     c("Pvalue FHS", "Pvalue WHI", "Pvalue REG450", "Pvalue REGepic", "Pvalue Airwave")),
        v.names=c("Coefficient","SE","PValue"))
model_long$time <- with(model_long, ifelse(time==1,"FHS",ifelse(time==2,"WHI",ifelse(time==3,"REG450", ifelse(time==4,"REGepic","Airwave")))))
names(model_long)[2] <- "cohort"
model_long <- model_long[,-6]
model_long <- model_long[mixedorder(as.character(model_long$cpg)),]
save(model_long, file= paste(outdir,"/", outfile, ".RData", sep=""))

print(outdir)

date()

print("###############################################THE END###############################################")

