## Merging REGICOR dataframes

load("/Estudis/B64_DIAMETR/Dades/REGICOR/phenotype_regicor_all6352.Rdata")
# metildiet

# Import mother dataframe for substrtating thos individuals with studied methylation
load("/Estudis/B64_DIAMETR/Dades/REGICOR/regicor_ids.RData")
metildiet_subset <- merge(regicor_ids, metildiet, by="parti")

load("/Estudis/B64_DIAMETR/Analisis/REGICOR/database_regicor.RData")
load("/Estudis/B64_DIAMETR/Analisis/REGICOR/450_with_barcode.RData")
r_fusion <- r_fusion[,c(1,3)]
colnames(r_fusion)[2] <- "Slide"
cells_450 <- regicor
cells_450 <- merge(cells_450, r_fusion, by="Slide")
cells_450 <- cells_450[, c(1,15,5,c(6:13))]

load("/Estudis/B64_DIAMETR/Analisis/REGICOR/regicorEPIC_cells.RData")
cells_EPIC <- pheno
cells_EPIC <- cells_EPIC[,c(1,2,11,c(5:10),18,19)]
colnames(cells_EPIC) <- colnames(cells_450)

cells_REGICOR <- rbind(cells_450, cells_EPIC)
cells_REGICOR <- cells_REGICOR[,-c(1,10,11)]
metildiet_subset_cells <- merge(cells_REGICOR, metildiet_subset, by="Sample_ID")

save(metildiet_subset_cells, file = "/Estudis/B64_DIAMETR/Dades/metildiet_with_cells.RData")
