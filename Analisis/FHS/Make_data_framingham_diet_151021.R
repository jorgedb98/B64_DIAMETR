#### ORIGINAL CODE "framingham_variablegroups_descriptivetable" found in U:\Assessories\Antics\SSayols\RCortes\analysis\descriptivos\framingham

## The variable labels of each food and conversion table from US unit (Oz) to grams is found in the same folder, Word document "variables conversion" ##
rm(list=ls())
library(Hmisc)
library(compareGroups)

###################
### We have to download again the dataset from dbgap because some variables are missing?
################### load("U:/Assessories/Antics/SSayols/RCortes/data/framingham/pheno_grups_nutri.RData")

####PASAR VARIABLES A GRAMOS POR DIA####
#Pasar los fatos de frecuencia a NUMERO DE RACIONES DIARIAS
foods <- c(names(pheno_fhs)[55:151], names(pheno_fhs)[153:170])

# conversion de los numeros de frecuencia a numero de raciones por dia
# se ha usado el valor medio del intervalo
# si 2 quiere decir de 1 a 3 veces al mes, se han tomado dos veces al mes
for(j in foods){
  print (j)
  pheno_fhs[,j]=ifelse(pheno_fhs[,j]==1,0.495/30,
                       ifelse(pheno_fhs[,j]==2,2/30,
                              ifelse(pheno_fhs[,j]==3,1/7,
                                     ifelse(pheno_fhs[,j]==4,3/7,
                                            ifelse(pheno_fhs[,j]==5,5.5/7,
                                                   ifelse(pheno_fhs[,j]==6,1,
                                                          ifelse(pheno_fhs[,j]==7,2.5,
                                                                 ifelse(pheno_fhs[,j]==8,4.5,
                                                                        ifelse(pheno_fhs[,j]==9,6,NA)))))))))
  
  
}

    #Multiplicar por el NUMERO DE RACIONES DIARIAS por los GRAMOS POR RACION para tener GRAMOS POR DIA
    pheno_fhs$SKIM<-pheno_fhs$SKIM*226.796
    pheno_fhs$MILK<-pheno_fhs$MILK*226.796
    pheno_fhs$CREAM<-pheno_fhs$CREAM*15
    pheno_fhs$SOUR_CR<-pheno_fhs$SOUR_CR*12
    pheno_fhs$ICE_CR<-pheno_fhs$ICE_CR*86
    pheno_fhs$YOG<-pheno_fhs$YOG*245
    pheno_fhs$COT_CH<-pheno_fhs$COT_CH*112.5
    pheno_fhs$CR_CH<-pheno_fhs$CR_CH*28.3495
    pheno_fhs$OTH_CH<-pheno_fhs$OTH_CH*28.3495
    pheno_fhs$MARGARIN<-pheno_fhs$MARGARIN*4.8
    pheno_fhs$BU<-pheno_fhs$BU*5
    pheno_fhs$RAIS<-pheno_fhs$RAIS*28.3495
    pheno_fhs$PRUN<-pheno_fhs$PRUN*66
    pheno_fhs$BAN<-pheno_fhs$BAN*127
    pheno_fhs$CANT<-pheno_fhs$CANT*138
    pheno_fhs$H20MEL<-pheno_fhs$H20MEL*286
    pheno_fhs$APPLE<-pheno_fhs$APPLE*182
    pheno_fhs$A_J<-pheno_fhs$A_J*248
    pheno_fhs$ORANG<-pheno_fhs$ORANG*131
    pheno_fhs$O_J<-pheno_fhs$O_J*248
    pheno_fhs$GRFRT<-pheno_fhs$GRFRT*83
    pheno_fhs$GRFRT_J<-pheno_fhs$GRFRT_J*247
    pheno_fhs$STRAW<-pheno_fhs$STRAW*76
    pheno_fhs$BLUE<-pheno_fhs$BLUE*74
    pheno_fhs$PEACH_CN<-pheno_fhs$PEACH_CN*150
    pheno_fhs$TOM<-pheno_fhs$TOM*62
    pheno_fhs$TOM_J<-pheno_fhs$TOM_J*243
    pheno_fhs$TOFU<-pheno_fhs$TOFU*99.22325
    pheno_fhs$ST_BEANS<-pheno_fhs$ST_BEANS*88
    pheno_fhs$BROC<-pheno_fhs$BROC*44
    pheno_fhs$CABB<-pheno_fhs$CABB*35
    pheno_fhs$CAUL<-pheno_fhs$CAUL*53.5
    pheno_fhs$BRUSL<-pheno_fhs$BRUSL*44
    pheno_fhs$CARROT_R<-pheno_fhs$CARROT_R*30.5
    pheno_fhs$CARROT_C<-pheno_fhs$CARROT_C*23
    pheno_fhs$CORN<-pheno_fhs$CORN*82
    pheno_fhs$PEAS<-pheno_fhs$PEAS*72.5
    pheno_fhs$BEANS<-pheno_fhs$BEANS*100
    pheno_fhs$YEL_SQS<-pheno_fhs$YEL_SQS*70
    pheno_fhs$ZUKE<-pheno_fhs$ZUKE*41
    pheno_fhs$YAMS<-pheno_fhs$YAMS*66.5
    pheno_fhs$SPIN_CKD<-pheno_fhs$SPIN_CKD*90
    pheno_fhs$SPIN_RAW<-pheno_fhs$SPIN_RAW*15
    pheno_fhs$KALE<-pheno_fhs$KALE*8
    pheno_fhs$ICE_LET<-pheno_fhs$ICE_LET*89
    pheno_fhs$ROM_LET<-pheno_fhs$ROM_LET*85
    pheno_fhs$CELERY<-pheno_fhs$CELERY*4
    pheno_fhs$BEET<-pheno_fhs$BEET*68
    pheno_fhs$EGGS<-pheno_fhs$EGGS*44
    pheno_fhs$CHIX_SK<-pheno_fhs$CHIX_SK*141.7475
    pheno_fhs$CHIX_NO<-pheno_fhs$CHIX_NO*141.7475
    pheno_fhs$BACON<-pheno_fhs$BACON*56
    pheno_fhs$HOTDOG<-pheno_fhs$HOTDOG*42
    pheno_fhs$PROC_MTS<-pheno_fhs$PROC_MTS*28
    pheno_fhs$HAMB<-pheno_fhs$HAMB*113
    pheno_fhs$BEEF<-pheno_fhs$BEEF*141.7475
    pheno_fhs$TUNA<-pheno_fhs$TUNA*99.22325
    pheno_fhs$DK_FISH<-pheno_fhs$DK_FISH*113.398
    pheno_fhs$OTH_FISH<-pheno_fhs$OTH_FISH*113.398
    pheno_fhs$SHRIMP<-pheno_fhs$SHRIMP*85
    pheno_fhs$COLD_CER<-pheno_fhs$COLD_CER*62
    pheno_fhs$CKD_OATS<-pheno_fhs$CKD_OATS*234
    pheno_fhs$CKD_CER<-pheno_fhs$CKD_CER*243
    pheno_fhs$WH_BR<-pheno_fhs$WH_BR*28
    pheno_fhs$DK_BR<-pheno_fhs$DK_BR*28
    pheno_fhs$ENG_MUFF<-pheno_fhs$ENG_MUFF*57
    pheno_fhs$MUFF<-pheno_fhs$MUFF*113
    pheno_fhs$BR_RICE<-pheno_fhs$BR_RICE*185
    pheno_fhs$WH_RICE<-pheno_fhs$WH_RICE*185
    pheno_fhs$PASTA<-pheno_fhs$PASTA*90
    pheno_fhs$GRAINS<-pheno_fhs$GRAINS*170
    pheno_fhs$PANCAKE<-pheno_fhs$PANCAKE*77
    pheno_fhs$FF_POT<-pheno_fhs$FF_POT*113.398
    pheno_fhs$MASH_POT<-pheno_fhs$MASH_POT*210
    pheno_fhs$POT_CHIP<-pheno_fhs$POT_CHIP*28.3495
    pheno_fhs$CRAX<-pheno_fhs$CRAX*15
    pheno_fhs$PIZZA<-pheno_fhs$PIZZA*398
    pheno_fhs$COKE<-pheno_fhs$COKE*370
    pheno_fhs$COKE_NO<-pheno_fhs$COKE_NO*355
    pheno_fhs$OTH_CARB<-pheno_fhs$OTH_CARB*370
    pheno_fhs$PUNCH<-pheno_fhs$PUNCH*248
    pheno_fhs$DECAF<-pheno_fhs$DECAF*237
    pheno_fhs$COFF<-pheno_fhs$COFF*237
    pheno_fhs$TEA<-pheno_fhs$TEA*269
    pheno_fhs$BEER<-pheno_fhs$BEER*356
    pheno_fhs$R_WINE<-pheno_fhs$R_WINE*113.398
    pheno_fhs$W_WINE<-pheno_fhs$R_WINE*113.398
    pheno_fhs$LIQ<-pheno_fhs$LIQ*49.3333
    pheno_fhs$CHOC<-pheno_fhs$CHOC*17
    pheno_fhs$CANDYNUT<-pheno_fhs$CANDYNUT*54
    pheno_fhs$CANDY<-pheno_fhs$CANDY*11.25
    pheno_fhs$COOX_HOM<-pheno_fhs$COOX_HOM*12.9
    pheno_fhs$COOX_COM<-pheno_fhs$COOX_COM*12.9
    pheno_fhs$BROWNIE<-pheno_fhs$BROWNIE*56
    pheno_fhs$DONUT<-pheno_fhs$DONUT*43
    pheno_fhs$CAKE_HOM<-pheno_fhs$CAKE_HOM*28
    pheno_fhs$CAKE_COM<-pheno_fhs$CAKE_COM*28
    pheno_fhs$S_ROLL_H<-pheno_fhs$S_ROLL_H*60
    pheno_fhs$S_ROLL_C<-pheno_fhs$S_ROLL_C*60
    pheno_fhs$PIE_HOME<-pheno_fhs$PIE_HOME*125
    pheno_fhs$PIE_COMM<-pheno_fhs$PIE_COMM*125
    pheno_fhs$JAM<-pheno_fhs$JAM*20
    pheno_fhs$P_BU<-pheno_fhs$P_BU*32
    pheno_fhs$POPC<-pheno_fhs$POPC*8
    pheno_fhs$NUTS<-pheno_fhs$NUTS*28.3496
    
    
    #build new variables for food groups
    
    # Camille 15/10/2021: We want to match the food groups used in REGICOR to create various diet scores
    
    #### DAIRY ####
        pheno_fhs$MILK <- pheno_fhs$SKIM + pheno_fhs$MILK
    pheno_fhs$YOGHURT <- pheno_fhs$ICE_CR + pheno_fhs$YOG + pheno_fhs$CREAM + pheno_fhs$SOUR_CR
    pheno_fhs$CHEESE <- pheno_fhs$COT_CH + pheno_fhs$CR_CH + pheno_fhs$OTH_CH 
    pheno_fhs$DAIRY <- pheno_fhs$SKIM + pheno_fhs$MILK + pheno_fhs$ICE_CR + pheno_fhs$YOG + 
      pheno_fhs$COT_CH + pheno_fhs$CR_CH + pheno_fhs$OTH_CH + pheno_fhs$CREAM + 
      pheno_fhs$SOUR_CR
        # Low fat dairy
    pheno_fhs$LFDAIRY <- pheno_fhs$SKIM + pheno_fhs$YOGHURT + pheno_fhs$COT_CH 
    
    #### ANIMAL FAT ####
    pheno_fhs$AN_FATS <- pheno_fhs$BU 
                          # I don't know what that is and a lot of missing 
                          #+ pheno_fhs$FB + pheno_fhs$FL + pheno_fhs$BB + pheno_fhs$BL
    
    
    #### VEGETAL FAT ####
    # Margarine and peanut butter
    pheno_fhs$VEG_FATS <- pheno_fhs$MARGARIN + pheno_fhs$P_BU
    
    # NEED TO RESOLVE THE OIL QUESTION
    
    #### FRUITS & NUTS ####
        # Other fruits 
    pheno_fhs$OTH_FRUITS <-  pheno_fhs$BAN + pheno_fhs$CANT +   pheno_fhs$H20MEL + pheno_fhs$APP  
                            + pheno_fhs$PEACH_CN + pheno_fhs$STRAW + pheno_fhs$BLUE
        # Citrus fruits
    pheno_fhs$CTR_FRUITS <- pheno_fhs$ORANG + pheno_fhs$GRFRT 
        # Total fruits = citrus + other
    pheno_fhs$FRUIT <- pheno_fhs$OTH_FRUITS + pheno_fhs$CTR_FRUITS 
    
        # Nuts and dried fruit (raisins and prunes)
    pheno_fhs$NUT <- pheno_fhs$NUTS + pheno_fhs$RAIS + pheno_fhs$PRUN
        # Fruits + Nuts
    pheno_fhs$FRUITNUT <- pheno_fhs$NUT + pheno_fhs$FRUIT
        # Fruit juice
    pheno_fhs$FRUITJUICE <- pheno_fhs$O_J + pheno_fhs$GRFRT_J + pheno_fhs$A_J + pheno_fhs$TOM_J
        # A variable "fruit" with fruit juice up to 100 mL
    pheno_fhs$FRUITOT    <- with(pheno_fhs,ifelse(FRUITJUICE>=100,FRUIT+100,FRUIT+FRUITJUICE))
            # DASH Variable Fruit + Fruit juice
    pheno_fhs$FRUITDASH <- pheno_fhs$FRUIT + pheno_fhs$FRUITJUICE 
    
    #### VEGETABLES ####    
    pheno_fhs$GRN_VEG <- pheno_fhs$BROC + pheno_fhs$CABB + pheno_fhs$CAUL + pheno_fhs$BRUSL + 
                          pheno_fhs$SPIN_CKD + pheno_fhs$SPIN_RAW + pheno_fhs$KALE + pheno_fhs$ICE_LET + 
                          pheno_fhs$ROM_LET + pheno_fhs$ST_BEANS +  pheno_fhs$TOM +
                          pheno_fhs$CARROT_R + pheno_fhs$CARROT_C + pheno_fhs$ZUKE + pheno_fhs$YEL_SQS +
                          pheno_fhs$YAMS + pheno_fhs$CELERY + pheno_fhs$BEET
    
    #### LEGUMES ####      
    pheno_fhs$LEGUMES <- pheno_fhs$BEANS +  pheno_fhs$PEAS + pheno_fhs$TOFU

    #### POTATOES ####  
    pheno_fhs$POTATO  <- pheno_fhs$MASH_POT + pheno_fhs$FF_POT + pheno_fhs$POT_CHI
    pheno_fhs$POTATOHEALTHY  <- pheno_fhs$MASH_POT  
    pheno_fhs$POTATOFRIED  <-  pheno_fhs$FF_POT + pheno_fhs$POT_CHI  
      
    pheno_fhs$EGGS    <- pheno_fhs$EGGS
    pheno_fhs$WH_MEAT <- pheno_fhs$CHIX_NO + pheno_fhs$CHIX_SK
    pheno_fhs$RD_MEAT <- pheno_fhs$BEEF + pheno_fhs$HAMB
    pheno_fhs$PR_MEAT <- pheno_fhs$BACON + pheno_fhs$HOTDOG + pheno_fhs$PROC_MTS
    pheno_fhs$BL_FISH <- pheno_fhs$DK_FISH
    pheno_fhs$OTH_FISH <- pheno_fhs$OTH_FISH
    pheno_fhs$CAN_FISH <- pheno_fhs$TUNA
    pheno_fhs$SEAFOOD <- pheno_fhs$SHRIMP
    pheno_fhs$WT_BREAD <- pheno_fhs$WH_BR
    pheno_fhs$BR_BREAD <- pheno_fhs$DK_BR
    pheno_fhs$OTH_GRAINS <- pheno_fhs$WH_RICE + pheno_fhs$PASTA + pheno_fhs$BR_RICE + pheno_fhs$CKD_OATS +
      pheno_fhs$CORN + pheno_fhs$COLD_CER + pheno_fhs$CKD_CER + pheno_fhs$GRAINS
    pheno_fhs$PASTRY <- pheno_fhs$MUFF + pheno_fhs$DONUT + pheno_fhs$ENG_MUFF + pheno_fhs$PANCAKE + pheno_fhs$CRAX
    pheno_fhs$SWT_CAKE <- pheno_fhs$CAKE_HOM + pheno_fhs$CANDYNUT + pheno_fhs$CANDY + 
      pheno_fhs$COOX_HOM + pheno_fhs$COOX_COM + pheno_fhs$BROWNIE
    pheno_fhs$CAKE_COM + pheno_fhs$S_ROLL_H + pheno_fhs$S_ROLL_C + 
      pheno_fhs$PIE_HOME + pheno_fhs$PIE_COMM + pheno_fhs$JAM
    pheno_fhs$SW_DRINK <- pheno_fhs$COKE + pheno_fhs$COKE_NO + pheno_fhs$OTH_CARB
    pheno_fhs$COFFEE <- pheno_fhs$DECAF + pheno_fhs$COFF
    pheno_fhs$TEA <- pheno_fhs$TEA
    
    
    pheno_fhs$ALCOHOL <- pheno_fhs$R_WINE + pheno_fhs$W_WINE + pheno_fhs$LIQ + pheno_fhs$PUNCH + pheno_fhs$BEER
    pheno_fhs$CHOC <- pheno_fhs$CHOC
    
    
    #vectores que contienen los nombres de las categorias
    food_groups <- c("DAIRY", "VEG_FATS", "AN_FATS", "OTH_FRUITS",
                     "CTR_FRUITS", "GRN_VEG", "OTH_VEG", "LEGUMES", "EGGS", 
                     "WH_MEAT", "RD_MEAT", "PR_MEAT", "BL_FISH", "OTH_FISH",
                     "CAN_FISH", "SEAFOOD", "WT_BREAD", "BR_BREAD", "OTH_GRAINS",
                     "PIZZA", "POTATO", "FRIED", "PASTRY", "SWT_CAKE", "SW_DRINK",
                     "COFFEE", "TEA", "SPIRIT", "CHOC", "NUTS")
    
    #normalizar por kcal
    for (i in food_groups){
      print(i)
      pheno_fhs[,paste(i,"_n",sep="")]<-(pheno_fhs[,i]/pheno_fhs$NUT_CALOR)*2000 
    }
    
    food_groups_n <- c("DAIRY_n", "VEG_FATS_n", "AN_FATS_n", "OTH_FRUITS_n",
                       "CTR_FRUITS_n", "GRN_VEG_n", "OTH_VEG_n", "LEGUMES_n", "EGGS_n", 
                       "WH_MEAT_n", "RD_MEAT_n", "PR_MEAT_n", "BL_FISH_n", "OTH_FISH_n",
                       "CAN_FISH_n", "SEAFOOD_n", "WT_BREAD_n", "BR_BREAD_n", "OTH_GRAINS_n",
                       "PIZZA_n", "POTATO_n", "FRIED_n", "PASTRY_n", "SWT_CAKE_n", "SW_DRINK_n",
                       "COFFEE_n", "TEA_n", "SPIRIT_n", "CHOC_n", "NUTS_n")
    
    #convertir las variables de grupos de alimentos CORREGIDAS POR KCAL en normales
    #definir funcion de IHS (inverse hyperbolic sine) y ejecutarla
    IHS<-function(z){log(z+sqrt(z^2 + 1))}
    for (i in food_groups_n){
      print(i)
      pheno_fhs[,paste(i,"_IHS",sep="")]<-IHS(pheno_fhs[,i])
    }
    
    #calculo bmi
    pheno_fhs$bmi <- pheno_fhs$weight/(pheno_fhs$height/100)*(pheno_fhs$height/100)
    
    data_f<-pheno_fhs[,c(2:4, 29, 33:38, 52:54, 225:254)]
    save(data_f,file="phenotype_framingham.RData")
    
    #pasar variables a factor
    levels(pheno_fhs$sex)<-c("Male","Female")
    levels(pheno_fhs$smoke)<-c("Current", "Non-smoker (1-5a)", "Non-smoker (>5a)", "Ever smoker")
    pheno_fhs$medicol=as.factor(pheno_fhs$medicol)
    levels(pheno_fhs$medicol)<-c("No cholesterol treated","Cholesterol treated")
    pheno_fhs$medita=as.factor(pheno_fhs$medita)
    levels(pheno_fhs$medita)<-c("No hypertension treated","Hypertension treated")
    
    pheno_fhs$hypertension<-ifelse(pheno_fhs$sbp<140&pheno_fhs$dbp<90&pheno_fhs$medita==1,0,1)
    pheno_fhs$cholesterol_treatment<-ifelse(pheno_fhs$medicol==1,1,0)
    pheno_fhs$ta_treatment<-ifelse(pheno_fhs$medita==1,1,0)
    
    pheno_fhs$hypertension<-as.factor(pheno_fhs$hypertension)
    levels(pheno_fhs$hypertension)<-c("Non hypertensive","Hypertensive")
    pheno_fhs$cholesterol_treatment<-as.factor(pheno_fhs$cholesterol_treatment)
    levels(pheno_fhs$cholesterol_treatment)<-c("No cholesterol treated","Cholesterol treated")
    pheno_fhs$ta_treatment<-as.factor(pheno_fhs$ta_treatment)
    levels(pheno_fhs$ta_treatment)<-c("No hypertension treated","Hypertension treated")
    
    #tabla descriptiva
    res1<-compareGroups(~ age + sex + sbp + dbp + tot_chol + ldl_chol + 
                          hdl_chol + trig + glucose + waist_i + bmi + 
                          smoke + medicol + medita +
                          hypertension + cholesterol_treatment + ta_treatment +
                          DAIRY + VEG_FATS+AN_FATS+OTH_FRUITS+CTR_FRUITS + 
                          GRN_VEG+OTH_VEG+LEGUMES+EGGS+WH_MEAT+RD_MEAT+PR_MEAT+
                          BL_FISH+OTH_FISH+CAN_FISH+SEAFOOD+WT_BREAD+BR_BREAD+OTH_GRAINS+
                          PIZZA+POTATO+FRIED+PASTRY+SWT_CAKE+SW_DRINK+COFFEE+
                          TEA+SPIRIT+CHOC+NUTS,data=pheno_fhs, method=c(trig=2,DAIRY=2,
                                                                     VEG_FATS=2,
                                                                     AN_FATS=2, OTH_FRUITS=2, CTR_FRUITS=2, 
                                                                     GRN_VEG=2, OTH_VEG=2, LEGUMES=2, EGGS=2,
                                                                     WH_MEAT=2, RD_MEAT=2, PR_MEAT=2, 
                                                                     BL_FISH=2, OTH_FISH=2, CAN_FISH=2, SEAFOOD=2,
                                                                     WT_BREAD=2, BR_BREAD=2, OTH_GRAINS=2, 
                                                                     PIZZA=2, POTATO=2, FRIED=2, PASTRY=2, SWT_CAKE=2,
                                                                     SW_DRINK=2, COFFEE=2,TEA=2, SPIRIT=2, CHOC=2, NUTS=2))
    descriptive_table_NOnormalizedkcal_framingham <- createTable(res1)
    export2csv(descriptive_table_NOnormalizedkcal_framingham,"U://Assessories/SSayols/RCortes/analysis/descriptivos/framingham/descriptive_table_NOnormalizedkcal_framingham.csv",sep=";")
    
    
    #histogramas
    food_groups_histograms <- c("DAIRY", "VEG_FATS", "OTH_FRUITS",
                     "CTR_FRUITS", "GRN_VEG", "OTH_VEG", "LEGUMES", "EGGS", 
                     "WH_MEAT", "RD_MEAT", "PR_MEAT", "BL_FISH", "OTH_FISH",
                     "CAN_FISH", "SEAFOOD", "WT_BREAD", "BR_BREAD", "OTH_GRAINS",
                     "PIZZA", "POTATO", "FRIED", "PASTRY", "SWT_CAKE", "SW_DRINK",
                     "COFFEE", "TEA", "SPIRIT", "CHOC", "NUTS")
    for (i in food_groups_histograms){
      print(i)
      png(paste("U://Assessories/SSayols/RCortes/hist_goups_",i,"_FRAMINGHAM.png",sep=""))
      hist(pheno_fhs[,i],col="grey")
      dev.off()
    }
    
    #histogramas de variables normalizadas por kcal
    food_groups_n_histograms <- c("DAIRY_n", "VEG_FATS_n", "OTH_FRUITS_n",
                       "CTR_FRUITS_n", "GRN_VEG_n", "OTH_VEG_n", "LEGUMES_n", "EGGS_n", 
                       "WH_MEAT_n", "RD_MEAT_n", "PR_MEAT_n", "BL_FISH_n", "OTH_FISH_n",
                       "CAN_FISH_n", "SEAFOOD_n", "WT_BREAD_n", "BR_BREAD_n", "OTH_GRAINS_n",
                       "PIZZA_n", "POTATO_n", "FRIED_n", "PASTRY_n", "SWT_CAKE_n", "SW_DRINK_n",
                       "COFFEE_n", "TEA_n", "SPIRIT_n", "CHOC_n", "NUTS_n")
    for (i in food_groups_n_histograms){
      print(i)
      png(paste("U://Assessories/SSayols/RCortes/hist_goups_n_",i,"_FRAMINGHAM.png",sep=""))
      hist(pheno_fhs[,i],col="grey")
      dev.off()
    }
    
    #comprobar que ahora tienen una distribucion normal haciendo histograma
    food_groups_n_IHS <- c(names(pheno_fhs)[226:227], names(pheno_fhs)[229:255])
    
    for (i in food_groups_n_IHS){
      print(i)
      png(paste("U://Assessories/SSayols/RCortes/hist_goups_n_IHS",i,"_FRAMINGHAM.png",sep=""))
      hist(pheno_fhs[,i],col="grey")
      dev.off()
    }