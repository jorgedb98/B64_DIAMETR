#merging both mt dataframes for epic
epic208 <- get(load("/home/jdominguez1/meth/regicor_mvals_epic_z_t_208.RData"))
epic391 <- get(load("/home/jdominguez1/meth/regicor_mvals_epic_z_t_391.RData"))
names_391 <- names(epic391)
names_208 <- names(epic208)
names_common <- intersect(names_208, names_391)

epic208_s <- epic208[,names_common]
epic391_s <- epic391[,names_common]

# load pheno for epic
pheno_epic <- get(load("/home/jdominguez1/B64_DIAMETR/Dades/REGICOR/metildiet_with_cells_and_rightVars_epic.RData"))
pheno_epic_slide <- pheno_epic$sample_name

epic208_s <- epic208_s[which(rownames(epic208_s)%in%pheno_epic$sample_name==T),]
epic391_s <- epic391_s[which(rownames(epic391_s)%in%pheno_epic$sample_name==T),]

epic_total <- rbind(epic208_s, epic391_s)
save(epic_total, file = "/home/jdominguez1/meth/epic_total_mtval.RData")
