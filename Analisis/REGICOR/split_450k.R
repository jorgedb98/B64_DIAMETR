mt_450 <- get(load("/home/jdominguez1/meth/mt_regicor_450.RData"))

div<-ncol(mt_450)%/%10000
rest<-ncol(mt_450)%%10000

final_part <- mt_450[,(ncol(mt_450)-(rest-1)):ncol(mt_450)]
inter_matrix <- mt_450[,-c((ncol(mt_450)-(rest-1)):ncol(mt_450))]

s<- 1
e<- 10000

for(i in 1:div){
  output <- paste("mt_val_",i, sep = "")
  mini_mt <- subset(inter_matrix, select=s:e)
  print(dim(inter_matrix))
  print(dim(mini_mt))
  my_dir <- paste("/home/jdominguez1/meth/450k/mt_",i,sep = "")
  dir.create(my_dir)
  save(mini_mt, file = paste(my_dir,"/",output,".RData", sep=""))
  print(paste("Done with iteration ", i, sep = ""))
  s <- s + 10000
  e <- e + 10000
}

output <- paste(paste("mt_val_",(div+1), sep = ""))
my_dir <- paste("/home/jdominguez1/meth/450k/mt_",(div+1),sep = "")
dir.create(my_dir)
save(final_part, file = paste(my_dir,"/",output,".RData", sep=""))
