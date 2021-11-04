############ GETTING IDs DIAMETR study ######################
# Jorge Dominguez, October 2021.

library(dplyr)

#########  #########  #########  #########  #########  #########  #########  #########
############################### REGICOR ############################################
#########  #########  #########  #########  #########  #########  #########  #########

            ########################## 450k ##########################

load("U:/Estudis/B18_Methyl_DNA/Dades/TELEFORM/lectura_datos/2015-12-15/fusion1_2015-12-15.Rdata")
# fusion1

barcode <- read.csv(file = "/Estudis/B18_Methyl_DNA/Dades/genotyping_lab_pilot/all_samplesheetv2_no_groups_phenotype.csv", head =T, sep =";")
barcode <- tail(barcode, -5)
colnames(barcode) <- barcode[1,]
barcode <- tail(barcode, -1)
barcode <- barcode[,c(1,2)]
rownames(barcode) <- NULL


#remove any space character
for(i in 1:length(fusion1$id)){
  fusion1[i,1] <- str_trim(fusion1[i,1], side = "both")
  fusion1[i,1] <- gsub("_.*","",fusion1[i,1])
}

#remove _Rescan objects from barcode
for(i in 1:length(barcode$Sample_ID)){
  barcode[i,2] <- gsub("_.*","",barcode[i,2])
}

colnames(fusion1)[1] <- "Sample_ID"
r_fusion <- merge(fusion1, barcode, by="Sample_ID")

# keep only interesting columns
r_fusion <- r_fusion[,c(1,4,146)]
r_fusion$pool_id <- "450K"
save(r_fusion, file = "/Estudis/B64_DIAMETR/Analisis/REGICOR/450_with_barcode.RData")
r_fusion <- r_fusion[,c(1,2,4)]
colnames(r_fusion) <- c("Sample_ID", "parti","Pool_ID")

########################## EPIC ##########################

# epic_regicor <- read.csv("U:/Estudis/B37_METIAM/Dades/EPIC/2_RECIBIDO/SampleSheet_RElosua_20180215.csv", header = T, sep=",")
# epic_regicor <- tail(epic_regicor, -6)
# colnames(epic_regicor) <- epic_regicor[1,]
# epic_regicor <- tail(epic_regicor, -1)
# epic_regicor <- epic_regicor[str_detect(epic_regicor$Sample_Name, "A22*"),]
# rownames(epic_regicor) <- NULL
# 
# vect <- c()
# for(i in 1:length(epic_regicor$Sample_Name)){
#   vect[i] <- substr(epic_regicor[i,1],7,11)
# }
# 
# vect <- as.numeric(vect)
# epic_regicor$parti <- vect
# epic_regicor <- epic_regicor[,c(1,19,20,5)]
# 
# # changin names of column to make them similar 
# 
# colnames(epic_regicor)[1] <- "Sample_ID"
# colnames(r_fusion)[3] <- "barcode"
# colnames(r_fusion)[4] <- "Pool_ID"
# r_fusion <- r_fusion[,c(1,3,2,4)]
# 
# regicor_ids <- rbind(epic_regicor, r_fusion)
# save(regicor_ids, file = "/Estudis/B64_DIAMETR/Dades/regicor_ids.RData")


## EPIC 1 (391 from which 195 are A22 study)

load("/Estudis/B64_DIAMETR/Analisis/metiam_391_Methylset.RData")ç
# probes
epic1_ids <- as.data.frame(probes@colData@listData[["Sample_Name"]])
vect_epic1 <- c()
for(i in 1:length(epic1_ids$`probes@colData@listData[["Sample_Name"]]`)){
  vect_epic1[i] <- substr(epic1_ids[i,1],7,11)
}
vect_epic1 <- as.numeric(vect_epic1)
epic1_ids$parti <- vect_epic1
colnames(epic1_ids)[1] <-"Sample_ID"
epic1_ids <- epic1_ids[startsWith(epic1_ids$Sample_ID, "A22"),]


## EPIC 2 (208 from which 103 are A22 study)
load("/Estudis/B64_DIAMETR/Analisis/metiam_data_ext_208.RData")
# data_ext

epic2_ids <- as.data.frame(data_ext@colData@listData[["Sample_Name"]])
vect_epic2 <- c()
for(i in 1:length(epic2_ids$`data_ext@colData@listData[["Sample_Name"]]`)){
  vect_epic2[i] <- substr(epic2_ids[i,1],7,11)
}
vect_epic2 <- as.numeric(vect_epic2)
epic2_ids$parti <- vect_epic2
colnames(epic2_ids)[1] <-"Sample_ID"
epic2_ids <- epic2_ids[startsWith(epic2_ids$Sample_ID, "A22"),]

epic_ids <- rbind(epic1_ids, epic2_ids)
epic_ids$Pool_ID <- "EPIC"



regicor_ids <- rbind(epic_ids, r_fusion)
save(regicor_ids, file ="/Estudis/B64_DIAMETR/Dades/regicor_ids.RData")

#########  #########  #########  #########  #########  #########  #########  #########
############################### WHI ############################################
#########  #########  #########  #########  #########  #########  #########  #########






#########  #########  #########  #########  #########  #########  #########  #########
############################### FHS ############################################
#########  #########  #########  #########  #########  #########  #########  #########
