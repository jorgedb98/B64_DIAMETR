rm(list=ls())

date()

print("loading files")
output=commandArgs()[6]
print(output)
results=commandArgs()[7]
print(results)


print("merging files")

overall_merge = get(load(paste(results,"model_2sva_hpdi_1.RData", sep="/")))
for(i in 2:42){
  current <- paste(results,"/","model_2sva_hpdi_",i,".RData",sep="")
  matrixx <- get(load(current))
  overall_merge <- rbind(overall_merge, matrixx)
  rm(matrixx)
}

print("Let's save it!")
save(overall_merge, file=paste(results, "/",output, ".RData", sep=""))
write.table(overall_merge, file=paste(results, "/",output, ".csv", sep=""), row.names=F, col.names=T, sep=";", quote=F)


date()

print("###############################################THE END###############################################")
