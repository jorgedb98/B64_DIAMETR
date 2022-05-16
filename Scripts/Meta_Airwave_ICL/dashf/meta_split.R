# Script for splitting the long dataset
dashf_long <- get(load("/home/jdominguez1/B64_DIAMETR/Scripts/Meta_Airwave_ICL/dashf/dashf_long.RData"))


div<-nrow(dashf_long)%/%100000
rest<-nrow(dashf_long)%%100000


s<- 1
e<- 100000

for(i in 1:div){
  output <- paste("long_",i, sep = "")
  mini_mt <- dashf_long[s:e,]
  print(dim(mini_mt))
  my_dir <- paste("/home/jdominguez1/B64_DIAMETR/Scripts/Meta_Airwave_ICL/dashf/mini_longs/mini_longs",i,sep = "")
  dir.create(my_dir)
  save(mini_mt, file = paste(my_dir,"/",output,".RData", sep=""))
  print(paste("Done with iteration ", i, sep = ""))
  s <- s + 100000
  e <- e + 100000
}

firsty <- nrow(dashf_long) - rest +1
final_part <- dashf_long[firsty:nrow(dashf_long),]
output <- paste(paste("long_",(div+1), sep = ""))
my_dir <- paste("/home/jdominguez1/B64_DIAMETR/Scripts/Meta_Airwave_ICL/dashf/mini_longs/mini_longs",(div+1),sep = "")
dir.create(my_dir)
save(final_part, file = paste(my_dir,"/",output,".RData", sep=""))
