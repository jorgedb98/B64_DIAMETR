## Splitting the M-values data matrix for quicker EWAS performance

fhs_mt <- get(load("/home/jdominguez1/meth/mt_value_n_no_extrem_value_analysis.RData"))

div<-ncol(fhs_mt)%/%10000
rest<-ncol(fhs_mt)%%10000

final_part <- fhs_mt[,(ncol(fhs_mt)-(rest-1)):ncol(fhs_mt)]
inter_matrix <- fhs_mt[,-c((ncol(fhs_mt)-(rest-1)):ncol(fhs_mt))]

s<- 1
e<- 10000

for(i in 1:div){
  output <- paste("mt_val_",i, sep = "")
  mini_mt <- subset(inter_matrix, select=s:e)
  print(dim(inter_matrix))
  print(dim(mini_mt))
  my_dir <- paste("/home/jdominguez1/meth/fhs/mt_",i,sep = "")
  dir.create(my_dir)
  save(mini_mt, file = paste(my_dir,"/",output,".RData", sep=""))
  print(paste("Done with iteration ", i, sep = ""))
  s <- s + 10000
  e <- e + 10000
}

output <- paste(paste("mt_val_",(div+1), sep = ""))
my_dir <- paste("/home/jdominguez1/meth/fhs/mt_",(div+1),sep = "")
dir.create(my_dir)
save(final_part, file = paste(my_dir,"/",output,".RData", sep=""))
