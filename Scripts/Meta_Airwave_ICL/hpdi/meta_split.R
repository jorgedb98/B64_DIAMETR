# Script for splitting the long dataset
hpdi_long <- get(load("/home/jdominguez1/B64_DIAMETR/Scripts/Meta_Airwave_ICL/hpdi/hpdi_long.RData"))


div<-nrow(hpdi_long)%/%100000
rest<-nrow(hpdi_long)%%100000


s<- 1
e<- 100000

for(i in 1:div){
  output <- paste("long_",i, sep = "")
  mini_mt <- hpdi_long[s:e,]
  print(dim(mini_mt))
  my_dir <- paste("/home/jdominguez1/B64_DIAMETR/Scripts/Meta_Airwave_ICL/hpdi/mini_longs/mini_longs",i,sep = "")
  dir.create(my_dir)
  save(mini_mt, file = paste(my_dir,"/",output,".RData", sep=""))
  print(paste("Done with iteration ", i, sep = ""))
  s <- s + 100000
  e <- e + 100000
}

firsty <- nrow(hpdi_long) - rest +1
final_part <- hpdi_long[firsty:nrow(hpdi_long),]
output <- paste(paste("long_",(div+1), sep = ""))
my_dir <- paste("/home/jdominguez1/B64_DIAMETR/Scripts/Meta_Airwave_ICL/hpdi/mini_longs/mini_longs",(div+1),sep = "")
dir.create(my_dir)
save(final_part, file = paste(my_dir,"/",output,".RData", sep=""))
