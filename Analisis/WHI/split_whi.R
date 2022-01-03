whi_mt <- get(load("/home/jdominguez1/meth/mvals_z_4sd.RData"))

div<-ncol(whi_mt)%/%10000
rest<-ncol(whi_mt)%%10000

final_part <- whi_mt[,(ncol(whi_mt)-(rest-1)):ncol(whi_mt)]
inter_matrix <- whi_mt[,-c((ncol(whi_mt)-(rest-1)):ncol(whi_mt))]

s<- 1
e<- 10000

for(i in 1:div){
  output <- paste("mt_val_",i, sep = "")
  mini_mt <- subset(inter_matrix, select=s:e)
  print(dim(inter_matrix))
  print(dim(mini_mt))
  my_dir <- paste("/home/jdominguez1/meth/whi/mt_",i,sep = "")
  dir.create(my_dir)
  save(mini_mt, file = paste(my_dir,"/",output,".RData", sep=""))
  print(paste("Done with iteration ", i, sep = ""))
  s <- s + 10000
  e <- e + 10000
}

output <- paste(paste("mt_val_",(div+1), sep = ""))
my_dir <- paste("/home/jdominguez1/meth/whi/mt_",(div+1),sep = "")
dir.create(my_dir)
save(final_part, file = paste(my_dir,"/",output,".RData", sep=""))
