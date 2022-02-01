# Script for coming up with family relationship on Framingham cohort
# 21 October 2021 - Jorge Domínguez Barragán

# Load data with family info

framingham_family <- read.csv(file = "/home/jdominguez1/B64_DIAMETR/Dades/FHS/phs000007.v32.pht000183.v13.p13.Framingham_Pedigree.MULTI_fine.csv",
                              header = T)

# remove empty/useless rows
framingham_family <- tail(framingham_family, -9)
colnames(framingham_family) <- framingham_family[1,]
rownames(framingham_family) <- NULL
framingham_family <- tail(framingham_family, -1)
rownames(framingham_family) <- NULL

#Saving dataframe with nicer format
save(framingham_family, file ="/home/jdominguez1/B64_DIAMETR/Dades/framingham_family_relationship_updated.RData")

# Creating family ID variable. We will consider that n individuals belong to the
# same family ID if having at least same father ID OR mother ID (half-siblings).
# When making comparisons take care that the same individual is not compared to
# thyself as sibling!!!!!

framingham_family$family_ID <- NA
i <- 1 #family ID

for(j in 1:length(framingham_family$dbGaP_Subject_ID)){
  if(is.na(framingham_family[j,9])){ # only work on subjects having no family ID yet
    if(framingham_family[j,4] == "" && framingham_family[j,5] == ""){ # ID 0 for 
      framingham_family[j,9] <- 0                                     # those not having fshar or mashare
    } else {    # when subject does not have family ID yet
      framingham_family[j,9] <- i
      for (k in 1:length(framingham_family$fshare)) {
        if((framingham_family[k,4] == framingham_family[j,4] && framingham_family[k,1] != framingham_family[j,1])
           | (framingham_family[k,5] == framingham_family[j,5] && framingham_family[k,1] != framingham_family[j,1])){
          # if same father or mother BUT different id (to not compare to itself), then new siblings
          framingham_family[k,9] <- framingham_family[j,9] # same ID as current subject being analysed.
        }
      }
      i <- i+1 #create new family ID
    }
  }
}

save(framingham_family, file = "/home/jdominguez1/B64_DIAMETR/Dades/framingham_byFamilyID.RData")

sort(table(framingham_family$family_ID), decreasing=T) # To sort families by number of subjects.
which(table(framingham_family$family_ID) == 9) # Family IDs having the largest number of subjects.
# 180  589  905 1425 1882 
# 181  590  906 1426 1883 
framingham_family$family_ID_f <- as.factor(framingham_family$family_ID)
which(table(framingham_family$family_ID_f) == "0") # Family IDs having the largest number of subjects.
table(framingham_family$family_ID)
# 6201 orphans