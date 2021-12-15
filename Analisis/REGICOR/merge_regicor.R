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
# There are 927 from 944 expected.


##########################################################
options(max.print = 1500)
names(metildiet_subset_cells)

# [1] "Sample_ID"          "BMI"                "CD8T"               "CD4T"               "NK"                
# [6] "Bcell"              "Mono"               "Gran"               "parti"              "sample_name"       
# [11] "pool_id"            "sexe"               "estudi"             "datnaix"            "datinclu_b"        
# [16] "edat_b"             "rural"              "cno_b"              "niv_esco_b"         "csocial_b"         
# [21] "alto_b"             "pes_b"              "imc_b"              "cint_b"             "infota_b"          
# [26] "medita_b"           "infcol_b"           "medicol_b"          "dietglu_b"          "mediglu_b"         
# [31] "insuli_b"           "infoglu_b"          "gluco_b"            "coltot_b"           "hdl_b"             
# [36] "ldl_b"              "trigli_b"           "psisese1_b"         "pdisese1_b"         "psisese2_b"        
# [41] "pdisese2_b"         "psisese3_b"         "pdisese3_b"         "diab_b"             "htasimple_b"       
# [46] "smoke_6_b"          "itbesquerra_b"      "geaf_tot_b"         "geaf_int_b"         "geaf_mod_b"        
# [51] "geaf_lig_b"         "antidep_b"          "itbdret_b"          "antiagre_b"         "estatin_b"         
# [56] "hipolip_b"          "betabloc_b"         "antihiper_b"        "metformi_b"         "antidiab_b"        
# [61] "cumanirics_b"       "alcohday_b"         "mostos_b"           "conyacs_b"          "vijovens_b"        
# [66] "whiskys_b"          "vodkas_b"           "viresers_b"         "atlicors_b"         "viblancs_b"        
# [71] "virosads_b"         "carajils_b"         "cavas_b"            "cubatas_b"          "cerv330s_b"        
# [76] "cerv125s_b"         "xupitoss_b"         "nomlibr1_b"         "libre1_b"           "nomlibr2_b"        
# [81] "libre2_b"           "nomlibr3_b"         "libre3_b"           "nomlibr4_b"         "libre4_b"          
# [86] "nomlibr5_b"         "libre5_b"           "nomlibr6_b"         "libre6_b"           "nomlibr7_b"        
# [91] "libre7_b"           "nomlibr8_b"         "libre8_b"           "nomlibr9_b"         "libre9_b"          
# [96] "funciona_b"         "fritos_b"           "rebozado_b"         "ac_frito_b"         "fruta_b"           
# [101] "verdura_b"          "pescado_b"          "carne_b"            "grasas_b"           "dulces_b"          
# [106] "integral_b"         "poca_sal_b"         "diet_esp_b"         "supl1_b"            "supl11_b"          
# [111] "supl12_b"           "supl13_b"           "supl2_b"            "supl21_b"           "supl22_b"          
# [116] "supl23_b"           "supl3_b"            "supl31_b"           "supl32_b"           "supl33_b"          
# [121] "dieta_b"            "leche_en_b"         "leche_sd_b"         "leche_ds_b"         "cafe_sol_b"        
# [126] "cortado_b"          "cafe_lec_b"         "colacao_b"          "leche_sj_b"         "yogur_en_b"        
# [131] "yogur_sd_b"         "yogur_dn_b"         "queso_bl_b"         "queso_mn_b"         "brie_b"            
# [136] "queso_az_b"         "requeson_b"         "nata_b"             "helado_b"           "natillas_b"        
# [141] "queso_pr_b"         "cornflk_b"          "musli_b"            "avena_cp_b"         "magdalen_b"        
# [146] "croissan_b"         "ensaimad_b"         "donut_b"            "galletas_b"         "pan_blnc_b"        
# [151] "pan_int_b"          "pan_pay_b"          "bocd_st_b"          "bocd_ct_b"          "tostadas_b"        
# [156] "pasta_b"            "pasta_in_b"         "arroz_bl_b"         "arroz_in_b"         "pizza_b"           
# [161] "canelon_b"          "paella_b"           "croqueta_b"         "lechuga_b"          "escarola_b"        
# [166] "endivias_b"         "col__b"             "col_brus_b"         "broculi_b"          "coliflor_b"        
# [171] "judias_v_b"         "tomate_b"           "zanahor_b"          "habas_b"            "acelgas_b"         
# [176] "pimiento_b"         "pepinos_b"          "guisante_b"         "berenjen_b"         "cebollas_b"        
# [181] "esparr_f_b"         "setas_b"            "pat_cocd_b"         "pat_frit_b"         "pat_chip_b"        
# [186] "pure_pat_b"         "aguacate_b"         "espinaca_b"         "sopa_b"             "judias_b_b"        
# [191] "garbanzo_b"         "lentejas_b"         "jamon_s_b"          "jamon_d_b"          "fuet_b"            
# [196] "mortadel_b"         "pates_b"            "btf_bl_b"           "bacon_b"            "ac_oliva_b"        
# [201] "ac_ol_ex_b"         "ac_oruj_b"          "ac_gira_b"          "ac_soja_b"          "ac_maiz_b"         
# [206] "margarin_b"         "mantequi_b"         "manteca_b"          "ketchup_b"          "mahonesa_b"        
# [211] "huevos_b"           "terner_m_b"         "terner_g_b"         "buey_b"             "cerdo_mg_b"        
# [216] "cerdo_gr_b"         "butifar_b"          "pechuga_b"          "pollo_b"            "conejo_b"          
# [221] "caza_b"             "cordero_b"          "higado_b"           "rinones_b"          "sesos_b"           
# [226] "hamburg_b"          "pescad_b_b"         "salmon_b"           "trucha_b"           "sardinas_b"        
# [231] "atun_frs_b"         "caballa_b"          "mejillon_b"         "calamar_b"          "gambas_b"          
# [236] "hamb_mc_b"          "cheesbur_b"         "big_mac_b"          "pat_mcd_b"          "atun_ac_b"         
# [241] "atun_es_b"          "sardn_ac_b"         "sardn_es_b"         "almejas_b"          "brbrchs_b"         
# [246] "anchoas_b"          "esparrag_b"         "naranja_b"          "platano_b"          "manzana_b"         
# [251] "pera_b"             "melocotn_b"         "limon_b"            "melon_b"            "sandia_b"          
# [256] "uva_b"              "fresas_b"           "ciruelas_b"         "almibar_b"          "macedon_b"         
# [261] "kiwi_b"             "higos_b"            "olivas_b"           "almendra_b"         "avellana_b"        
# [266] "cacahuet_b"         "pistacho_b"         "nueces_b"           "datiles_b"          "chocolat_b"        
# [271] "pastel_b"           "sal_b"              "azucar_b"           "bebidas_b"          "te_negro_b"        
# [276] "zumo_nrj_b"         "zumo_tmt_b"         "zumo_mlc_b"         "zumo_uva_b"         "zumo_mnz_b"        
# [281] "cervez_s_b"         "cervez_c_b"         "vino_tn_b"          "vino_bl_b"          "cava_b"            
# [286] "destilad_b"         "licores_b"          "kcal_b"             "cho_b"              "proteina_b"        
# [291] "grasa_b"            "saturada_b"         "monosat_b"          "poliinsa_b"         "choleste_b"        
# [296] "fibra_b"            "vita_b"             "vitd_b"             "b1_b"               "b2_b"              
# [301] "b3_b"               "vitc_b"             "vite_b"             "vitb6_b"            "b12_b"             
# [306] "b5_b"               "biotina_b"          "vitk_b"             "sodio_b"            "potasio_b"         
# [311] "calcio_b"           "magnesio_b"         "fosforo_b"          "azufre_b"           "cloro_b"           
# [316] "hierro_b"           "cobre_b"            "zinc_b"             "iodo_b"             "manganes_b"        
# [321] "selenio_b"          "antiepil_b"         "antipark_b"         "antipsic_b"         "liti_b"            
# [326] "ansiol_b"           "hipno_b"            "inhimono_b"         "inhisero_b"         "tricicli_b"        
# [331] "nootropi_b"         "antidem_b"          "antiverti_b"        "dexam_s1"           "edat_s1"           
# [336] "ecivil_s1"          "cno_s1"             "csocial_s1"         "alto_s1"            "pes_s1"            
# [341] "cint_s1"            "imc_s1"             "infcol_s1"          "dietcol_s1"         "medicol_s1"        
# [346] "infoglu_s1"         "dietglu_s1"         "insuli_s1"          "mediglu_s1"         "infota_s1"         
# [351] "dietta_s1"          "medita_s1"          "trigli_s1"          "gluco_s1"           "coltot_s1"         
# [356] "hdl_s1"             "ldl_s1"             "fuma_s1"            "smoke_6_s1"         "diab_s1"           
# [361] "hta_s1"             "psisese1_s1"        "psisese2_s1"        "psisese3_s1"        "pdisese1_s1"       
# [366] "pdisese2_s1"        "pdisese3_s1"        "itbdret_s1"         "itbesquerra_s1"     "geaf_lig_s1"       
# [371] "geaf_mod_s1"        "geaf_int_s1"        "geaf_tot_s1"        "antiagre_s1"        "estatin_s1"        
# [376] "hipolip_s1"         "betabloc_s1"        "antca_s1"           "antihiper_s1"       "metformi_s1"       
# [381] "antidiab_s1"        "corti_s1"           "b2_inh_s1"          "antleuc_s1"         "antiinfl_s1"       
# [386] "cumarin_s1"         "pa_s1"              "verd_aman_s1"       "fruita_s1"          "iog_llet_s1"       
# [391] "past_arros_s1"      "oli_s1"             "alcohol_s1"         "cereals_s1"         "carn_s1"           
# [396] "embutits_s1"        "formatge_s1"        "briox_pastis_s1"    "mantega_s1"         "altres_olis_s1"    
# [401] "menj_rap_s1"        "peix_s1"            "llegums_s1"         "fruits_secs_s1"     "diet_total1_s1"    
# [406] "diet_total2_s1"     "diet_score1_s1"     "diet_score2_s1"     "noalcohol7d_s1"     "alcohday_s1"       
# [411] "vijovens_s1"        "viresers_s1"        "viblancs_s1"        "virosads_s1"        "cavas_s1"          
# [416] "cerv330s_s1"        "cerv125s_s1"        "conyacs_s1"         "whiskys_s1"         "vodkas_s1"         
# [421] "atlicors_s1"        "carajils_s1"        "cubatas_s1"         "xupitoss_s1"        "leche_en_s1"       
# [426] "leche_sd_s1"        "leche_ds_s1"        "cafe_sol_s1"        "cortado_s1"         "cafe_lec_s1"       
# [431] "colacao_s1"         "leche_sj_s1"        "yogur_en_s1"        "yogur_sd_s1"        "yogur_dn_s1"       
# [436] "queso_bl_s1"        "queso_mn_s1"        "brie_s1"            "queso_az_s1"        "requeson_s1"       
# [441] "nata_s1"            "helado_s1"          "natillas_s1"        "queso_pr_s1"        "cornflk_s1"        
# [446] "musli_s1"           "avena_cp_s1"        "magdalen_s1"        "croissan_s1"        "ensaimad_s1"       
# [451] "donut_s1"           "galletas_s1"        "pan_blnc_s1"        "pan_int_s1"         "pan_pay_s1"        
# [456] "bocd_st_s1"         "bocd_ct_s1"         "tostadas_s1"        "pasta_s1"           "pasta_in_s1"       
# [461] "arroz_bl_s1"        "arroz_in_s1"        "pizza_s1"           "canelon_s1"         "paella_s1"         
# [466] "croqueta_s1"        "lechuga_s1"         "escarola_s1"        "endivias_s1"        "col_s1"            
# [471] "col_brus_s1"        "broculi_s1"         "coliflor_s1"        "judias_v_s1"        "tomate_s1"         
# [476] "zanahor_s1"         "habas_s1"           "acelgas_s1"         "pimiento_s1"        "pepinos_s1"        
# [481] "guisante_s1"        "berenjen_s1"        "cebollas_s1"        "esparr_f_s1"        "setas_s1"          
# [486] "pat_cocd_s1"        "pat_frit_s1"        "pat_chip_s1"        "pure_pat_s1"        "aguacate_s1"       
# [491] "espinaca_s1"        "sopa_s1"            "judias_b_s1"        "garbanzo_s1"        "lentejas_s1"       
# [496] "jamon_s_s1"         "jamon_d_s1"         "fuet_s1"            "mortadel_s1"        "pates_s1"          
# [501] "btf_bl_s1"          "bacon_s1"           "ac_oliva_s1"        "ac_ol_ex_s1"        "ac_oruj_s1"        
# [506] "ac_gira_s1"         "ac_soja_s1"         "ac_maiz_s1"         "margarin_s1"        "mantequi_s1"       
# [511] "manteca_s1"         "ketchup_s1"         "mahonesa_s1"        "huevos_s1"          "terner_m_s1"       
# [516] "terner_g_s1"        "buey_s1"            "cerdo_mg_s1"        "cerdo_gr_s1"        "butifar_s1"        
# [521] "pechuga_s1"         "pollo_s1"           "conejo_s1"          "caza_s1"            "cordero_s1"        
# [526] "higado_s1"          "riñones_s1"         "sesos_s1"           "hamburg_s1"         "pescad_b_s1"       
# [531] "salmon_s1"          "trucha_s1"          "sardinas_s1"        "atun_frs_s1"        "caballa_s1"        
# [536] "mejillon_s1"        "calamar_s1"         "gambas_s1"          "hamb_mc_s1"         "cheesbur_s1"       
# [541] "big_mac_s1"         "pat_mcd_s1"         "atun_ac_s1"         "atun_es_s1"         "sardn_ac_s1"       
# [546] "sardn_es_s1"        "almejas_s1"         "brbrchs_s1"         "anchoas_s1"         "esparrag_s1"       
# [551] "naranja_s1"         "platano_s1"         "manzana_s1"         "pera_s1"            "melocotn_s1"       
# [556] "limon_s1"           "melon_s1"           "sandia_s1"          "uva_s1"             "fresas_s1"         
# [561] "ciruelas_s1"        "almibar_s1"         "macedon_s1"         "kiwi_s1"            "higos_s1"          
# [566] "olivas_s1"          "almendra_s1"        "avellana_s1"        "cacahuet_s1"        "pistacho_s1"       
# [571] "nueces_s1"          "datiles_s1"         "chocolat_s1"        "pastel_s1"          "sal_s1"            
# [576] "azucar_s1"          "bebidas_s1"         "te_negro_s1"        "zumo_nrj_s1"        "zumo_tmt_s1"       
# [581] "zumo_mlc_s1"        "zumo_uva_s1"        "zumo_mnz_s1"        "cervez_s_s1"        "cervez_c_s1"       
# [586] "vino_tn_s1"         "vino_bl_s1"         "cava_s1"            "destilad_s1"        "licores_s1"        
# [591] "nomlibr1_s1"        "libre1_s1"          "nomlibr2_s1"        "libre2_s1"          "nomlibr3_s1"       
# [596] "libre3_s1"          "nomlibr4_s1"        "libre4_s1"          "nomlibr5_s1"        "libre5_s1"         
# [601] "nomlibr6_s1"        "libre6_s1"          "nomlibr7_s1"        "libre7_s1"          "nomlibr8_s1"       
# [606] "libre8_s1"          "nomlibr9_s1"        "libre9_s1"          "funciona_s1"        "fritos_s1"         
# [611] "rebozado_s1"        "ac_frito_s1"        "fruta_s1"           "verdura_s1"         "pescado_s1"        
# [616] "carne_s1"           "greix_s1"           "dulces_s1"          "integral_s1"        "poca_sal_s1"       
# [621] "diet_esp_s1"        "dieta_tx_s1"        "supl1_s1"           "supl11_s1"          "supl12_s1"         
# [626] "supl13_s1"          "supl2_s1"           "supl21_s1"          "supl22_s1"          "supl23_s1"         
# [631] "supl3_s1"           "supl31_s1"          "supl32_s1"          "supl33_s1"          "supl1_nm_s1"       
# [636] "supl1_tp_s1"        "supl1_ct_s1"        "supl1_fq_s1"        "supl2_nm_s1"        "supl2_tp_s1"       
# [641] "supl2_ct_s1"        "supl2_fq_s1"        "supl3_nm_s1"        "supl3_tp_s1"        "supl3_ct_s1"       
# [646] "supl3_fq_s1"        "dieta_s1"           "kcal_s1"            "cho_s1"             "proteina_s1"       
# [651] "grasa_s1"           "saturada_s1"        "monosat_s1"         "poliinsa_s1"        "choleste_s1"       
# [656] "fibra_s1"           "vita_s1"            "vitd_s1"            "b1_s1"              "b2_s1"             
# [661] "b3_s1"              "vitc_s1"            "vite_s1"            "vitb6_s1"           "b12_s1"            
# [666] "b5_s1"              "biotina_s1"         "vitk_s1"            "sodio_s1"           "potasio_s1"        
# [671] "calcio_s1"          "magnesio_s1"        "fosforo_s1"         "azufre_s1"          "cloro_s1"          
# [676] "hierro_s1"          "cobre_s1"           "zinc_s1"            "iodo_s1"            "manganes_s1"       
# [681] "selenio_s1"         "dst_od_s1"          "dst_oi_s1"          "sdt_s1"             "tmt_a_s1"          
# [686] "tmt_b_s1"           "ftt_d_s1"           "ftt_md_s1"          "ftt_mnd_s1"         "ts_p_s1"           
# [691] "ts_c_s1"            "ts_pc_s1"           "fv_f_s1"            "fv_s_s1"            "phq_1_s1"          
# [696] "phq_2_s1"           "phq_3_s1"           "phq_4_s1"           "phq_5_s1"           "phq_6_s1"          
# [701] "phq_7_s1"           "phq_8_s1"           "phq_9_s1"           "phq_9_1_s1"         "phq_9_2_s1"        
# [706] "phq_9_3_s1"         "phq_9_4_s1"         "phq_9_5_s1"         "recomana_s1"        "phq_10_v1_s1"      
# [711] "phq_10_v2_s1"       "phq_10_s1"          "phq_10_1_s1"        "phq_11_s1"          "phq_12_s1"         
# [716] "phq_12_1_s1"        "phq_12_2_s1"        "phq_12_3_s1"        "phq_12_4_s1"        "phq_12_5_s1"       
# [721] "phq_12_6_s1"        "phq_12_7_s1"        "phq_13_s1"          "antiepil_s1"        "antipark_s1"       
# [726] "antipsic_s1"        "liti_s1"            "ansiol_s1"          "hipno_s1"           "inhimono_s1"       
# [731] "inhisero_s1"        "altrespsico_s1"     "multiple"           "datultct"           "datcensura"        
# [736] "iam"                "datiam"             "altraci"            "dataltraci"         "avc"               
# [741] "datavc"             "def"                "datdef"             "causa_def_ctg"      "iam_previ"         
# [746] "altraci_previ"      "avc_previ"          "fupd"               "fupy"               "leche_en_sug_b"    
# [751] "leche_sd_sug_b"     "leche_ds_sug_b"     "cafe_sol_sug_b"     "cortado_sug_b"      "cafe_lec_sug_b"    
# [756] "colacao_sug_b"      "leche_sj_sug_b"     "yogur_en_sug_b"     "yogur_sd_sug_b"     "yogur_dn_sug_b"    
# [761] "queso_sug_bl_sug_b" "queso_mn_sug_b"     "brie_sug_b"         "queso_az_sug_b"     "requeson_sug_b"    
# [766] "nata_sug_b"         "helado_sug_b"       "natillas_sug_b"     "queso_pr_sug_b"     "cornflk_sug_b"     
# [771] "musli_sug_b"        "avena_cp_sug_b"     "magdalen_sug_b"     "croissan_sug_b"     "ensaimad_sug_b"    
# [776] "donut_sug_b"        "galletas_sug_b"     "pan_sug_blnc_sug_b" "pan_int_sug_b"      "pan_pay_sug_b"     
# [781] "bocd_st_sug_b"      "bocd_ct_sug_b"      "tostadas_sug_b"     "pasta_sug_b"        "pasta_in_sug_b"    
# [786] "arroz_sug_bl_sug_b" "arroz_in_sug_b"     "pizza_sug_b"        "canelon_sug_b"      "paella_sug_b"      
# [791] "croqueta_sug_b"     "lechuga_sug_b"      "escarola_sug_b"     "endivias_sug_b"     "col__sug_b"        
# [796] "col_sug_brus_sug_b" "broculi_sug_b"      "coliflor_sug_b"     "judias_v_sug_b"     "tomate_sug_b"      
# [801] "zanahor_sug_b"      "habas_sug_b"        "acelgas_sug_b"      "pimiento_sug_b"     "pepinos_sug_b"     
# [806] "guisante_sug_b"     "berenjen_sug_b"     "cebollas_sug_b"     "esparr_f_sug_b"     "setas_sug_b"       
# [811] "pat_cocd_sug_b"     "pat_frit_sug_b"     "pat_chip_sug_b"     "pure_pat_sug_b"     "aguacate_sug_b"    
# [816] "espinaca_sug_b"     "sopa_sug_b"         "judias_sug_b_sug_b" "garbanzo_sug_b"     "lentejas_sug_b"    
# [821] "jamon_s_sug_b"      "jamon_d_sug_b"      "fuet_sug_b"         "mortadel_sug_b"     "pates_sug_b"       
# [826] "btf_sug_bl_sug_b"   "bacon_sug_b"        "ac_oliva_sug_b"     "ac_ol_ex_sug_b"     "ac_oruj_sug_b"     
# [831] "ac_gira_sug_b"      "ac_soja_sug_b"      "ac_maiz_sug_b"      "margarin_sug_b"     "mantequi_sug_b"    
# [836] "manteca_sug_b"      "ketchup_sug_b"      "mahonesa_sug_b"     "huevos_sug_b"       "terner_m_sug_b"    
# [841] "terner_g_sug_b"     "buey_sug_b"         "cerdo_mg_sug_b"     "cerdo_gr_sug_b"     "butifar_sug_b"     
# [846] "pechuga_sug_b"      "pollo_sug_b"        "conejo_sug_b"       "caza_sug_b"         "cordero_sug_b"     
# [851] "higado_sug_b"       "rinones_sug_b"      "sesos_sug_b"        "hamburg_sug_b"      "pescad_sug_b_sug_b"
# [856] "salmon_sug_b"       "trucha_sug_b"       "sardinas_sug_b"     "atun_frs_sug_b"     "caballa_sug_b"     
# [861] "mejillon_sug_b"     "calamar_sug_b"      "gambas_sug_b"       "hamb_mc_sug_b"      "cheesbur_sug_b"    
# [866] "big_mac_sug_b"      "pat_mcd_sug_b"      "atun_ac_sug_b"      "atun_es_sug_b"      "sardn_ac_sug_b"    
# [871] "sardn_es_sug_b"     "almejas_sug_b"      "brbrchs_sug_b"      "anchoas_sug_b"      "esparrag_sug_b"    
# [876] "naranja_sug_b"      "platano_sug_b"      "manzana_sug_b"      "pera_sug_b"         "melocotn_sug_b"    
# [881] "limon_sug_b"        "melon_sug_b"        "sandia_sug_b"       "uva_sug_b"          "fresas_sug_b"      
# [886] "ciruelas_sug_b"     "almibar_sug_b"      "macedon_sug_b"      "kiwi_sug_b"         "higos_sug_b"       
# [891] "olivas_sug_b"       "almendra_sug_b"     "avellana_sug_b"     "cacahuet_sug_b"     "pistacho_sug_b"    
# [896] "nueces_sug_b"       "datiles_sug_b"      "chocolat_sug_b"     "pastel_sug_b"       "sal_sug_b"         
# [901] "azucar_sug_b"       "bebidas_sug_b"      "te_negro_sug_b"     "zumo_nrj_sug_b"     "zumo_tmt_sug_b"    
# [906] "zumo_mlc_sug_b"     "zumo_uva_sug_b"     "zumo_mnz_sug_b"     "cervez_s_sug_b"     "cervez_c_sug_b"    
# [911] "vino_tn_sug_b"      "vino_sug_bl_sug_b"  "cava_sug_b"         "destilad_sug_b"     "licores_sug_b"     
# [916] "sugar_b"            "redmeat_b"          "poultry_b"          "meat_b"             "fish_b"            
# [921] "ffish_b"            "milk_b"             "yoghurt_b"          "cheese_b"           "dairy_b"           
# [926] "lfdairy_b"          "anifat_b"           "animal_b"           "bread_b"            "bkcereals_b"       
# [931] "ricepasta_b"        "cereals_b"          "wholegrain_b"       "refgrain_b"         "veg_b"             
# [936] "potato_b"           "potatofried_b"      "potatohealthy_b"    "fruit_b"            "nut_b"             
# [941] "fruitnut_b"         "fruitjuice_b"       "fruittot_b"         "fruitnuttot_b"      "fruitdash_b"       
# [946] "legumes_b"          "legumenut_b"        "mufasfa_b"          "oliveoil_b"         "oil_b"             
# [951] "coffeetea_b"        "sweet_b"            "ethanol_b"          "alcoholdrink_b"     "ssb_b"             
# [956] "med_cereals_b"      "q1_cereals_b"       "q3_cereals_b"       "med_fish_b"         "q1_fish_b"         
# [961] "q3_fish_b"          "med_redmeat_b"      "q1_redmeat_b"       "q3_redmeat_b"       "med_veg_b"         
# [966] "q1_veg_b"           "q3_veg_b"           "med_fruitnut_b"     "q1_fruitnut_b"      "q3_fruitnut_b"     
# [971] "med_fruit_b"        "q1_fruit_b"         "q3_fruit_b"         "med_nut_b"          "q1_nut_b"          
# [976] "q3_nut_b"           "med_dairy_b"        "q1_dairy_b"         "q3_dairy_b"         "med_legumes_b"     
# [981] "q1_legumes_b"       "q3_legumes_b"       "med_mufasfa_b"      "q1_mufasfa_b"       "q3_mufasfa_b"      
# [986] "med_wholegrain_b"   "q1_wholegrain_b"    "q3_wholegrain_b"    "mds_cereal_b"       "mds_fish_b"        
# [991] "mds_meat_b"         "mds_veg_b"          "mds_fruit_b"        "mds_dairy_b"        "mds_legume_b"      
# [996] "mds_mufasfa_b"      "mds_alcohol_b"      "mds_b"              "mds_cereal_bf"      "mds_fish_bf"       
# [1001] "mds_meat_bf"        "mds_veg_bf"         "mds_fruit_bf"       "mds_dairy_bf"       "mds_legume_bf"     
# [1006] "mds_mufasfa_bf"     "mds_alcohol_bf"     "mmds_wgrain_b"      "mmds_fish_b"        "mmds_meat_b"       
# [1011] "mmds_veg_b"         "mmds_fruit_b"       "mmds_nut_b"         "mmds_legume_b"      "mmds_mufasfa_b"    
# [1016] "mmds_alcohol_b"     "mmds_b"             "mmds_wgrain_bf"     "mmds_fish_bf"       "mmds_meat_bf"      
# [1021] "mmds_veg_bf"        "mmds_fruit_bf"      "mmds_nut_bf"        "mmds_legume_bf"     "mmds_mufasfa_bf"   
# [1026] "mmds_alcohol_bf"    "cereals_be"         "ffish_be"           "meat_be"            "veg_be"            
# [1031] "fruitnut_be"        "legumes_be"         "dairy_be"           "oliveoil_be"        "t1_cereals_be"     
# [1036] "t2_cereals_be"      "t1_ffish_be"        "t2_ffish_be"        "t1_veg_be"          "t2_veg_be"         
# [1041] "t1_meat_be"         "t2_meat_be"         "t1_fruitnut_be"     "t2_fruitnut_be"     "t1_dairy_be"       
# [1046] "t2_dairy_be"        "t1_legumes_be"      "t2_legumes_be"      "med_oliveoil_be"    "t1_oliveoil_be"    
# [1051] "t2_oliveoil_be"     "rmed_cereals_b"     "rmed_fish_b"        "rmed_meat_b"        "rmed_dairy_b"      
# [1056] "rmed_fruit_b"       "rmed_veg_b"         "rmed_legumes_b"     "rmed_oliveoil_b"    "rmed_alcohol_b"    
# [1061] "rmed_b"             "rmed_cereals_bf"    "rmed_fish_bf"       "rmed_meat_bf"       "rmed_veg_bf"       
# [1066] "rmed_fruit_bf"      "rmed_dairy_bf"      "rmed_legumes_bf"    "rmed_oliveoil_bf"   "rmed_alcohol_bf"   
# [1071] "kcal_exalc_b"       "p_sfa_b"            "p_pufa_b"           "p_prot_b"           "p_sug_b"           
# [1076] "fruitveg_b"         "hdi_sfa_b"          "hdi_sugar_b"        "hdi_pufa_b"         "hdi_prot_b"        
# [1081] "hdi_chol_b"         "hdi_fv_b"           "hdi_fib_b"          "hdi_b"              "hdi_sfa_bf"        
# [1086] "hdi_pufa_bf"        "hdi_sugar_bf"       "hdi_prot_bf"        "hdi_chol_bf"        "hdi_fv_bf"         
# [1091] "hdi_fib_bf"         "dash_fruit_b"       "dash_veg_b"         "dash_legnut_b"      "dash_meat_b"       
# [1096] "dash_na_b"          "qi1_wg_b"           "qi2_wg_b"           "qi3_wg_b"           "qi4_wg_b"          
# [1101] "qi1_lfd_b"          "qi2_lfd_b"          "qi3_lfd_b"          "qi4_lfd_b"          "qi1_sb_b"          
# [1106] "qi2_sb_b"           "qi3_sb_b"           "qi4_sb_b"           "dash_wg_b"          "dash_sb_b"         
# [1111] "dash_lfd_b"         "dashf_b"            "dash_wg_bf"         "dash_sb_bf"         "dash_lfd_bf"       
# [1116] "dash_fruit_bf"      "dash_veg_bf"        "dash_legnut_bf"     "dash_meat_bf"       "dash_na_bf"        
# [1121] "hpdi_fruit_b"       "hpdi_veg_b"         "hpdi_legume_b"      "hpdi_oil_b"         "hpdi_coft_b"       
# [1126] "hpdi_refgrain_b"    "hpdi_potato_b"      "hpdi_sweet_b"       "hpdi_dairy_b"       "hpdi_fish_b"       
# [1131] "hpdi_meat_b"        "hpdi_animal_b"      "qi1_egg_b"          "qi2_egg_b"          "qi3_egg_b"         
# [1136] "qi4_egg_b"          "qi1_anifat_b"       "qi2_anifat_b"       "qi3_anifat_b"       "qi4_anifat_b"      
# [1141] "qi1_fj_b"           "qi2_fj_b"           "qi3_fj_b"           "qi4_fj_b"           "qi1_nut_b"         
# [1146] "qi2_nut_b"          "qi3_nut_b"          "qi4_nut_b"          "hpdi_egg_b"         "hpdi_anifat_b"     
# [1151] "hpdi_fruitjuice_b"  "hpdi_nut_b"         "hpdi_b"             "ecivilb_s1"         "educ_b"            
# [1156] "deltabmi"           "pa100_b"            "age5_b"             "kcal100_b" 





## Select those variables of interest for final dataframe

# [1] "Sample_ID"          "BMI"                "CD8T"               "CD4T"               "NK"                
# [6] "Bcell"              "Mono"               "Gran"               "parti"              "sample_name"       
# [11] "pool_id"            "sexe"               "estudi"             "datnaix"            "datinclu_b"        
# [16] "edat_b"             "rural"              "cno_b"              "niv_esco_b"         "csocial_b"         
# [21] "alto_b"             "pes_b"              "imc_b"              "cint_b"             "infota_b"          
# [26] "medita_b"           "infcol_b"           "medicol_b"          "dietglu_b"          "mediglu_b"         
# [31] "insuli_b"           "infoglu_b"          "gluco_b"            "coltot_b"           "hdl_b"             
# [36] "ldl_b"              "trigli_b"           "psisese1_b"         "pdisese1_b"         "psisese2_b"        
# [41] "pdisese2_b"         "psisese3_b"         "pdisese3_b"         "diab_b"             "htasimple_b"       
# [46] "smoke_6_b"          "itbesquerra_b"      "geaf_tot_b"         "geaf_int_b"         "geaf_mod_b"        
# [51] "geaf_lig_b"         "antidep_b"          "itbdret_b"   
# mds_b
# mmds_b
# rmed_b
# hdi_b
# dashf_b
# hpdi_b

metildiet_study <- metildiet_subset_cells[,c(1:51,53,288,998,1017,1061,1084,1112,1153)]
names(metildiet_study)

# [1] "Sample_ID"     "BMI"           "CD8T"          "CD4T"          "NK"            "Bcell"        
# [7] "Mono"          "Gran"          "parti"         "Pool_ID"       "sexe"          "estudi"       
# [13] "datnaix"       "datinclu_b"    "edat_b"        "rural"         "cno_b"         "niv_esco_b"   
# [19] "csocial_b"     "alto_b"        "pes_b"         "imc_b"         "cint_b"        "infota_b"     
# [25] "medita_b"      "infcol_b"      "medicol_b"     "dietglu_b"     "mediglu_b"     "insuli_b"     
# [31] "infoglu_b"     "gluco_b"       "coltot_b"      "hdl_b"         "ldl_b"         "trigli_b"     
# [37] "psisese1_b"    "pdisese1_b"    "psisese2_b"    "pdisese2_b"    "psisese3_b"    "pdisese3_b"   
# [43] "diab_b"        "htasimple_b"   "smoke_6_b"     "itbesquerra_b" "geaf_tot_b"    "geaf_int_b"   
# [49] "geaf_mod_b"    "geaf_lig_b"    "itbdret_b"     "mds_b"         "mmds_b"        "rmed_b"       
# [55] "hdi_b"         "dashf_b"       "hpdi_b"  

# Devide into pool_Id for analysis
metildiet_study_450 <- metildiet_study[metildiet_study$pool_id=="450K",]
metildiet_study_epic <- metildiet_study[metildiet_study$pool_id=="EPIC",]

# Remove people having NA in scores
library(tidyr)
metildiet_study_450 <- metildiet_study_450 %>% drop_na(c(mds_b, mmds_b, rmed_b, hdi_b, dashf_b, hpdi_b))
metildiet_study_epic <- metildiet_study_epic %>% drop_na(c(mds_b, mmds_b, rmed_b, hdi_b, dashf_b, hpdi_b))

save(metildiet_study, file = "U:/Estudis/B64_DIAMETR/Dades/REGICOR/metildiet_with_cells_and_rightVars.RData")
# metildiet_study still holds the NAs in diet scores
save(metildiet_study_450, file="U:/Estudis/B64_DIAMETR/Dades/REGICOR/metildiet_with_cells_and_rightVars_450.RData")
save(metildiet_study_epic, file = "U:/Estudis/B64_DIAMETR/Dades/REGICOR/metildiet_with_cells_and_rightVars_epic.RData")
