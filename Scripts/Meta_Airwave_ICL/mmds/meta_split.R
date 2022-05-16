# Script for splitting the long dataset
mmds_long <- get(load("/home/jdominguez1/B64_DIAMETR/Scripts/Meta_Airwave_ICL/mmds/mmds_long.RData"))


div<-nrow(mmds_long)%/%100000
rest<-nrow(mmds_long)%%100000


s<- 1
e<- 100000

for(i in 1:div){
  output <- paste("long_",i, sep = "")
  mini_mt <- mmds_long[s:e,]
  print(dim(mini_mt))
  my_dir <- paste("/home/jdominguez1/B64_DIAMETR/Scripts/Meta_Airwave_ICL/mmds/mini_longs/mini_longs",i,sep = "")
  dir.create(my_dir)
  save(mini_mt, file = paste(my_dir,"/",output,".RData", sep=""))
  print(paste("Done with iteration ", i, sep = ""))
  s <- s + 100000
  e <- e + 100000
}

firsty <- nrow(mmds_long) - rest +1
final_part <- mmds_long[firsty:nrow(mmds_long),]
output <- paste(paste("long_",(div+1), sep = ""))
my_dir <- paste("/home/jdominguez1/B64_DIAMETR/Scripts/Meta_Airwave_ICL/mmds/mini_longs/mini_longs",(div+1),sep = "")
dir.create(my_dir)
save(final_part, file = paste(my_dir,"/",output,".RData", sep=""))
