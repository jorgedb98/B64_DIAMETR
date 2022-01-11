pheno <- get(load("U:/Estudis/B64_DIAMETR/Dades/FHS/fhs_diet_cellsVarsFam.RData"))
class(pheno$family_ID)
j<-10000
for(i in 1:length(pheno$family_ID)){
  if(pheno[i,55]==0){
    pheno[i,55] = j
    j <- j+1
  }
}
