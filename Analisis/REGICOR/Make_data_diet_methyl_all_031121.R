############ DATA MANAGMENT DIAMETR study ######################
# Camille Lassale, 15th September 2021

##load library
library(data.table)
library(tableone)
library(prettyR)
library(lme4)
library(corrplot)
library(psy)
library(binom)
library(lattice)
library(MASS)
library(ggplot2)
library(mice)
library(MCMCglmm)
library(lmerTest)
library(digest)
library(survival)
library(epiR)
library(binom)
library(questionr)
library(ordinal)       
library(nnet) 
library(oddsratio)
library(broom)
library(Hmisc)
library(compareGroups)
library(plyr)
library(dplyr)
library(purrr)
library(lmerTest)
library(haven)
library(sjPlot)
library(tidyverse)
library(psych)

rm(list=ls())


#### LOAD THE DATABASES

# Dataset with all participants in the A22 Hermes cohort of the REGICOR study (recruitment 17 Mar 2003 - 18 Nov 2006)
# N=6352
# includes:
# demographic, clinic, biomarkers, lifestyle, dietary data at baseline with the suffix "_b" 
# demographic, clinic, biomarkers, lifestyle, dietary data at follow-up (A72 study, 29 May 2007 - 29 Nov 2013) with the suffix "_s1"
load("U:/Estudis/B64_DIAMETR/Dades/TELEFORM/lectura_datos/20210507_Camille/dades_20210702.Rdata")
# dataset "fusion"



# merge
metildiet<-fusion


###########################################  
 ### Time between baseline and visit 1 ###
###########################################

table(metildiet$datinclu_b) #Basal: 26 Mar 2003 - 30 Sep 2006
table(metildiet$datcensura)
table(metildiet$dexam_s1) #Seguimiento: 14 Apr 2009 - 22 Oct 2013

metildiet$fupd = with(metildiet,as.numeric(difftime(dexam_s1, datinclu_b, units = "days")))
summary(metildiet$fupd)
metildiet$fupy <- metildiet$fupd/365.25
summary(metildiet$fupy) 
#   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#  3.775   5.399   5.741   6.158   6.382  10.185


############################################################################
############################################################################
############################################################################

            ############################################
                          #### DIET ####
            ############################################

############################################################################
############################################################################
############################################################################

############################################################################
            ##             AT BASELINE (_b)           ## 
############################################################################
###### Exclusion of energy under and over reporters: 

# Initially we used
# Women: <600 kcal or >=3500 kcal
# Men: <800 kcal or >=4000 kcal

# Modification of 10 Nov 2021 
# Less strict: we apply Framingham's validity criteria 600 - 4200 kcal for men, 600 - 4000 kcal for women
summary(metildiet$kcal_b)

metildiet$kcal_b<-as.numeric(with(metildiet,ifelse(sexe==0,
                                             ifelse(kcal_b<600,NA,metildiet$kcal_b),
                                             ifelse(kcal_b<600,NA,metildiet$kcal_b))))
metildiet$kcal_b<-as.numeric(with(metildiet,ifelse(sexe==0,
                                             ifelse(kcal_b>=4200,NA,metildiet$kcal_b),
                                             ifelse(kcal_b>=4000,NA,metildiet$kcal_b))))
boxplot.stats(metildiet$kcal_b)$out
boxplot(metildiet$kcal_b)
summary(metildiet$kcal_b)
#     Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
#    602.2  1947.9  2379.9  2420.4  2858.9  4198.1     305 


metildiet %>% group_by(sexe) %>% 
  summarise(min=min(kcal_b, na.rm=T),max=max(kcal_b, na.rm=T),mean=mean(kcal_b, na.rm=T),median=median(kcal_b, na.rm=T))

###### We set as NA the micro and macronutrients when kcal is NA

#names(metildiet)
vars02<-c("cho_b","proteina_b","grasa_b","saturada_b","monosat_b","poliinsa_b","choleste_b","fibra_b","vita_b","vitd_b","b1_b","b2_b",
          "b3_b","vitc_b","vite_b","vitb6_b","b12_b","b5_b","biotina_b","vitk_b","sodio_b","potasio_b","calcio_b","magnesio_b","fosforo_b",
          "azufre_b","cloro_b","hierro_b","cobre_b","zinc_b","iodo_b","manganes_b","selenio_b")



for(i in 1:length(vars02))
  
{
  metildiet[,vars02[i]]<-as.numeric(with(metildiet,ifelse(is.na(metildiet$kcal_b),NA,metildiet[,vars02[i]])))
}

summary(metildiet$cho_b)


###### Replace the NAs of the food groups by 0 if we have valid energy intake

vars01<-c("leche_en_b","leche_sd_b","leche_ds_b","cafe_sol_b","cortado_b","cafe_lec_b","colacao_b","leche_sj_b",
          "yogur_en_b","yogur_sd_b","yogur_dn_b","queso_bl_b","queso_mn_b","brie_b","queso_az_b","requeson_b",
          "nata_b","helado_b","natillas_b","queso_pr_b","cornflk_b","musli_b","avena_cp_b","magdalen_b",
          "croissan_b","ensaimad_b","donut_b","galletas_b","pan_blnc_b","pan_int_b","pan_pay_b","bocd_st_b",
          "bocd_ct_b","tostadas_b","pasta_b","pasta_in_b","arroz_bl_b","arroz_in_b","pizza_b","canelon_b",
          "paella_b","croqueta_b","lechuga_b","escarola_b","endivias_b","col__b","col_brus_b","broculi_b",
          "coliflor_b","judias_v_b","tomate_b","zanahor_b","habas_b","acelgas_b","pimiento_b","pepinos_b",
          "guisante_b","berenjen_b","cebollas_b","esparr_f_b","setas_b","pat_cocd_b","pat_frit_b","pat_chip_b",
          "pure_pat_b","aguacate_b","espinaca_b","sopa_b","judias_b_b","garbanzo_b","lentejas_b","jamon_s_b",
          "jamon_d_b","fuet_b","mortadel_b","pates_b","btf_bl_b","bacon_b","ac_oliva_b","ac_ol_ex_b",
          "ac_oruj_b","ac_gira_b","ac_soja_b","ac_maiz_b","margarin_b","mantequi_b","manteca_b","ketchup_b",
          "mahonesa_b","huevos_b","terner_m_b","terner_g_b","buey_b","cerdo_mg_b","cerdo_gr_b","butifar_b",
          "pechuga_b","pollo_b","conejo_b","caza_b","cordero_b","higado_b","rinones_b","sesos_b",
          "hamburg_b","pescad_b_b","salmon_b","trucha_b","sardinas_b","atun_frs_b","caballa_b","mejillon_b",
          "calamar_b","gambas_b","hamb_mc_b","cheesbur_b","big_mac_b","pat_mcd_b","atun_ac_b","atun_es_b",
          "sardn_ac_b","sardn_es_b","almejas_b","brbrchs_b","anchoas_b","esparrag_b","naranja_b","platano_b",
          "manzana_b","pera_b","melocotn_b","limon_b","melon_b","sandia_b","uva_b","fresas_b",
          "ciruelas_b","almibar_b","macedon_b","kiwi_b","higos_b","olivas_b","almendra_b","avellana_b",
          "cacahuet_b","pistacho_b","nueces_b","datiles_b","chocolat_b","pastel_b","sal_b","azucar_b",
          "bebidas_b","te_negro_b","zumo_nrj_b","zumo_tmt_b","zumo_mlc_b","zumo_uva_b","zumo_mnz_b","cervez_s_b",
          "cervez_c_b","vino_tn_b","vino_bl_b","cava_b","destilad_b","licores_b")

  
  
for(i in 1:length(vars01))
  
{
  metildiet[,vars01[i]]<-as.numeric(with(metildiet,ifelse(is.na(metildiet$kcal_b),NA,
                                         ifelse(is.na(metildiet[,vars01[i]]),0,metildiet[,vars01[i]]))))
}

# Calculate the sugar intake
sugarvar<-c("leche_en_sug_b","leche_sd_sug_b","leche_ds_sug_b","cafe_sol_sug_b","cortado_sug_b","cafe_lec_sug_b","colacao_sug_b","leche_sj_sug_b",
          "yogur_en_sug_b","yogur_sd_sug_b","yogur_dn_sug_b","queso_sug_bl_sug_b","queso_mn_sug_b","brie_sug_b","queso_az_sug_b","requeson_sug_b",
          "nata_sug_b","helado_sug_b","natillas_sug_b","queso_pr_sug_b","cornflk_sug_b","musli_sug_b","avena_cp_sug_b","magdalen_sug_b",
          "croissan_sug_b","ensaimad_sug_b","donut_sug_b","galletas_sug_b","pan_sug_blnc_sug_b","pan_int_sug_b","pan_pay_sug_b","bocd_st_sug_b",
          "bocd_ct_sug_b","tostadas_sug_b","pasta_sug_b","pasta_in_sug_b","arroz_sug_bl_sug_b","arroz_in_sug_b","pizza_sug_b","canelon_sug_b",
          "paella_sug_b","croqueta_sug_b","lechuga_sug_b","escarola_sug_b","endivias_sug_b","col__sug_b","col_sug_brus_sug_b","broculi_sug_b",
          "coliflor_sug_b","judias_v_sug_b","tomate_sug_b","zanahor_sug_b","habas_sug_b","acelgas_sug_b","pimiento_sug_b","pepinos_sug_b",
          "guisante_sug_b","berenjen_sug_b","cebollas_sug_b","esparr_f_sug_b","setas_sug_b","pat_cocd_sug_b","pat_frit_sug_b","pat_chip_sug_b",
          "pure_pat_sug_b","aguacate_sug_b","espinaca_sug_b","sopa_sug_b","judias_sug_b_sug_b","garbanzo_sug_b","lentejas_sug_b","jamon_s_sug_b",
          "jamon_d_sug_b","fuet_sug_b","mortadel_sug_b","pates_sug_b","btf_sug_bl_sug_b","bacon_sug_b","ac_oliva_sug_b","ac_ol_ex_sug_b",
          "ac_oruj_sug_b","ac_gira_sug_b","ac_soja_sug_b","ac_maiz_sug_b","margarin_sug_b","mantequi_sug_b","manteca_sug_b","ketchup_sug_b",
          "mahonesa_sug_b","huevos_sug_b","terner_m_sug_b","terner_g_sug_b","buey_sug_b","cerdo_mg_sug_b","cerdo_gr_sug_b","butifar_sug_b",
          "pechuga_sug_b","pollo_sug_b","conejo_sug_b","caza_sug_b","cordero_sug_b","higado_sug_b","rinones_sug_b","sesos_sug_b",
          "hamburg_sug_b","pescad_sug_b_sug_b","salmon_sug_b","trucha_sug_b","sardinas_sug_b","atun_frs_sug_b","caballa_sug_b","mejillon_sug_b",
          "calamar_sug_b","gambas_sug_b","hamb_mc_sug_b","cheesbur_sug_b","big_mac_sug_b","pat_mcd_sug_b","atun_ac_sug_b","atun_es_sug_b",
          "sardn_ac_sug_b","sardn_es_sug_b","almejas_sug_b","brbrchs_sug_b","anchoas_sug_b","esparrag_sug_b","naranja_sug_b","platano_sug_b",
          "manzana_sug_b","pera_sug_b","melocotn_sug_b","limon_sug_b","melon_sug_b","sandia_sug_b","uva_sug_b","fresas_sug_b",
          "ciruelas_sug_b","almibar_sug_b","macedon_sug_b","kiwi_sug_b","higos_sug_b","olivas_sug_b","almendra_sug_b","avellana_sug_b",
          "cacahuet_sug_b","pistacho_sug_b","nueces_sug_b","datiles_sug_b","chocolat_sug_b","pastel_sug_b","sal_sug_b","azucar_sug_b",
          "bebidas_sug_b","te_negro_sug_b","zumo_nrj_sug_b","zumo_tmt_sug_b","zumo_mlc_sug_b","zumo_uva_sug_b","zumo_mnz_sug_b","cervez_s_sug_b",
          "cervez_c_sug_b","vino_tn_sug_b","vino_sug_bl_sug_b","cava_sug_b","destilad_sug_b","licores_sug_b")
sugar<-c(4.6,	4.6,	4.6,	0.4,	1.1,	3.65,	9.1,	2.8,	2.6,	4.8,	5.1,	0.3,	0.5,	1,	0.9,	2.8,	3.4,	21,	15.5,	0.3,	9.6,	26.2,	1.3,	28,
         8.7,	8.7,	15,	25.8,	2.2,	1.7,	1.8,	1.8,	2.36,	2.1,	0.4,	0.8,	0,	0.5,	2.5,	3,	1.3,	6,	2.2,	0.7,	1.5,	3,	2.9,	1.4,	1.8,
         2.4,	3,	3.8,	1.82,	1.1,	3.8,	1.4,	5.9,	3.2,	5.2,	1.3,	0.2,	0.8,	0.6,	1.5,	1.3,	0.6,	2.1,	0.6,	1.3,	1.4,	1.3,	0.2,	0.4,
         0,	0,	1,	2.8,	0.4,	0,	0,	0,	0,	0,	0,	0.1,	1.3,	0,	18.3,	1.8,	0.9,	0,	0,	0,	0,	0,	2.8,	0,	0,	0,	0,	0,	0,	0,	0,	0,
         0,	0,	0,	0,	0,	0,	0,	0.5,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0.6,	1.3,	8.5,	16.2,	11.8,	10.4,	11.3,	2.9,	7.25,	6.3,	16,	
         5.3,	11,	21.5,	12,	8.9,	12.3,	0.25,	4,	4.3,	4,	7.8,	4,	58,	47.7,	25,	0,	100,	10.5,	0,	10.2,	2.7,	13.9,	15,	10.5,	2.2,	0.8,	0.4,	
         0.5,	1.4,	0,	21)

for(i in 1:length(vars01))
{
  metildiet[,sugarvar[i]]<-as.numeric(metildiet[,vars01[i]]*sugar[i]/100)
}

metildiet$sugar_b <- apply(metildiet[,sugarvar],1,sum,na.rm=F) 

boxplot(metildiet$sugar_b)
summary(metildiet$sugar_b)
summary(metildiet$cho_b)
summary(metildiet$zumo_nrj_sug_b)


########    CREATE FOOD GROUPS     ########

########    1. ANIMAL PRODUCTS     ####

    #### MEAT ####

metildiet$redmeat_b    <- with(metildiet,bacon_b + butifar_b + btf_bl_b + buey_b + cerdo_gr_b + cerdo_mg_b + cordero_b + terner_g_b + terner_m_b +
                            fuet_b + hamburg_b + higado_b + jamon_d_b + jamon_s_b + pates_b + sesos_b  + mortadel_b)
metildiet$poultry_b    <- with(metildiet,conejo_b  + pechuga_b + pollo_b)
metildiet$meat_b       <- with(metildiet,poultry_b+redmeat_b)
summary(metildiet$redmeat_b , useNA = "always")
summary(metildiet$poultry_b , useNA = "always")
summary(metildiet$meat_b , useNA = "always")

    #### FISH ####

metildiet$fish_b       <- with(metildiet,almejas_b + anchoas_b + atun_frs_b + atun_ac_b + atun_es_b +  brbrchs_b + caballa_b + calamar_b +  gambas_b +
                            mejillon_b + pescad_b_b + salmon_b + sardinas_b + sardn_es_b + sardn_ac_b + trucha_b)
summary(metildiet$fish_b , useNA = "always")

#Fresh and frozen fish only
metildiet$ffish_b       <- with(metildiet, atun_frs_b +  caballa_b + calamar_b +  gambas_b + mejillon_b + pescad_b_b + salmon_b + sardinas_b + trucha_b)
summary(metildiet$ffish_b , useNA = "always")

    #### DAIRY ####

metildiet$milk_b       <- with(metildiet,colacao_b + leche_en_b  +  leche_ds_b + leche_sd_b + 0.60*cafe_lec_b)
metildiet$yoghurt_b    <- with(metildiet,helado_b  + natillas_b + yogur_en_b  + nata_b + yogur_dn_b  + yogur_sd_b )
metildiet$cheese_b     <- with(metildiet,brie_b + queso_bl_b +  queso_az_b + queso_pr_b + queso_mn_b + requeson_b)
metildiet$dairy_b      <- with(metildiet,milk_b+yoghurt_b+cheese_b)
summary(metildiet$milk_b , useNA = "always")
summary(metildiet$yoghurt_b , useNA = "always")
summary(metildiet$cheese_b , useNA = "always")
summary(metildiet$dairy_b , useNA = "always")
# low fat dairy
metildiet$lfdairy_b <-with(metildiet,leche_ds_b + leche_sd_b  + yogur_dn_b  + yogur_sd_b + queso_bl_b)
summary(metildiet$lfdairy_b , useNA="always")

    #### ANIMAL FAT ####

metildiet$anifat_b       <- with(metildiet,manteca_b + mantequi_b)


    #### MISCELLANEOUS ANIMAL FOOD: Spanish food and fast food hamburgers ####

metildiet$animal_b       <- with(metildiet,0.35*paella_b+0.70*canelon_b+croqueta_b+pizza_b+hamb_mc_b+cheesbur_b+big_mac_b)

########   2. PLANT PRODUCTS     ####

    #### CEREALS ####

metildiet$bread_b      <- with(metildiet,pan_int_b + pan_blnc_b + pan_pay_b   + tostadas_b + bocd_ct_b + bocd_st_b )
metildiet$bkcereals_b  <- with(metildiet,avena_cp_b + cornflk_b + musli_b )
# We include rice and pasta from paella and canelones, approximately 65% of rice in paella, approx 30% of pasta in canelones
metildiet$ricepasta_b  <- with(metildiet,arroz_bl_b + arroz_in_b + pasta_b + pasta_in_b + 0.65*paella_b + 0.30*canelon_b)
metildiet$cereals_b    <- with(metildiet,bread_b+bkcereals_b+ricepasta_b)

summary(metildiet$bread_b, useNA = "always")
summary(metildiet$bkcereals_b, useNA = "always")
summary(metildiet$ricepasta_b, useNA = "always")
summary(metildiet$cereals_b , useNA = "always")

# Whole grain
metildiet$wholegrain_b <- with(metildiet,avena_cp_b + cornflk_b + musli_b + pan_int_b + arroz_in_b + pasta_in_b)
summary(metildiet$wholegrain_b , useNA = "always")

# Refined grain
metildiet$refgrain_b    <- with(metildiet,cereals_b-wholegrain_b)
summary(metildiet$refgrain_b)

    #### VEGETABLES ####

metildiet$veg_b        <- with(metildiet,acelgas_b + berenjen_b  + esparrag_b + esparr_f_b + espinaca_b + habas_b  + judias_v_b + zanahor_b + #cooked veg#
                              broculi_b + col__b + col_brus_b + coliflor_b +setas_b + #cabbage and mushrooms # 
                              cebollas_b + endivias_b + escarola_b +  pepinos_b + pimiento_b + lechuga_b + tomate_b ) #raw veg# 
summary(metildiet$veg_b , useNA = "always")
    

    #### POTATOES ####

metildiet$potato_b     <- with(metildiet,pat_cocd_b +  pure_pat_b + pat_frit_b + pat_chip_b + pat_mcd_b)
metildiet$potatofried_b     <- with(metildiet,pat_frit_b + pat_chip_b + pat_mcd_b)
metildiet$potatohealthy_b     <- with(metildiet,pat_cocd_b +  pure_pat_b )
summary(metildiet$potato_b , useNA = "always")



    #### FRUITS & NUTS ####

metildiet$fruit_b      <- with(metildiet,ciruelas_b +  fresas_b + almibar_b +  kiwi_b + limon_b + aguacate_b +
                              macedon_b + melocotn_b + melon_b + naranja_b + pera_b + platano_b + sandia_b + uva_b + manzana_b + higos_b)
metildiet$nut_b        <- with(metildiet,avellana_b + cacahuet_b + datiles_b + nueces_b + pistacho_b + almendra_b)
metildiet$fruitnut_b   <- with(metildiet,fruit_b+nut_b)
summary(metildiet$fruit_b , useNA = "always")
summary(metildiet$nut_b , useNA = "always")
summary(metildiet$fruitnut_b , useNA = "always")

# Fruit juice
metildiet$fruitjuice_b      <- with(metildiet,zumo_nrj_b + zumo_tmt_b +zumo_mlc_b +zumo_uva_b +zumo_mnz_b)
summary(metildiet$fruitjuice_b , useNA = "always")

# A variable "fruit" with fruit juice up to 100 mL
metildiet$fruittot_b      <- with(metildiet,ifelse(fruitjuice_b>=100,fruit_b+100,fruit_b+fruitjuice_b))
summary(metildiet$fruittot_b , useNA = "always")

metildiet$fruitnuttot_b      <- with(metildiet,fruittot_b+nut_b)
summary(metildiet$fruitnuttot_b , useNA = "always")

#Fruit and fruit juice for the DASH score
metildiet$fruitdash_b <-with(metildiet,fruit_b+fruitjuice_b)


    #### LEGUMES ####

metildiet$legumes_b    <- with(metildiet,garbanzo_b + guisante_b + lentejas_b + judias_b_b)

#legumes and nuts for the DASH score
metildiet$legumenut_b<-with(metildiet,legumes_b+nut_b)


    #### OLIVE OIL ####

metildiet$mufasfa_b    <- with(metildiet,monosat_b/saturada_b)
metildiet$oliveoil_b   <- with(metildiet,ac_oliva_b +ac_ol_ex_b +ac_oruj_b)

summary(metildiet$legumes_b , useNA = "always")
summary(metildiet$mufasfa_b , useNA = "always")
summary(metildiet$oliveoil_b , useNA = "always")


    #### VEGETABLE OIL ####

metildiet$oil_b   <- with(metildiet,oliveoil_b+ac_gira_b+ac_soja_b+ac_maiz_b )


    #### COFFEE AND TEA ####

metildiet$coffeetea_b   <- with(metildiet,cafe_sol_b + cortado_b + cafe_lec_b + te_negro_b)


    #### SWEET AND DESSERT ####

metildiet$sweet_b   <- with(metildiet,magdalen_b+croissan_b+ensaimad_b+donut_b+chocolat_b+azucar_b+galletas_b + pastel_b)

                             
########    3. ALCOHOL     ####

#the ethanol content in g/day in alcoholic drinks
metildiet$ethanol_b    <- with(metildiet,cervez_c_b*0.05+ 0.115*(vino_tn_b  + vino_bl_b + cava_b) + 0.40*(destilad_b + licores_b) )
summary(metildiet$ethanol_b , useNA = "always")
summary(metildiet$kcal_b , useNA = "always")


metildiet$alcoholdrink_b    <- with(metildiet,cervez_c_b + vino_tn_b  + vino_bl_b + cava_b + destilad_b + licores_b)
summary(metildiet$alcoholdrink_b , useNA = "always")

########    4. Soft drinks     ####

metildiet$ssb_b        <- with(metildiet,fruitjuice_b+bebidas_b)
summary(metildiet$ssb_b , useNA = "always")


############################################################################

#############     Calculation of the DIET SCORES     ###################

############################################################################

##################################################################################
#############   1. MDS  - Trichopoulou 0-9, based on median of intake   ##########
##################################################################################

# Sex-specific medians and quartiles
medians<-ddply(metildiet, .(sexe), summarise, 
      med_cereals_b=median(cereals_b, na.rm = T), q1_cereals_b=quantile(cereals_b,0.25, na.rm=T), q3_cereals_b=quantile(cereals_b,0.75, na.rm=T),
      med_fish_b=median(fish_b, na.rm = T), q1_fish_b=quantile(fish_b,0.25, na.rm=T), q3_fish_b=quantile(fish_b,0.75, na.rm=T),
      med_redmeat_b=median(redmeat_b, na.rm = T), q1_redmeat_b=quantile(redmeat_b,0.25, na.rm=T), q3_redmeat_b=quantile(redmeat_b,0.75, na.rm=T),
      med_veg_b=median(veg_b, na.rm = T), q1_veg_b=quantile(veg_b,0.25, na.rm=T), q3_veg_b=quantile(veg_b,0.75, na.rm=T),
      med_fruitnut_b=median(fruitnut_b, na.rm = T), q1_fruitnut_b=quantile(fruitnut_b,0.25, na.rm=T), q3_fruitnut_b=quantile(fruitnut_b,0.75, na.rm=T),
      med_fruit_b=median(fruit_b, na.rm = T), q1_fruit_b=quantile(fruit_b,0.25, na.rm=T), q3_fruit_b=quantile(fruit_b,0.75, na.rm=T),
      med_nut_b=median(nut_b, na.rm = T), q1_nut_b=quantile(nut_b,0.25, na.rm=T), q3_nut_b=quantile(nut_b,0.75, na.rm=T),
      med_dairy_b=median(dairy_b, na.rm = T), q1_dairy_b=quantile(dairy_b,0.25, na.rm=T), q3_dairy_b=quantile(dairy_b,0.75, na.rm=T),
      med_legumes_b=median(legumes_b, na.rm = T), q1_legumes_b=quantile(legumes_b,0.25, na.rm=T), q3_legumes_b=quantile(legumes_b,0.75, na.rm=T),
      med_mufasfa_b=median(mufasfa_b, na.rm = T), q1_mufasfa_b=quantile(mufasfa_b,0.25, na.rm=T), q3_mufasfa_b=quantile(mufasfa_b,0.75, na.rm=T),
      med_wholegrain_b=median(wholegrain_b, na.rm = T), q1_wholegrain_b=quantile(wholegrain_b,0.25, na.rm=T), q3_wholegrain_b=quantile(wholegrain_b,0.75, na.rm=T))

medians

# Merge the dataset according to sex
metildiet<-merge(metildiet,medians,by="sexe",all.x=TRUE,sort=FALSE)


# Creation of the 8 items according to the median
metildiet$mds_cereal_b <- with(metildiet,ifelse(cereals_b<med_cereals_b,0,1),na.rm=T)
metildiet$mds_fish_b <- with(metildiet,ifelse(fish_b<med_fish_b,0,1),na.rm=T)
metildiet$mds_meat_b <- with(metildiet,ifelse(redmeat_b>=med_redmeat_b,0,1),na.rm=T) #inverse
metildiet$mds_veg_b <- with(metildiet,ifelse(veg_b<med_veg_b,0,1),na.rm=T)
metildiet$mds_fruit_b <- with(metildiet,ifelse(fruitnut_b<med_fruitnut_b,0,1),na.rm=T) # Fruit and nuts in the score by Trichopoulou
metildiet$mds_dairy_b <- with(metildiet,ifelse(dairy_b>=med_dairy_b,0,1),na.rm=T)  #inverse
metildiet$mds_legume_b <- with(metildiet,ifelse(legumes_b<med_legumes_b,0,1),na.rm=T)
metildiet$mds_mufasfa_b <- with(metildiet,ifelse(mufasfa_b<med_mufasfa_b,0,1),na.rm=T)

table(metildiet$mds_cereal_b, useNA = "always")
table(metildiet$mds_fish_b, useNA = "always")
table(metildiet$mds_meat_b, useNA = "always")
table(metildiet$mds_veg_b, useNA = "always")
table(metildiet$mds_fruit_b, useNA = "always")
table(metildiet$mds_dairy_b, useNA = "always")
table(metildiet$mds_legume_b, useNA = "always")
table(metildiet$mds_mufasfa_b, useNA = "always")

# For the alcohol item, there are pre-defined thresholds
metildiet$mds_alcohol_b <- with(metildiet,ifelse(metildiet$sexe==0,
                                           ifelse((metildiet$ethanol_b<50 & metildiet$ethanol_b>10),1,0),
                                           ifelse((metildiet$ethanol_b<25 & metildiet$ethanol_b>5),1,0)))
table(metildiet$mds_alcohol_b, useNA = "always")

# We check that it was done correctly
# summary by sexe and mds_alcohol_b
metildiet %>% 
  group_by(sexe,mds_alcohol_b) %>% 
  summarise(minalc=min(ethanol_b, na.rm=T), 
            maxalc=max(ethanol_b, na.rm=T))
# OK #
# Another way of describing by sex and item
ddply(metildiet, .(sexe,mds_alcohol_b), summarise, meanalc=mean(ethanol_b,na.rm=T), minalc=min(ethanol_b,na.rm=T), maxalc=max(ethanol_b,na.rm=T))



##############################
# Sum total score MDS 0 to 9 #
##############################

vars02<-c("mds_cereal_b","mds_fish_b","mds_meat_b","mds_veg_b","mds_fruit_b","mds_dairy_b","mds_legume_b","mds_mufasfa_b","mds_alcohol_b")

table(metildiet$mds_cereal_b, useNA = "always")
table(metildiet$mds_fish_b, useNA = "always")
table(metildiet$mds_meat_b, useNA = "always")
table(metildiet$mds_veg_b, useNA = "always")
table(metildiet$mds_fruit_b, useNA = "always")
table(metildiet$mds_dairy_b, useNA = "always")
table(metildiet$mds_legume_b, useNA = "always")
table(metildiet$mds_mufasfa_b, useNA = "always") # 13 missing
table(metildiet$mds_alcohol_b, useNA = "always")


metildiet$mds_b <- apply(metildiet[,vars02],1,sum,na.rm=F) 
table(metildiet$mds_b, useNA = "always")
histogram(metildiet$mds_b)
mean(metildiet$mds_b,na.rm=T)



# Description by sex
# Create factor variables for use in CreateTableOne
metildiet$mds_cereal_bf <- as.factor(metildiet$mds_cereal_b)
metildiet$mds_fish_bf <- as.factor(metildiet$mds_fish_b)
metildiet$mds_meat_bf <- as.factor(metildiet$mds_meat_b)
metildiet$mds_veg_bf <- as.factor(metildiet$mds_veg_b)
metildiet$mds_fruit_bf <- as.factor(metildiet$mds_fruit_b)
metildiet$mds_dairy_bf <- as.factor(metildiet$mds_dairy_b)
metildiet$mds_legume_bf <- as.factor(metildiet$mds_legume_b)
metildiet$mds_mufasfa_bf <- as.factor(metildiet$mds_mufasfa_b)
metildiet$mds_alcohol_bf <- as.factor(metildiet$mds_alcohol_b)

vars03<-c("mds_cereal_bf","mds_fish_bf","mds_meat_bf","mds_veg_bf","mds_fruit_bf","mds_dairy_bf","mds_legume_bf","mds_mufasfa_bf","mds_alcohol_bf","mds_b")
tab <-CreateTableOne(vars03,strata="sexe",data=metildiet)
try<-print(tab,  noSpaces = TRUE)


##################################################################################
#############   2. MMDS  - Ma et al 2020, 0-25 based on quartiles        #########
##################################################################################


metildiet$mmds_wgrain_b <- with(metildiet,ifelse(wholegrain_b<=q1_wholegrain_b,0,
                                           ifelse(wholegrain_b<=med_wholegrain_b,1,
                                           ifelse(wholegrain_b<=q3_wholegrain_b,2,3))),na.rm=T)
table(metildiet$mmds_wgrain_b, useNA = "always")
metildiet$mmds_fish_b <- with(metildiet,ifelse(fish_b<=q1_fish_b,0,
                                           ifelse(fish_b<=med_fish_b,1,
                                                  ifelse(fish_b<=q3_fish_b,2,3))),na.rm=T)
table(metildiet$mmds_fish_b, useNA = "always")

metildiet$mmds_meat_b <- with(metildiet,ifelse(redmeat_b<q1_redmeat_b,3, #???inverse
                                           ifelse(redmeat_b<med_redmeat_b,2,
                                                  ifelse(redmeat_b<q3_redmeat_b,1,0))),na.rm=T)
metildiet$mmds_veg_b <- with(metildiet,ifelse(veg_b<=q1_veg_b,0,
                                           ifelse(veg_b<=med_veg_b,1,
                                                  ifelse(veg_b<=q3_veg_b,2,3))),na.rm=T)
metildiet$mmds_fruit_b <- with(metildiet,ifelse(fruit_b<=q1_fruit_b,0,
                                           ifelse(fruit_b<=med_fruit_b,1,
                                                  ifelse(fruit_b<=q3_fruit_b,2,3))),na.rm=T)
metildiet$mmds_nut_b <- with(metildiet,ifelse(nut_b<=q1_nut_b,0,
                                           ifelse(nut_b<=med_nut_b,1,
                                                  ifelse(nut_b<=q3_nut_b,2,3))),na.rm=T)
metildiet$mmds_legume_b <- with(metildiet,ifelse(legumes_b<=q1_legumes_b,0,
                                           ifelse(legumes_b<=med_legumes_b,1,
                                                  ifelse(legumes_b<=q3_legumes_b,2,3))),na.rm=T)
metildiet$mmds_mufasfa_b <- with(metildiet,ifelse(mufasfa_b<=q1_mufasfa_b,0,
                                          ifelse(mufasfa_b<=med_mufasfa_b,1,
                                                 ifelse(mufasfa_b<=q3_mufasfa_b,2,3))),na.rm=T)
table(metildiet$mmds_meat_b, useNA = "always")
table(metildiet$mmds_veg_b, useNA = "always")
table(metildiet$mmds_fruit_b, useNA = "always")
table(metildiet$mmds_nut_b, useNA = "always")
table(metildiet$mmds_legume_b, useNA = "always")
table(metildiet$mmds_mufasfa_b, useNA = "always")

metildiet %>% 
  group_by(sexe,mmds_wgrain_b) %>% 
  summarise(min=min(wholegrain_b, na.rm=T), 
            max=max(wholegrain_b, na.rm=T))

metildiet %>% 
  group_by(sexe,mmds_legume_b) %>% 
  summarise(min=min(legumes_b, na.rm=T), 
            max=max(legumes_b, na.rm=T))

metildiet %>% 
  group_by(sexe,mmds_meat_b) %>% 
  summarise(min=min(redmeat_b, na.rm=T), 
            max=max(redmeat_b, na.rm=T))


# For the alcohol item, there are pre-defined thresholds
metildiet$mmds_alcohol_b <- with(metildiet,ifelse(metildiet$sexe==0,
                                           ifelse((metildiet$ethanol_b<=25 & metildiet$ethanol_b>=10),1,0),
                                           ifelse((metildiet$ethanol_b<=15 & metildiet$ethanol_b>=5),1,0)))
table(metildiet$mmds_alcohol_b, useNA = "always")

# We check that it was done correctly
# summary by sexe and mds_alcohol_b
metildiet %>% 
  group_by(sexe,mmds_alcohol_b) %>% 
  summarise(minalc=min(ethanol_b, na.rm=T), 
            maxalc=max(ethanol_b, na.rm=T))

################################
# Sum total score MMDS 0 to 25 #
################################

vars04<-c("mmds_wgrain_b","mmds_fish_b","mmds_meat_b","mmds_veg_b","mmds_fruit_b","mmds_nut_b","mmds_legume_b","mmds_mufasfa_b","mmds_alcohol_b")

metildiet$mmds_b <- apply(metildiet[,vars04],1,sum,na.rm=F) 
table(metildiet$mmds_b, useNA = "always")
histogram(metildiet$mmds_b)
mean(metildiet$mmds_b,na.rm=T)



# Description by sex
# Create factor variables for use in CreateTableOne
metildiet$mmds_wgrain_bf <- as.factor(metildiet$mmds_wgrain_b)
metildiet$mmds_fish_bf <- as.factor(metildiet$mmds_fish_b)
metildiet$mmds_meat_bf <- as.factor(metildiet$mmds_meat_b)
metildiet$mmds_veg_bf <- as.factor(metildiet$mmds_veg_b)
metildiet$mmds_fruit_bf <- as.factor(metildiet$mmds_fruit_b)
metildiet$mmds_nut_bf <- as.factor(metildiet$mmds_nut_b)
metildiet$mmds_legume_bf <- as.factor(metildiet$mmds_legume_b)
metildiet$mmds_mufasfa_bf <- as.factor(metildiet$mmds_mufasfa_b)
metildiet$mmds_alcohol_bf <- as.factor(metildiet$mmds_alcohol_b)

vars05<-c("mmds_wgrain_bf","mmds_fish_bf","mmds_meat_bf","mmds_veg_bf","mmds_fruit_bf","mmds_nut_bf","mmds_legume_bf","mmds_mufasfa_bf","mmds_alcohol_bf","mmds_b")
tab <-CreateTableOne(vars05,strata="sexe",data=metildiet)
try<-print(tab,  noSpaces = TRUE)
#write.table(try,file="./analysis/output/mmds_by_sex_10062021.csv",sep=",")


######################################################################################################
#############   3. rMED (Buckland et al 2010), 0-18 based on tertiles energy density        #########
######################################################################################################

# Energy density in grams per 1000kcal

metildiet$cereals_be <-with(metildiet,cereals_b*1000/kcal_b)
metildiet$ffish_be <-with(metildiet,ffish_b*1000/kcal_b) # only fresh and frozen fish, not preserved
metildiet$meat_be <-with(metildiet,meat_b*1000/kcal_b) # all meat
metildiet$veg_be <-with(metildiet,veg_b*1000/kcal_b)
metildiet$fruitnut_be <-with(metildiet,fruitnut_b*1000/kcal_b) # nuts, seeds and fruit
metildiet$legumes_be <-with(metildiet,legumes_b*1000/kcal_b)
metildiet$dairy_be <-with(metildiet,dairy_b*1000/kcal_b)
metildiet$oliveoil_be <-with(metildiet,oliveoil_b*1000/kcal_b)
summary(metildiet$cereals_b)
summary(metildiet$cereals_be)
summary(metildiet$ffish_be)
summary(metildiet$meat_be)
summary(metildiet$veg_be)
summary(metildiet$fruitnut_be)
summary(metildiet$legumes_be)
summary(metildiet$dairy_be)
summary(metildiet$oliveoil_be)
tertiles<-ddply(metildiet, .(sexe), summarise, 
                t1_cereals_be=quantile(cereals_be,0.333, na.rm=T), t2_cereals_be=quantile(cereals_be,0.667, na.rm=T),
                t1_ffish_be=quantile(ffish_be,0.333, na.rm=T), t2_ffish_be=quantile(ffish_be,0.667, na.rm=T),
                t1_veg_be=quantile(veg_be,0.333, na.rm=T), t2_veg_be=quantile(veg_be,0.667, na.rm=T),
                t1_meat_be=quantile(meat_be,0.333, na.rm=T), t2_meat_be=quantile(meat_be,0.667, na.rm=T),
                t1_fruitnut_be=quantile(fruitnut_be,0.333, na.rm=T), t2_fruitnut_be=quantile(fruitnut_be,0.667, na.rm=T),
                t1_dairy_be=quantile(dairy_be,0.333, na.rm=T), t2_dairy_be=quantile(dairy_be,0.667, na.rm=T),
                t1_legumes_be=quantile(legumes_be,0.333, na.rm=T), t2_legumes_be=quantile(legumes_be,0.667, na.rm=T),
                med_oliveoil_be=median(oliveoil_be, na.rm = T),t1_oliveoil_be=quantile(oliveoil_be,0.333, na.rm=T), t2_oliveoil_be=quantile(oliveoil_be,0.667, na.rm=T))

# Merge the dataset according to sex
metildiet<-merge(metildiet,tertiles,by="sexe",all.x=TRUE,sort=FALSE)

# Creation of the 8 items according to the tertiles
metildiet$rmed_cereals_b <- with(metildiet,ifelse(cereals_be<=t1_cereals_be,0,
                                           ifelse(cereals_be<=t2_cereals_be,1,2)),na.rm=T)
table(metildiet$rmed_cereals_b, useNA = "always")
metildiet$rmed_fish_b <- with(metildiet,ifelse(ffish_be<=t1_ffish_be,0,
                                            ifelse(ffish_be<=t2_ffish_be,1,2)),na.rm=T)
# Meat is total meat (not only red meat)
metildiet$rmed_meat_b <- with(metildiet,ifelse(meat_be<=t1_meat_be,2, #inverse
                                            ifelse(meat_be<=t2_meat_be,1,0)),na.rm=T)
metildiet$rmed_dairy_b <- with(metildiet,ifelse(dairy_be<=t1_dairy_be,2, #inverse
                                            ifelse(dairy_be<=t2_dairy_be,1,0)),na.rm=T)
metildiet$rmed_fruit_b <- with(metildiet,ifelse(fruitnut_be<=t1_fruitnut_be,0,
                                            ifelse(fruitnut_be<=t2_fruitnut_be,1,2)),na.rm=T)
metildiet$rmed_veg_b <- with(metildiet,ifelse(veg_be<=t1_veg_be,0,
                                            ifelse(veg_be<=t2_veg_be,1,2)),na.rm=T)
metildiet$rmed_legumes_b <- with(metildiet,ifelse(legumes_be<=t1_legumes_be,0,
                                            ifelse(legumes_be<=t2_legumes_be,1,2)),na.rm=T)
metildiet$rmed_oliveoil_b <- with(metildiet,ifelse(oliveoil_be<=t1_oliveoil_be,0,
                                            ifelse(oliveoil_be<=t2_oliveoil_be,1,2)),na.rm=T)

# For the alcohol item, same pre-defined thresholds as MDS, score of 2 if inside the range, 0 if not
metildiet$rmed_alcohol_b <- with(metildiet,ifelse(metildiet$sexe==0,
                                           ifelse((metildiet$ethanol_b<50 & metildiet$ethanol_b>10),2,0),
                                           ifelse((metildiet$ethanol_b<25 & metildiet$ethanol_b>5),2,0)))
table(metildiet$rmed_alcohol_b, useNA = "always")


################################
# Sum total score rMED 0 to 18 #
################################

vars05<-c("rmed_cereals_b","rmed_fish_b","rmed_meat_b","rmed_dairy_b","rmed_veg_b","rmed_fruit_b","rmed_legumes_b","rmed_oliveoil_b","rmed_alcohol_b")

metildiet$rmed_b <- apply(metildiet[,vars05],1,sum,na.rm=F) 
table(metildiet$rmed_b, useNA = "always")
histogram(metildiet$rmed_b)
mean(metildiet$rmed_b,na.rm=T)

# Description by sex
# Create factor variables for use in CreateTableOne
metildiet$rmed_cereals_bf <- as.factor(metildiet$rmed_cereals_b)
metildiet$rmed_fish_bf <- as.factor(metildiet$rmed_fish_b)
metildiet$rmed_meat_bf <- as.factor(metildiet$rmed_meat_b)
metildiet$rmed_veg_bf <- as.factor(metildiet$rmed_veg_b)
metildiet$rmed_fruit_bf <- as.factor(metildiet$rmed_fruit_b)
metildiet$rmed_dairy_bf <- as.factor(metildiet$rmed_dairy_b)
metildiet$rmed_legumes_bf <- as.factor(metildiet$rmed_legumes_b)
metildiet$rmed_oliveoil_bf <- as.factor(metildiet$rmed_oliveoil_b)
metildiet$rmed_alcohol_bf <- as.factor(metildiet$rmed_alcohol_b)

vars06<-c("rmed_cereals_bf","rmed_fish_bf","rmed_meat_bf","rmed_dairy_bf","rmed_veg_bf","rmed_fruit_bf","rmed_legumes_bf","rmed_oliveoil_bf","rmed_alcohol_bf","rmed_b")
tab <-CreateTableOne(vars06,strata="sexe",data=metildiet)
try<-print(tab,  noSpaces = TRUE)


######################################################################################################
#############   4. WHO HDI 2015      #########
######################################################################################################
# Kanauchi M, Kanauchi K. Prev Med Rep. 2018;12:198-202. doi:10.1016/j.pmedr.2018.09.011

metildiet$kcal_exalc_b <-with(metildiet,kcal_b-ethanol_b*7) #Energy excluding alcohol
metildiet$p_sfa_b <-with(metildiet,900*saturada_b/kcal_exalc_b)
metildiet$p_pufa_b <-with(metildiet,900*poliinsa_b/kcal_exalc_b)
metildiet$p_prot_b <-with(metildiet,400*proteina_b/kcal_exalc_b)
metildiet$p_sug_b <-with(metildiet,400*sugar_b/kcal_exalc_b) 
metildiet$fruitveg_b <-with(metildiet,fruit_b+veg_b)

metildiet$p_carb_b <-with(metildiet,400*cho_b/kcal_exalc_b)
metildiet$p_fat_b <-with(metildiet,900*grasa_b/kcal_exalc_b)
summary(metildiet$p_fat_b)
summary(metildiet$p_prot_b)
summary(metildiet$potasio_b)


# Components
metildiet$hdi_sfa_b <-with(metildiet,ifelse(p_sfa_b<10,1,0),na.rm=T)
metildiet$hdi_sugar_b<-with(metildiet,ifelse(p_sug_b<10,1,0),na.rm=T)
metildiet$hdi_pufa_b <-with(metildiet,ifelse((p_pufa_b<=11 & p_pufa_b>=6),1,0),na.rm=T)
metildiet$hdi_fat_b <-with(metildiet,ifelse(p_fat_b<30,1,0),na.rm=T)
metildiet$hdi_k_b <-with(metildiet,ifelse(potasio_b>=3500,1,0),na.rm=T)
metildiet$hdi_fv_b <-with(metildiet,ifelse(fruitveg_b>=400,1,0),na.rm=T)
metildiet$hdi_fib_b <-with(metildiet,ifelse(fibra_b>=25,1,0),na.rm=T)




# We check that it was done correctly
metildiet %>%   group_by(hdi_sfa_b) %>% 
  summarise(min=min(p_sfa_b, na.rm=T), 
            max=max(p_sfa_b, na.rm=T))
metildiet %>%   group_by(hdi_k_b) %>% 
  summarise(min=min(potasio_b, na.rm=T), 
            max=max(potasio_b, na.rm=T))
metildiet %>%   group_by(hdi_pufa_b) %>% 
  summarise(min=min(p_pufa_b, na.rm=T), 
            max=max(p_pufa_b, na.rm=T))

# Score HDI total
metildiet$hdi2015_b <-with(metildiet,hdi_sfa_b+hdi_pufa_b+hdi_sugar_b+hdi_fat_b+hdi_k_b+hdi_fv_b+hdi_fib_b)


table(metildiet$hdi_b, useNA = "always")
histogram(metildiet$hdi_b)
mean(metildiet$hdi_b,na.rm=T)

# Convert in factor for table one
vars07<-c("hdi_sfa_b","hdi_pufa_b","hdi_sugar_b","hdi_fat_b","hdi_k_b","hdi_fv_b","hdi_fib_b")
vars07f<-c("hdi_sfa_bf","hdi_pufa_bf","hdi_sugar_bf","hdi_fat_bf","hdi_k_bf","hdi_fv_bf","hdi_fib_bf")
for(i in 1:length(vars07))
  
{
  metildiet[,vars07f[i]]<-as.factor(metildiet[,vars07[i]])
}
vars07<-c("hdi_sfa_bf","hdi_pufa_bf","hdi_sugar_bf","hdi_fat_bf","hdi_k_bf","hdi_fv_bf","hdi_fib_bf","hdi2015_b")

tab <-CreateTableOne(vars07,strata="sexe",data=metildiet)
try<-print(tab,  noSpaces = TRUE)

######################################################################################################
        #############   5. DASH (Fung)       #########
######################################################################################################


#Values of 1 to 5 for quintiles

setDT(metildiet)[,dash_fruit_b := cut(fruitdash_b, quantile(fruitdash_b, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE), by = sexe]
setDT(metildiet)[,dash_veg_b := cut(veg_b, quantile(veg_b, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE), by = sexe]
setDT(metildiet)[,dash_legnut_b := cut(legumenut_b, quantile(legumenut_b, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE), by = sexe]
#setDT(metildiet)[,dash_sweetbev_b := 5-cut(bebidas_b, quantile(bebidas_b, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE), by = sexe]
setDT(metildiet)[,dash_meat_b := 6-cut(meat_b, quantile(meat_b, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE), by = sexe]
#setDT(metildiet)[,dash_wholegrain_b := cut(wholegrain_b, quantile(wholegrain_b, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE), by = sexe]
#setDT(metildiet)[,dash_lfdairy_b := cut(lfdairy_b, quantile(lfdairy_b, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE), by = sexe]
setDT(metildiet)[,dash_na_b := 6-cut(sodio_b, quantile(sodio_b, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE), by = sexe]

# This function does not work for bebidas, low-fat dairy and wholegrain because of too many zeros,
# we do it "by hand"
quintiles <-ddply(metildiet, .(sexe), summarise, 
                qi1_wg_b=quantile(wholegrain_b,0.20, na.rm=T), qi2_wg_b=quantile(wholegrain_b,0.40, na.rm=T),
                qi3_wg_b=quantile(wholegrain_b,0.60, na.rm=T), qi4_wg_b=quantile(wholegrain_b,0.80, na.rm=T), 
                qi1_lfd_b=quantile(lfdairy_b,0.20, na.rm=T), qi2_lfd_b=quantile(lfdairy_b,0.40, na.rm=T),
                qi3_lfd_b=quantile(lfdairy_b,0.60, na.rm=T), qi4_lfd_b=quantile(lfdairy_b,0.80, na.rm=T), 
                qi1_sb_b=quantile(bebidas_b,0.20, na.rm=T), qi2_sb_b=quantile(bebidas_b,0.40, na.rm=T),
                qi3_sb_b=quantile(bebidas_b,0.60, na.rm=T), qi4_sb_b=quantile(bebidas_b,0.80, na.rm=T))

# Merge the dataset according to sex
metildiet<-merge(metildiet,quintiles,by="sexe",all.x=TRUE,sort=FALSE)

metildiet$dash_wg_b <- with(metildiet,ifelse(wholegrain_b<=qi1_wg_b,1,
                                          ifelse(wholegrain_b<=qi2_wg_b,2,
                                                 ifelse(wholegrain_b<=qi3_wg_b,3,
                                                        ifelse(wholegrain_b<=qi4_wg_b,4,5)))),na.rm=T)
metildiet$dash_sb_b <- with(metildiet,ifelse(bebidas_b<=qi1_sb_b,5,
                                               ifelse(bebidas_b<=qi2_sb_b,4,
                                                      ifelse(bebidas_b<=qi3_sb_b,3,
                                                             ifelse(bebidas_b<=qi4_sb_b,2,1)))),na.rm=T)
metildiet$dash_lfd_b <- with(metildiet,ifelse(lfdairy_b<=qi1_lfd_b,1,
                                             ifelse(lfdairy_b<=qi2_lfd_b,2,
                                                    ifelse(lfdairy_b<=qi3_lfd_b,3,
                                                           ifelse(lfdairy_b<=qi4_lfd_b,4,5)))),na.rm=T)

# We check that it was done correctly
metildiet %>%   group_by(sexe,dash_lfd_b) %>% 
  summarise(min=min(lfdairy_b, na.rm=T), 
            max=max(lfdairy_b, na.rm=T))
metildiet %>%   group_by(sexe,dash_sb_b) %>% 
  summarise(min=min(bebidas_b, na.rm=T), 
            max=max(bebidas_b, na.rm=T))
metildiet %>%   group_by(sexe,dash_meat_b) %>% 
  summarise(min=min(meat_b, na.rm=T), 
            max=max(meat_b, na.rm=T))
metildiet %>%   group_by(sexe,dash_na_b) %>% 
  summarise(min=min(sodio_b, na.rm=T), 
            max=max(sodio_b, na.rm=T))

table(metildiet$dash_wg_b, useNA="always")
table(metildiet$dash_sb_b, useNA="always")
table(metildiet$dash_lfd_b, useNA="always")
table(metildiet$dash_fruit_b, useNA="always")
table(metildiet$dash_veg_b, useNA="always")
table(metildiet$dash_legnut_b, useNA="always")
table(metildiet$dash_meat_b, useNA="always")
table(metildiet$dash_na_b, useNA="always")

# Sum total

metildiet$dashf_b <- with(metildiet,dash_wg_b+dash_sb_b+dash_lfd_b+dash_fruit_b+dash_veg_b+dash_legnut_b
                       +dash_meat_b+dash_na_b,na.rm=T) 
table(metildiet$dashf_b, useNA = "always")
histogram(metildiet$dashf_b)
mean(metildiet$dashf_b,na.rm=T)


# Convert in factor for table one
metildiet$dash_wg_bf<-as.factor(metildiet$dash_wg_b)
metildiet$dash_sb_bf<-as.factor(metildiet$dash_sb_b)
metildiet$dash_lfd_bf<-as.factor(metildiet$dash_lfd_b)
metildiet$dash_fruit_bf<-as.factor(metildiet$dash_fruit_b)
metildiet$dash_veg_bf<-as.factor(metildiet$dash_veg_b)
metildiet$dash_legnut_bf<-as.factor(metildiet$dash_legnut_b)
metildiet$dash_meat_bf<-as.factor(metildiet$dash_meat_b)
metildiet$dash_na_bf<-as.factor(metildiet$dash_na_b)

table(metildiet$dash_na_bf, useNA="always")
vars08<-c("dash_wg_bf","dash_sb_bf","dash_lfd_bf","dash_fruit_bf","dash_veg_bf","dash_legnut_bf","dash_meat_bf","dash_na_bf","dashf_b")

tab <-CreateTableOne(vars08,strata="sexe",data=metildiet)
try<-print(tab,  noSpaces = TRUE)


######################################################################################################
#############   6. Healthful Plant based Diet Index       #########
######################################################################################################

#Values of 1 to 5 for quintiles

#setDT(metildiet)[,dash_wholegrain_b := cut(wholegrain_b, quantile(wholegrain_b, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE), by = sexe]
setDT(metildiet)[,hpdi_fruit_b := cut(fruitdash_b, quantile(fruitdash_b, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE), by = sexe]
setDT(metildiet)[,hpdi_veg_b := cut(veg_b, quantile(veg_b, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE), by = sexe]
setDT(metildiet)[,hpdi_nut_b := cut(nut_b, quantile(nut_b, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE), by = sexe]
setDT(metildiet)[,hpdi_legume_b := cut(legumes_b, quantile(legumes_b, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE), by = sexe]
setDT(metildiet)[,hpdi_oil_b := cut(oil_b, quantile(oil_b, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE), by = sexe]
setDT(metildiet)[,hpdi_coft_b := cut(coffeetea_b, quantile(coffeetea_b, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE), by = sexe]

#setDT(metildiet)[,hpdi_fruitjuice_b := 6-cut(fruitjuice_b, quantile(fruitjuice_b, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE), by = sexe]
setDT(metildiet)[,hpdi_refgrain_b := 6-cut(refgrain_b, quantile(refgrain_b, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE), by = sexe]
setDT(metildiet)[,hpdi_potato_b := 6-cut(potato_b, quantile(potato_b, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE), by = sexe]
#setDT(metildiet)[,dash_sweetbev_b := 6-cut(bebidas_b, quantile(bebidas_b, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE), by = sexe]
setDT(metildiet)[,hpdi_sweet_b := 6-cut(sweet_b, quantile(sweet_b, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE), by = sexe]

#setDT(metildiet)[,hpdi_anifat_b := 6-cut(anifat_b, quantile(anifat_b, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE), by = sexe]
setDT(metildiet)[,hpdi_dairy_b := 6-cut(dairy_b, quantile(dairy_b, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE), by = sexe]
#setDT(metildiet)[,hpdi_egg_b := 6-cut(huevos_b, quantile(huevos_b, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE), by = sexe]
setDT(metildiet)[,hpdi_fish_b := 6-cut(fish_b, quantile(fish_b, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE), by = sexe]
setDT(metildiet)[,hpdi_meat_b := 6-cut(meat_b, quantile(meat_b, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE), by = sexe]
setDT(metildiet)[,hpdi_animal_b := 6-cut(animal_b, quantile(animal_b, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE), by = sexe]

## Do by hand huevos, anifat, fruitjuice. Sweet beverages is already made so we will use dash_sb
quintiles2 <-ddply(metildiet, .(sexe), summarise, 
                  qi1_egg_b=quantile(huevos_b,0.20, na.rm=T), qi2_egg_b=quantile(huevos_b,0.40, na.rm=T),
                  qi3_egg_b=quantile(huevos_b,0.60, na.rm=T), qi4_egg_b=quantile(huevos_b,0.80, na.rm=T), 
                  qi1_anifat_b=quantile(anifat_b,0.20, na.rm=T), qi2_anifat_b=quantile(anifat_b,0.40, na.rm=T),
                  qi3_anifat_b=quantile(anifat_b,0.60, na.rm=T), qi4_anifat_b=quantile(anifat_b,0.80, na.rm=T), 
                  qi1_fj_b=quantile(fruitjuice_b,0.20, na.rm=T), qi2_fj_b=quantile(fruitjuice_b,0.40, na.rm=T),
                  qi3_fj_b=quantile(fruitjuice_b,0.60, na.rm=T), qi4_fj_b=quantile(fruitjuice_b,0.80, na.rm=T),
                  qi1_nut_b=quantile(nut_b,0.20, na.rm=T), qi2_nut_b=quantile(nut_b,0.40, na.rm=T),
                  qi3_nut_b=quantile(nut_b,0.60, na.rm=T), qi4_nut_b=quantile(nut_b,0.80, na.rm=T))

# Merge the dataset according to sex
metildiet<-merge(metildiet,quintiles2,by="sexe",all.x=TRUE,sort=FALSE)

metildiet$hpdi_egg_b <- with(metildiet,ifelse(huevos_b<=qi1_egg_b,5,
                                               ifelse(huevos_b<=qi2_egg_b,4,
                                                      ifelse(huevos_b<=qi3_egg_b,3,
                                                             ifelse(huevos_b<=qi4_egg_b,2,1)))),na.rm=T)
metildiet$hpdi_anifat_b <- with(metildiet,ifelse(anifat_b<=qi1_sb_b,5,
                                             ifelse(anifat_b<=qi2_sb_b,4,
                                                    ifelse(anifat_b<=qi3_sb_b,3,
                                                           ifelse(anifat_b<=qi4_sb_b,2,1)))),na.rm=T)
metildiet$hpdi_fruitjuice_b <- with(metildiet,ifelse(fruitjuice_b<=qi1_lfd_b,5,
                                            ifelse(fruitjuice_b<=qi2_lfd_b,4,
                                                   ifelse(fruitjuice_b<=qi3_lfd_b,3,
                                                          ifelse(fruitjuice_b<=qi4_lfd_b,2,1)))),na.rm=T)
metildiet$hpdi_nut_b <- with(metildiet,ifelse(nut_b<=qi1_nut_b,1,
                                            ifelse(nut_b<=qi2_nut_b,2,
                                                   ifelse(nut_b<=qi3_nut_b,3,
                                                          ifelse(nut_b<=qi4_nut_b,4,5)))),na.rm=T)

# We check that it was done correctly
metildiet %>%   group_by(sexe,hpdi_egg_b) %>% 
  summarise(min=min(huevos_b, na.rm=T), 
            max=max(huevos_b, na.rm=T))
metildiet %>%   group_by(sexe,hpdi_anifat_b) %>% 
  summarise(min=min(anifat_b, na.rm=T), 
            max=max(anifat_b, na.rm=T))
metildiet %>%   group_by(sexe,hpdi_fruitjuice_b) %>% 
  summarise(min=min(fruitjuice_b, na.rm=T), 
            max=max(fruitjuice_b, na.rm=T))
metildiet %>%   group_by(sexe,hpdi_animal_b) %>% 
  summarise(min=min(animal_b, na.rm=T), 
            max=max(animal_b, na.rm=T))
metildiet %>%   group_by(sexe,hpdi_nut_b) %>% 
  summarise(min=min(nut_b, na.rm=T), 
            max=max(nut_b, na.rm=T))

#### Sum total
setDT(metildiet)
vars09<-c("dash_wg_b","hpdi_fruit_b","hpdi_veg_b","hpdi_nut_b","hpdi_legume_b","hpdi_oil_b","hpdi_coft_b",
                        "hpdi_fruitjuice_b","hpdi_refgrain_b","hpdi_potato_b","dash_sb_b","hpdi_sweet_b",
                        "hpdi_anifat_b","hpdi_dairy_b","hpdi_egg_b","hpdi_fish_b","hpdi_meat_b","hpdi_animal_b")
metildiet$hpdi_b <-apply(metildiet[,..vars09],1,sum,na.rm=F)

table(metildiet$hpdi_b, useNA = "always")

histogram(metildiet$hpdi_b)
mean(metildiet$hpdi_b,na.rm=T)



vars09<-c("dash_wg_b","hpdi_fruit_b","hpdi_veg_b","hpdi_nut_b","hpdi_legume_b","hpdi_oil_b","hpdi_coft_b",
           "hpdi_fruitjuice_b","hpdi_refgrain_b","hpdi_potato_b","dash_sb_b","hpdi_sweet_b",
           "hpdi_anifat_b","hpdi_dairy_b","hpdi_egg_b","hpdi_fish_b","hpdi_meat_b","hpdi_animal_b","hpdi_b")

tab <-CreateTableOne(vars09,strata="sexe",data=metildiet)
try<-print(tab,  noSpaces = TRUE)







############################################################################

## Some recoding of key variables for the analysis

# Replace 9 by NA
metildiet$smoke_6_b<- as.numeric(ifelse(metildiet$smoke_6_b==9,"",metildiet$smoke_6_b))
metildiet$niv_esco_b<- as.numeric(ifelse(metildiet$niv_esco_b==9,"",metildiet$niv_esco_b))
metildiet$ecivil_s1<- as.numeric(ifelse(metildiet$ecivil_s1==9,"",metildiet$ecivil_s1))

## Civil status
# 1 Single; 2 Married/cohabitation ; 3 Separated/Divorced; 4 Widow; 5 Other (religious community, college)
# Recode Civil status into binary "living with a partner"=1, 0 if not
metildiet$ecivilb_s1<- as.numeric(ifelse(metildiet$ecivil_s1==2,1,0),na.rm=T)
table(metildiet$ecivilb_s1,useNA="always")

## Education 
table(metildiet$niv_esco_b,useNA="always")
# Recode into 1 Low 2 Medium 3 High education
metildiet$educ_b<-as.factor(recode(metildiet$niv_esco_b, `1`= 3L, `2`= 3L, `3`= 2L, `4`= 1L, `5`= 1L))
table(metildiet$educ_b,useNA="always")

metildiet$diab_b<-as.factor(recode(metildiet$diab_b,  `1`= 1L, `2`= 0L))
table(metildiet$diab_b)
metildiet$htasimple_b<-as.factor(recode(metildiet$htasimple_b,  `1`= 1L, `2`= 0L))

## Social class
metildiet$csocial_b<-as.factor(metildiet$csocial_b)
# 1= Executive, 2=Employees, 4=Manual worker


## Change in BMI
metildiet$deltabmi <- as.numeric(with(metildiet,imc_s1-imc_b),na.rm=T)
summary(metildiet$deltabmi)
summary(metildiet$imc_s1)
summary(metildiet$imc_b)

## Create physical activity for 100 Mets increase
metildiet$pa100_b<-metildiet$geaf_tot_b/100
## Create age for 5 years increase
metildiet$age5_b<-metildiet$edat_b/5
## Create kcal for 100kcal
metildiet$kcal100_b<-metildiet$kcal_b/100



save(metildiet,file="U:/Estudis/B64_DIAMETR/Dades/phenotype_regicor_all6352.Rdata")

