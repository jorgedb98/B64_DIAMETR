rm(list = ls())


print("Loading libraries")
setwd("~/B64_DIAMETR/Scripts/Meta_bmi/dashf/")
library(gtools)
library(meta)
print("Libraries loaded")
model_long <- get(load("~/B64_DIAMETR/Scripts/Meta_bmi/dashf/dashf_long.RData"))
head(model_long)
my.dir="./"
my.file="metagen_dashf"
print("Meta analysis")
whole <- get(load("./model_whole.RData"))

i <- 1
j <- 5

out <- matrix(nrow = length(model_long$cpg)/5, ncol = 9)
out <- as.data.frame(out)
names(out)<- c("cpg",
               "Random Coefficient",
               "Random SE",
               "Random Pvalue",
               "Fixed Coefficient",
               "Fixed SE",
               "Fixed Pvalue",
               "I2",
               "Pvalue Q")
print(length(model_long$cpg))
print("Loop")
for(k in 1:(length(model_long$cpg)/5)){
  meta <- metagen(Coefficient, SE,studlab = cohort, data= model_long[c(i:j),])
  s <- summary(meta)
  CR <- s$random$TE
  SR <- s$random$seTE
  PR <- s$random$p
  CF <- s$fixed$TE
  SF <- s$fixed$seTE
  PF <- s$fixed$p
  I2 <- meta$I2
  PQ <- meta$pval.Q
  cpg <- model_long[i,1]
  vect <- c(cpg,CR,SR,PR,CF,SF,PF,I2,PQ)
  out[k,] <- vect
  i<-i+5
  j<-j+5
}

print("Whole meta done, saving files!")

str(out)
out <- out %>% 
  mutate_at(c(2:9), as.numeric)
str(out)
save(out, file = paste(my.dir, my.file, ".RData", sep=""))
write.table(out, paste(my.dir, my.file, ".csv", sep=""), row.names=F, col.names=T, sep=",")

print("Merging with whole files and saving!")
out_whole <- merge(out, whole, by="cpg")
save(out_whole, file = paste(my.dir, my.file, "_whole", ".RData", sep=""))
write.table(out_whole, paste(my.dir, my.file, "_whole", ".csv", sep=""), row.names=F, col.names=T, sep=",")
