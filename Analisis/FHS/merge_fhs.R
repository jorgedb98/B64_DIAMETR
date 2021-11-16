## Merging FHS dataframes

load("U:/Estudis/B64_DIAMETR/Dades/FHS/pheno_FHS_analysis.RData")
# pheno_fhs

# Only want the cells and the shareid
pheno_fhsVars <- pheno_fhs[,c(1,2,33:38)]

# merge with food information
load("U:/Estudis/B64_DIAMETR/Dades/FHS/phenofood_fhs.RData")
# phenofood_fhs
fhs_diet_with_cells <- merge(pheno_fhsVars,phenofood_fhs, by="shareid" )
names(fhs_diet_with_cells)
# [1] "shareid"         "CD8T.x"          "CD4T.x"          "NK.x"            "Bcell.x"        
# [6] "Mono.x"          "Gran.x"          "sex"             "slide"           "age"            
# [11] "tot_chol"        "hdl_chol"        "trig"            "glucose"         "creatini"       
# [16] "ldl_chol"        "sbp1"            "dbp1"            "sbp2"            "dbp2"           
# [21] "medita"          "medicol"         "smoke_start"     "smoke_end"       "weight1"        
# [26] "height1"         "waist_u1"        "waist_i1"        "sbp"             "dbp"            
# [31] "weight"          "height"          "waist_u"         "waist_i"         "smoke"          
# [36] "euc1"            "euc2"            "sample_plate"    "CD8T.y"          "CD4T.y"         
# [41] "NK.y"            "Bcell.y"         "Mono.y"          "Gran.y"          "NUT_CALOR"      
# [46] "mds_cereal"      "mds_fish"        "mds_meat"        "mds_veg"         "mds_fruit"      
# [51] "mds_dairy"       "mds_legume"      "mds_mufasfa"     "mds_alcohol"     "mds"            
# [56] "mmds_wgrain"     "mmds_fish"       "mmds_meat"       "mmds_veg"        "mmds_fruit"     
# [61] "mmds_nut"        "mmds_legume"     "mmds_mufasfa"    "mmds_alcohol"    "mmds"           
# [66] "rmed_cereals"    "rmed_fish"       "rmed_meat"       "rmed_dairy"      "rmed_veg"       
# [71] "rmed_fruit"      "rmed_legumes"    "rmed_oliveoil"   "rmed_alcohol"    "rmed"           
# [76] "hdi2015_sfa"     "hdi2015_pufa"    "hdi2015_sugar"   "hdi2015_fat"     "hdi2015_k"      
# [81] "hdi2015_fv"      "hdi2015_fib"     "hdi2015"         "dash_wholegrain" "dash_sweetbev"  
# [86] "dash_lfdairy"    "dash_fruit"      "dash_veg"        "dash_legnut"     "dash_meat"      
# [91] "dash_na"         "dashf"           "hpdi_fruit"      "hpdi_veg"        "hpdi_nut"       
# [96] "hpdi_legume"     "hpdi_oil"        "hpdi_coft"       "hpdi_fruitjuice" "hpdi_refgrain"  
# [101] "hpdi_potato"     "hpdi_sweet"      "hpdi_anifat"     "hpdi_dairy"      "hpdi_egg"       
# [106] "hpdi_fish"       "hpdi_meat"       "hpdi"  

## Get the variables needed

fhs_diet_with_cellsVars <- fhs_diet_with_cells[,c(1:9,10:37,55,65,70,83,92,108)]
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
save(fhs_diet_with_cellsVars_fam, file = "U:/Estudis/B64_DIAMETR/Dades/FHS/fhs_diet_cellsVarsFam.RData")
