rm(list = ls())

date()

modelo.long = commandArgs()[6]
print(modelo.long)
my.dir = commandArgs()[7]
print(my.dir)
my.file = commandArgs()[8]
print(my.file)

print("Loading libraries")

library(gtools)
library(meta)
print("Libraries loaded")
model_long <- get(load(modelo.long))
head(model_long)

print("Meta analysis")

i <- 1
j <- 5

out <- matrix(nrow = length(model_long$SNP)/5, ncol = 11)
out <- as.data.frame(out)
names(out)<- c("SNP",
               "CHR",
               "BP",
               "Random Coefficient",
               "Random SE",
               "Random Pvalue",
               "Fixed Coefficient",
               "Fixed SE",
               "Fixed Pvalue",
               "I2",
               "Pvalue Q")
print(length(model_long$SNP))
print("Loop")
for(k in 1:(length(model_long$SNP)/5)){
  meta <- metagen(Coefficient, SE,studlab = cohort, data= model_long[c(i:j),])
  s <- summary(meta)
  CR <- s$TE.random
  SR <- s$seTE.random
  PR <- s$pval.random
  CF <- s$TE.fixed
  SF <- s$seTE.fixed
  PF <- s$pval.fixed
  I2 <- s$I2
  PQ <- s$pval.Q
  SNP <- model_long[i,1]
  CHR <- model_long[i,2]
  BP <- model_long[i,3]
  vect <- c(SNP,CHR,BP,CR,SR,PR,CF,SF,PF,I2,PQ)
  out[k,] <- vect
  i<-i+5
  j<-j+5
}

print("Whole meta done, saving files!")

str(out)
save(out, file = paste(my.dir, my.file, ".RData", sep=""))
write.table(out, paste(my.dir, my.file, ".csv", sep=""), row.names=F, col.names=T, sep=",")

print("Merging with whole files and saving!")
out_whole <- merge(out, model_long, by="SNP")

save(out_whole, file = paste(my.dir, my.file, "_whole", ".RData", sep=""))
write.table(out_whole, paste(my.dir, my.file, "_whole", ".csv", sep=""), row.names=F, col.names=T, sep=",")
