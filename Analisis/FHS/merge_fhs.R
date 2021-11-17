## Merging FHS dataframes

load("U:/Estudis/B64_DIAMETR/Dades/FHS/pheno_FHS_analysis.RData")
# pheno_fhs

# Only want the cells and the shareid
pheno_fhsVars <- pheno_fhs[,c(1,2,33:38)]

# merge with food information
load("U:/Estudis/B64_DIAMETR/Dades/FHS/phenofood_fhs.RData")
# phenofood_fhs
fhs_diet_with_cells <- merge(pheno_fhsVars,phenofood_fhs, by="shareid" )
names

# [1] "shareid"         "slide.x"         "CD8T.x"          "CD4T.x"          "NK.x"           
# [6] "Bcell.x"         "Mono.x"          "Gran.x"          "sex"             "slide.y"        
# [11] "age"             "tot_chol"        "hdl_chol"        "trig"            "glucose"        
# [16] "creatini"        "ldl_chol"        "sbp1"            "dbp1"            "sbp2"           
# [21] "dbp2"            "medita"          "medicol"         "smoke_start"     "smoke_end"      
# [26] "weight1"         "height1"         "waist_u1"        "waist_i1"        "sbp"            
# [31] "dbp"             "weight"          "height"          "waist_u"         "waist_i"        
# [36] "smoke"           "euc1"            "euc2"            "sample_plate"    "CD8T.y"         
# [41] "CD4T.y"          "NK.y"            "Bcell.y"         "Mono.y"          "Gran.y"         
# [46] "NUT_CALOR"       "mds_cereal"      "mds_fish"        "mds_meat"        "mds_veg"        
# [51] "mds_fruit"       "mds_dairy"       "mds_legume"      "mds_mufasfa"     "mds_alcohol"    
# [56] "mds"             "mmds_wgrain"     "mmds_fish"       "mmds_meat"       "mmds_veg"       
# [61] "mmds_fruit"      "mmds_nut"        "mmds_legume"     "mmds_mufasfa"    "mmds_alcohol"   
# [66] "mmds"            "rmed_cereals"    "rmed_fish"       "rmed_meat"       "rmed_dairy"     
# [71] "rmed_veg"        "rmed_fruit"      "rmed_legumes"    "rmed_oliveoil"   "rmed_alcohol"   
# [76] "rmed"            "hdi2015_sfa"     "hdi2015_pufa"    "hdi2015_sugar"   "hdi2015_fat"    
# [81] "hdi2015_k"       "hdi2015_fv"      "hdi2015_fib"     "hdi2015"         "dash_wholegrain"
# [86] "dash_sweetbev"   "dash_lfdairy"    "dash_fruit"      "dash_veg"        "dash_legnut"    
# [91] "dash_meat"       "dash_na"         "dashf"           "hpdi_fruit"      "hpdi_veg"       
# [96] "hpdi_nut"        "hpdi_legume"     "hpdi_oil"        "hpdi_coft"       "hpdi_fruitjuice"
# [101] "hpdi_refgrain"   "hpdi_potato"     "hpdi_sweet"      "hpdi_anifat"     "hpdi_dairy"     
# [106] "hpdi_egg"        "hpdi_fish"       "hpdi_meat"       "hpdi" 

## Get the variables needed

fhs_diet_with_cellsVars <- fhs_diet_with_cells[,c(1:9,11:38,56,66,76,84,93,109)]
names(fhs_diet_with_cellsVars)
names(fhs_diet_with_cellsVars) <- c("shareid","Slide","CD8T","CD4T","NK","Bcell","Mono","Gran","sex","age",
                                    "tot_chol","hdl_chol","trig","glucose","creatini","ldl_chol","sbp1",
                                    "dbp1","sbp2","dbp2","medita","medicol","smoke_start","smoke_end","weight1",
                                    "height1","waist_u1","waist_i1","sbp","dbp","weight","height","waist_u","waist_i",
                                    "smoke","euc1","euc2","mds","mmds","rmed","hdi2015","dashf","hpdi")

## Add family ID
load("U:/Estudis/B64_DIAMETR/Dades/FHS/framingham_byFamilyID.RData")
# framingham_family
fhs_diet_with_cellsVars_fam <- merge(fhs_diet_with_cellsVars, framingham_family, by="shareid")
# remove people having NA in scores 

library(tidyr)
fhs_diet_with_cellsVars_fam <- fhs_diet_with_cellsVars_fam  %>% drop_na(c(mds,mmds,rmed,hdi2015,dashf,hpdi))
fhs_diet_with_cellsVars_fam <- fhs_diet_with_cellsVars_fam[,-48]
names(fhs_diet_with_cellsVars_fam)[9] <- "sex"
save(fhs_diet_with_cellsVars_fam, file = "U:/Estudis/B64_DIAMETR/Dades/FHS/fhs_diet_cellsVarsFam.RData")
