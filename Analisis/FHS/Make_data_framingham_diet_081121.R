#### ORIGINAL CODE "framingham_variablegroups_descriptivetable" found in U:\Assessories\Antics\SSayols\RCortes\analysis\descriptivos\framingham

## The variable labels of each food and conversion table from US unit (Oz) to grams is found in the same folder, Word document "variables conversion" ##

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

###################
### We have to download again the FFQ dataset from dbgap because some variables were missing
################### 
rm(list=ls())
dades<-read.table("U:/Estudis/B64_DIAMETR/Dades/FHS/phs000007.v32.pht000682.v7.p13.c1.ffreq1_7s.HMB-IRB-MDS.txt",header=T,sep="\t",quote="",stringsAsFactors=F)
# list of foods for loop
foods <- c(names(dades)[43:173])

summary(dades$NUT_K)
table(dades$FFQ_VAL)
table(dades$BLNKSF)
# The data is already cleaned: only the 2430 participants with a valid FFQ.
# Definition of valid: VALIDITY MARKER FOR FFQ BASED ON A CALORIE MINIMUM AND MAXIMUM AND NUMBER OF BLANKS (13). 
# MEN: LESS THAN 13 BLANKS ON FFQ AND CALORIES (NUT_CALOR) BETWEEN 600 - 4199. 
# WOMEN: LESS THAN 13 BLANKS ON FFQ AND CALORIES (NUT_CALOR) BETWEEN 600 - 3999.

# We load the phenotype dataset found on the cluster in projects/regicor/data/FHS/phenotype
load("U:/Estudis/B64_DIAMETR/Dades/FHS/pheno_FHS_analysis.RData")



small_dades<-as.data.frame(c(dades[,2]))
small_pheno<-as.data.frame(c(pheno_fhs[,2]))
names(small_dades)<-"id"
names(small_pheno)<-"id"
setdiff(small_dades,small_pheno)
# 245 participants are in the FFQ database but not in FHS pheno

setdiff(small_pheno,small_dades)
# 357 participants are in the FHS pheno database but not in the FFQ

#### JUST A CHECK OF DERIVED VARIABLES
# We apply the conversion factor
#Pasar los fatos de frecuencia a NUMERO DE RACIONES DIARIAS
# conversion de los numeros de frecuencia a numero de raciones por dia
# se ha usado el valor medio del intervalo
# si 2 quiere decir de 1 a 3 veces al mes, se han tomado dos veces al mes
#for(j in foods){
#  print (j)
#  pheno_fhs[,j]=ifelse(pheno_fhs[,j]==1,0.495/30,
#                       ifelse(pheno_fhs[,j]==2,2/30,
#                              ifelse(pheno_fhs[,j]==3,1/7,
#                                     ifelse(pheno_fhs[,j]==4,3/7,
#                                            ifelse(pheno_fhs[,j]==5,5.5/7,
#                                                   ifelse(pheno_fhs[,j]==6,1,
#                                                          ifelse(pheno_fhs[,j]==7,2.5,
#                                                                 ifelse(pheno_fhs[,j]==8,4.5,
#                                                                        ifelse(pheno_fhs[,j]==9,6,NA)))))))))
#  
#  
#}
## Check if this is the same as the derived variables provided in dbgap
#dades$APPLED <-dades$FFD35/7 # the variables are in number of portions per week so we divide by 7 to have it by day
#table(dades$APPLED)
#table(pheno_fhs$APPLE)
# All the same except for the 2 lower frequencies
# The derived variables have a 0 but we have 0.016, because the category says "NEVER or less than once a month", so not exactly 0
# The derived variables have 0.06714 but we have 0.0667 --> virtually the same

#########



# Keep variables that are useful, we remove use of supplements and the derived variables
foodvar <- c(names(dades)[2],names(dades)[43:203], names(dades)[221:358])
dades<-dades[,foodvar]

#Merge the phenotypic and food  database
pheno_fhs<-merge(pheno_fhs,dades,by="shareid",all.x=T)


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

# For each food group, replace missing by 0

for(i in 1:length(foods))
  
{
  pheno_fhs[,foods[i]]<-as.numeric(with(pheno_fhs,ifelse(is.na(pheno_fhs$NUT_CALOR),NA,
                                                          ifelse(is.na(pheno_fhs[,foods[i]]),0,pheno_fhs[,foods[i]]))))
}

table(pheno_fhs$CHIX_SK, useNA="always")
table(pheno_fhs$CHIX_NO)
table(pheno_fhs$LIVER)
table(pheno_fhs$BACON)
table(pheno_fhs$HOTDOG)
table(pheno_fhs$SAND_BF)
table(pheno_fhs$PROC_MTS)
table(pheno_fhs$HAMB)
table(pheno_fhs$BEEF, useNA="always")
####PASAR VARIABLES A GRAMOS POR DIA####


#Multiplicar por el NUMERO DE RACIONES DIARIAS por los GRAMOS POR RACION para tener GRAMOS POR DIA
pheno_fhs$SKIM<-pheno_fhs$SKIM*226.796
pheno_fhs$MILK<-pheno_fhs$MILK*226.796
pheno_fhs$CREAM<-pheno_fhs$CREAM*15
pheno_fhs$SOUR_CR<-pheno_fhs$SOUR_CR*12
pheno_fhs$ICE_CR<-pheno_fhs$ICE_CR*86
pheno_fhs$SHERB<-pheno_fhs$SHERB*86
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
pheno_fhs$MIX_VEG<-pheno_fhs$MIX_VEG*45
pheno_fhs$YAMS<-pheno_fhs$YAMS*66.5
pheno_fhs$SPIN_CKD<-pheno_fhs$SPIN_CKD*90
pheno_fhs$SPIN_RAW<-pheno_fhs$SPIN_RAW*15
pheno_fhs$KALE<-pheno_fhs$KALE*33
pheno_fhs$ALF_SPRT<-pheno_fhs$ALF_SPRT*16
pheno_fhs$GARLIC<-pheno_fhs$GARLIC*5.5
pheno_fhs$ICE_LET<-pheno_fhs$ICE_LET*89
pheno_fhs$ROM_LET<-pheno_fhs$ROM_LET*85
pheno_fhs$CELERY<-pheno_fhs$CELERY*4
pheno_fhs$BEET<-pheno_fhs$BEET*68
pheno_fhs$EGGS<-pheno_fhs$EGGS*44
pheno_fhs$CHIX_SK<-pheno_fhs$CHIX_SK*141.7475
pheno_fhs$CHIX_NO<-pheno_fhs$CHIX_NO*141.7475
pheno_fhs$LIVER<-pheno_fhs$LIVER*85.0486
pheno_fhs$BACON<-pheno_fhs$BACON*56
pheno_fhs$HOTDOG<-pheno_fhs$HOTDOG*42
pheno_fhs$SAND_BF<-pheno_fhs$SAND_BF*60
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
pheno_fhs$P_BU<-pheno_fhs$P_BU*16
pheno_fhs$POPC<-pheno_fhs$POPC*8
pheno_fhs$NUTS<-pheno_fhs$NUTS*28.3496
pheno_fhs$O_AND_V<-pheno_fhs$O_AND_V*14
pheno_fhs$CHOW<-pheno_fhs$CHOW*244
pheno_fhs$BRAN<-pheno_fhs$BRAN*8.28
pheno_fhs$WH_GERM<-pheno_fhs$WH_GERM*5.2
pheno_fhs$MAYO<-pheno_fhs$MAYO*14.4


#build new variables for food groups

# Camille 15/10/2021: We want to match the food groups used in REGICOR to create various diet scores

########    1. ANIMAL PRODUCTS     ####

pheno_fhs$eggs    <- pheno_fhs$EGGS



#### MEAT ####

pheno_fhs$poultry <- pheno_fhs$CHIX_NO + pheno_fhs$CHIX_SK
pheno_fhs$rd_meat <- pheno_fhs$BEEF + pheno_fhs$HAMB + pheno_fhs$LIVER + pheno_fhs$SAND_BF
pheno_fhs$pr_meat <- pheno_fhs$BACON + pheno_fhs$HOTDOG + pheno_fhs$PROC_MTS
# Red and processed meat
pheno_fhs$redmeat <- pheno_fhs$rd_meat + pheno_fhs$pr_meat
# Total meat
pheno_fhs$meat <- pheno_fhs$redmeat + pheno_fhs$poultry


#### FISH ####
pheno_fhs$fish <- pheno_fhs$DK_FISH + pheno_fhs$OTH_FISH + pheno_fhs$TUNA + pheno_fhs$SHRIMP
# fresh and frozen fish excluding canned fish (tuna)
pheno_fhs$ffish <- pheno_fhs$fish - pheno_fhs$TUNA



#### DAIRY ####
pheno_fhs$milk <- pheno_fhs$SKIM + pheno_fhs$MILK
pheno_fhs$cheese <- pheno_fhs$COT_CH + pheno_fhs$CR_CH + pheno_fhs$OTH_CH 

pheno_fhs$dairy <- pheno_fhs$SKIM + pheno_fhs$MILK + pheno_fhs$ICE_CR + pheno_fhs$SHERB + 
  pheno_fhs$YOG +  pheno_fhs$COT_CH + pheno_fhs$CR_CH + pheno_fhs$OTH_CH + pheno_fhs$CREAM + 
  pheno_fhs$SOUR_CR 

# Low fat dairy
pheno_fhs$lfdairy <- pheno_fhs$SKIM + pheno_fhs$YOG + pheno_fhs$COT_CH 
table(pheno_fhs$lfdairy, useNA="always")

#### ANIMAL FAT ####
table(pheno_fhs$BL)
# If declares that uses butter or lard for cooking, then use =1
pheno_fhs$anifatuse <- with(pheno_fhs,ifelse(FB==1|FL==1|BB==1|BL==1,1,0))
# Replace NA by 0
pheno_fhs$anifatuse <- as.numeric(with(pheno_fhs,ifelse(is.na(NUT_CALOR),NA,
                                                        ifelse(is.na(anifatuse),0,anifatuse))))
table(pheno_fhs$anifatuse, useNA="always") #OK
#now we take into account the frequency of frying (FFH), assuming 10g
pheno_fhs$anifatqty <- as.numeric(with(pheno_fhs,ifelse(is.na(anifatuse),NA,
                                                        ifelse(anifatuse==1,
                                                              ifelse(FFH==1,10,
                                                                    ifelse(FFH==2,2.86,
                                                                          ifelse(FFH==3,7.14,
                                                                                ifelse(FFH==4,0.72,NA)))),0))))

table(pheno_fhs$anifatqty, useNA="always")
# Total animal fat is butter not used for cooking + quantity of animal fat for frying
pheno_fhs$anifat <- pheno_fhs$BU + pheno_fhs$anifatqty
table(pheno_fhs$FFH,pheno_fhs$anifatuse, useNA="always")

#### MISCELLANEOUS ANIMAL FOOD: Spanish food and fast food hamburgers ####
# Not applicable here


########   2. PLANT PRODUCTS     ####

#### CEREALS ####
pheno_fhs$bread <- pheno_fhs$WH_BR + pheno_fhs$DK_BR +  pheno_fhs$ENG_MUFF + pheno_fhs$CRAX + 0.5*pheno_fhs$PIZZA
pheno_fhs$bkcereals <- pheno_fhs$CKD_OATS + pheno_fhs$COLD_CER + pheno_fhs$CKD_CER 
pheno_fhs$ricepasta <- pheno_fhs$WH_RICE + pheno_fhs$PASTA + pheno_fhs$BR_RICE +
                        pheno_fhs$CORN + pheno_fhs$GRAINS
# Total cereals
pheno_fhs$cereals <- pheno_fhs$bread + pheno_fhs$bkcereals + pheno_fhs$ricepasta

# Whole grains
pheno_fhs$wholegrain <- pheno_fhs$DK_BR + pheno_fhs$CKD_OATS + pheno_fhs$CKD_CER + pheno_fhs$BR_RICE + pheno_fhs$CORN
# Refined grains
pheno_fhs$refgrain <- pheno_fhs$cereals - pheno_fhs$wholegrain 






#### VEGETABLES ####    
# We count all the vegetables except tomato juice and legumes (beans/lentils, peas, tofu)
pheno_fhs$veg <- pheno_fhs$BROC + pheno_fhs$CABB + pheno_fhs$CAUL + pheno_fhs$BRUSL + 
                 pheno_fhs$SPIN_CKD + pheno_fhs$SPIN_RAW + pheno_fhs$KALE + pheno_fhs$ICE_LET + 
                 pheno_fhs$ROM_LET + pheno_fhs$ST_BEANS +  pheno_fhs$TOM + + pheno_fhs$MIX_VEG +
                 pheno_fhs$CARROT_R + pheno_fhs$CARROT_C + pheno_fhs$ZUKE + pheno_fhs$YEL_SQS +
                 pheno_fhs$YAMS + pheno_fhs$CELERY + pheno_fhs$BEET + pheno_fhs$ALF_SPRT + pheno_fhs$GARLIC

#### LEGUMES ####     
# Beans or lentils, peas, tofu
pheno_fhs$legumes <- pheno_fhs$BEANS +  pheno_fhs$PEAS + pheno_fhs$TOFU

#### POTATOES ####  
pheno_fhs$potato  <- pheno_fhs$MASH_POT + pheno_fhs$FF_POT + pheno_fhs$POT_CHI
pheno_fhs$potatohealthy  <- pheno_fhs$MASH_POT  
pheno_fhs$potatofried  <-  pheno_fhs$FF_POT + pheno_fhs$POT_CHI  


#### FRUITS & NUTS ####
# Other fruits 
pheno_fhs$oth_fruit <-  pheno_fhs$BAN + pheno_fhs$CANT +   pheno_fhs$H20MEL + pheno_fhs$APP  + 
                        pheno_fhs$PEACH_CN + pheno_fhs$STRAW + pheno_fhs$BLUE
# Citrus fruits
pheno_fhs$ctr_fruit <- pheno_fhs$ORANG + pheno_fhs$GRFRT 
# Total fruits = citrus + other
pheno_fhs$fruit <- pheno_fhs$oth_fruit + pheno_fhs$ctr_fruit 
summary(pheno_fhs$fruit)


# Nuts, peanut butter and dried fruit (raisins and prunes)
pheno_fhs$nut <- pheno_fhs$NUTS + pheno_fhs$RAIS + pheno_fhs$PRUN + pheno_fhs$P_BU 
# Fruits + Nuts
pheno_fhs$fruitnut <- pheno_fhs$nut + pheno_fhs$fruit
summary(pheno_fhs$nut)
summary(pheno_fhs$fruitnut)

# Legumes and nuts together for DASH
pheno_fhs$legumenut <-pheno_fhs$legumes + pheno_fhs$NUTS + pheno_fhs$P_BU 

# Fruit juice
# This includes orange juice, grapefruit juice, apple juice and tomato juice
pheno_fhs$fruitjuice <- pheno_fhs$O_J + pheno_fhs$GRFRT_J + pheno_fhs$A_J + pheno_fhs$TOM_J
# A variable "fruit" with fruit juice up to 100 mL
pheno_fhs$fruittot    <- with(pheno_fhs,ifelse(fruitjuice>=100,fruit+100,fruit+fruitjuice))
# DASH Variable Fruit + Fruit juice
pheno_fhs$fruitdash <- pheno_fhs$fruit + pheno_fhs$fruitjuice 

#### VEGETAL FAT ####

# If declares that uses vegetable oil, shortening or margarine for cooking or for baking, use=1
pheno_fhs$vegfatuse <- with(pheno_fhs,ifelse(FM==1|FVO==1|FSH==1|BM==1|BVO==1|BSH==1,1,0))
# Replace NA by 0
pheno_fhs$vegfatuse <- as.numeric(with(pheno_fhs,ifelse(is.na(NUT_CALOR),NA,
                                                        ifelse(is.na(vegfatuse),0,vegfatuse))))
table(pheno_fhs$vegfatuse, useNA="always") #OK
#now we take into account the frequency of frying (FFH), assuming 10g
pheno_fhs$vegfatqty <- as.numeric(with(pheno_fhs,ifelse(is.na(vegfatuse),NA,
                                                        ifelse(vegfatuse==1,
                                                               ifelse(FFH==1,10,
                                                                      ifelse(FFH==2,2.86,
                                                                             ifelse(FFH==3,7.14,
                                                                                    ifelse(FFH==4,0.72,NA)))),0))))
table(pheno_fhs$FFH, useNA="always")
table(pheno_fhs$vegfatqty, useNA="always")

# Total vegetal fat is oil used for dressing (oil and vinegar) + quantity of vegetable fat for frying/baking
pheno_fhs$vegfat <- pheno_fhs$O_AND_V + pheno_fhs$vegfatqty

# OLIVE OIL
# There is one question on the type of oil usually used for cooking 
# So we just create a qualitative yes/no variable on use of olive oil
# for some of the Med diet scores we can use the monounsaturated / saturated fat ratio
# because this information is available as NUT_ variable
pheno_fhs$oliveoiluse <- with(pheno_fhs,ifelse(is.na(NUT_CALOR),NA,
                                               ifelse(OIL==10|OIL==46|OIL==48,1,0)))
table(pheno_fhs$oliveoiluse, pheno_fhs$vegfatuse, useNA="always")
# 10=Any Olive Oil, 46=Filipo Berio Pure Olive Oil, 48=Pastine Pure Olive Oil

pheno_fhs$mufasfa    <- with(pheno_fhs,NUT_MONFAT/NUT_SATFAT)

#### COFFEE AND TEA ####

pheno_fhs$coffee <- pheno_fhs$DECAF + pheno_fhs$COFF


pheno_fhs$coffeetea <- pheno_fhs$coffee + pheno_fhs$TEA

#### SWEET AND DESSERT ####

pheno_fhs$sweet <- pheno_fhs$MUFF + pheno_fhs$DONUT  + pheno_fhs$PANCAKE + pheno_fhs$CAKE_HOM + pheno_fhs$CAKE_COM + 
                   pheno_fhs$CANDYNUT + pheno_fhs$CANDY + pheno_fhs$COOX_HOM + pheno_fhs$COOX_COM + 
                   pheno_fhs$BROWNIE + pheno_fhs$S_ROLL_H + pheno_fhs$S_ROLL_C + 
                   pheno_fhs$PIE_HOME + pheno_fhs$PIE_COMM + pheno_fhs$JAM + pheno_fhs$CHOC
  
########    3. ALCOHOL     ####

pheno_fhs$alcoholdrink <- pheno_fhs$R_WINE + pheno_fhs$W_WINE + pheno_fhs$LIQ + pheno_fhs$PUNCH + pheno_fhs$BEER

pheno_fhs$ethanol <- pheno_fhs$NUT_ALCO

########    4. Soft drinks     ####

pheno_fhs$ssb <- pheno_fhs$COKE + pheno_fhs$COKE_NO + pheno_fhs$OTH_CARB + pheno_fhs$fruitjuice
pheno_fhs$ssbnojuice <- pheno_fhs$COKE + pheno_fhs$COKE_NO + pheno_fhs$OTH_CARB 



############################################################################

#############     Calculation of the DIET SCORES     ###################

############################################################################


##################################################################################
#############   1. MDS  - Trichopoulou 0-9, based on median of intake   ##########
##################################################################################
table(pheno_fhs$sex, useNA="always")
# Sex-specific medians and quartiles
medians<-ddply(pheno_fhs, .(sex), summarise, 
               med_cereals=median(cereals, na.rm = T), q1_cereals=quantile(cereals,0.25, na.rm=T), q3_cereals=quantile(cereals,0.75, na.rm=T),
               med_fish=median(fish, na.rm = T), q1_fish=quantile(fish,0.25, na.rm=T), q3_fish=quantile(fish,0.75, na.rm=T),
               med_redmeat=median(redmeat, na.rm = T), q1_redmeat=quantile(redmeat,0.25, na.rm=T), q3_redmeat=quantile(redmeat,0.75, na.rm=T),
               med_veg=median(veg, na.rm = T), q1_veg=quantile(veg,0.25, na.rm=T), q3_veg=quantile(veg,0.75, na.rm=T),
               med_fruitnut=median(fruitnut, na.rm = T), q1_fruitnut=quantile(fruitnut,0.25, na.rm=T), q3_fruitnut=quantile(fruitnut,0.75, na.rm=T),
               med_fruit=median(fruit, na.rm = T), q1_fruit=quantile(fruit,0.25, na.rm=T), q3_fruit=quantile(fruit,0.75, na.rm=T),
               med_nut=median(nut, na.rm = T), q1_nut=quantile(nut,0.25, na.rm=T), q3_nut=quantile(nut,0.75, na.rm=T),
               med_dairy=median(dairy, na.rm = T), q1_dairy=quantile(dairy,0.25, na.rm=T), q3_dairy=quantile(dairy,0.75, na.rm=T),
               med_legumes=median(legumes, na.rm = T), q1_legumes=quantile(legumes,0.25, na.rm=T), q3_legumes=quantile(legumes,0.75, na.rm=T),
               med_mufasfa=median(mufasfa, na.rm = T), q1_mufasfa=quantile(mufasfa,0.25, na.rm=T), q3_mufasfa=quantile(mufasfa,0.75, na.rm=T),
               med_wholegrain=median(wholegrain, na.rm = T), q1_wholegrain=quantile(wholegrain,0.25, na.rm=T), q3_wholegrain=quantile(wholegrain,0.75, na.rm=T))

medians

# Merge the dataset according to sex
pheno_fhs<-merge(pheno_fhs,medians,by="sex",all.x=TRUE,sort=FALSE)


# Creation of the 8 items according to the median
pheno_fhs$mds_cereal <- with(pheno_fhs,ifelse(cereals<med_cereals,0,1),na.rm=T)
pheno_fhs$mds_fish <- with(pheno_fhs,ifelse(fish<med_fish,0,1),na.rm=T)
pheno_fhs$mds_meat <- with(pheno_fhs,ifelse(redmeat>=med_redmeat,0,1),na.rm=T) #inverse
pheno_fhs$mds_veg <- with(pheno_fhs,ifelse(veg<med_veg,0,1),na.rm=T)
pheno_fhs$mds_fruit <- with(pheno_fhs,ifelse(fruitnut<med_fruitnut,0,1),na.rm=T) # Fruit and nuts in the score by Trichopoulou
pheno_fhs$mds_dairy <- with(pheno_fhs,ifelse(dairy>=med_dairy,0,1),na.rm=T)  #inverse
pheno_fhs$mds_legume <- with(pheno_fhs,ifelse(legumes<med_legumes,0,1),na.rm=T)
pheno_fhs$mds_mufasfa <- with(pheno_fhs,ifelse(mufasfa<med_mufasfa,0,1),na.rm=T)

table(pheno_fhs$mds_cereal, useNA = "always")
table(pheno_fhs$mds_fish, useNA = "always")
table(pheno_fhs$mds_meat, useNA = "always")
table(pheno_fhs$mds_veg, useNA = "always")
table(pheno_fhs$mds_fruit, useNA = "always")
table(pheno_fhs$mds_dairy, useNA = "always")
table(pheno_fhs$mds_legume, useNA = "always")
table(pheno_fhs$mds_mufasfa, useNA = "always")

# For the alcohol item, there are pre-defined thresholds
pheno_fhs$mds_alcohol <- with(pheno_fhs,ifelse(pheno_fhs$sex==1,
                                                 ifelse((pheno_fhs$ethanol<50 & pheno_fhs$ethanol>10),1,0),
                                                 ifelse((pheno_fhs$ethanol<25 & pheno_fhs$ethanol>5),1,0)))
table(pheno_fhs$mds_alcohol, useNA = "always")

# We check that it was done correctly

# Another way of describing by sex and item
ddply(pheno_fhs, .(sex,mds_alcohol), summarise, meanalc=mean(ethanol,na.rm=T), minalc=min(ethanol,na.rm=T), maxalc=max(ethanol,na.rm=T))
# OK #

pheno_fhs %>%   group_by(sex,mds_cereal) %>%  summarise(minalc=min(cereals, na.rm=T), maxalc=max(cereals, na.rm=T))
pheno_fhs %>%   group_by(sex,mds_fish) %>%  summarise(minalc=min(fish, na.rm=T), maxalc=max(fish, na.rm=T))
pheno_fhs %>%   group_by(sex,mds_meat) %>%  summarise(minalc=min(redmeat, na.rm=T), maxalc=max(redmeat, na.rm=T))
pheno_fhs %>%   group_by(sex,mds_veg) %>%  summarise(minalc=min(veg, na.rm=T), maxalc=max(veg, na.rm=T))
pheno_fhs %>%   group_by(sex,mds_fruit) %>%  summarise(minalc=min(fruitnut, na.rm=T), maxalc=max(fruitnut, na.rm=T))
pheno_fhs %>%   group_by(sex,mds_dairy) %>%  summarise(minalc=min(dairy, na.rm=T), maxalc=max(dairy, na.rm=T))
pheno_fhs %>%   group_by(sex,mds_legume) %>%  summarise(minalc=min(legumes, na.rm=T), maxalc=max(legumes, na.rm=T))
pheno_fhs %>%   group_by(sex,mds_mufasfa) %>%  summarise(minalc=min(mufasfa, na.rm=T), maxalc=max(mufasfa, na.rm=T))

table(pheno_fhs$mds_cereal, useNA = "always")
table(pheno_fhs$mds_fish, useNA = "always")
table(pheno_fhs$mds_meat, useNA = "always")
table(pheno_fhs$mds_veg, useNA = "always")
table(pheno_fhs$mds_fruit, useNA = "always")
table(pheno_fhs$mds_dairy, useNA = "always")
table(pheno_fhs$mds_legume, useNA = "always")
table(pheno_fhs$mds_mufasfa, useNA = "always") 
table(pheno_fhs$mds_alcohol, useNA = "always")

##############################
# Sum total score MDS 0 to 9 #
##############################

vars02<-c("mds_cereal","mds_fish","mds_meat","mds_veg","mds_fruit","mds_dairy","mds_legume","mds_mufasfa","mds_alcohol")
pheno_fhs$mds <- apply(pheno_fhs[,vars02],1,sum,na.rm=F) 

table(pheno_fhs$mds, useNA = "always")
histogram(pheno_fhs$mds)
mean(pheno_fhs$mds,na.rm=T)



# Description by sex
# Create factor variables for use in CreateTableOne
pheno_fhs$mds_cerealf <- as.factor(pheno_fhs$mds_cereal)
pheno_fhs$mds_fishf <- as.factor(pheno_fhs$mds_fish)
pheno_fhs$mds_meatf <- as.factor(pheno_fhs$mds_meat)
pheno_fhs$mds_vegf <- as.factor(pheno_fhs$mds_veg)
pheno_fhs$mds_fruitf <- as.factor(pheno_fhs$mds_fruit)
pheno_fhs$mds_dairyf <- as.factor(pheno_fhs$mds_dairy)
pheno_fhs$mds_legumef <- as.factor(pheno_fhs$mds_legume)
pheno_fhs$mds_mufasfaf <- as.factor(pheno_fhs$mds_mufasfa)
pheno_fhs$mds_alcoholf <- as.factor(pheno_fhs$mds_alcohol)

vars03<-c("mds_cerealf","mds_fishf","mds_meatf","mds_vegf","mds_fruitf","mds_dairyf","mds_legumef","mds_mufasfaf","mds_alcoholf","mds")
tab <-CreateTableOne(vars03,strata="sex",data=pheno_fhs)
try<-print(tab,  noSpaces = TRUE)


##################################################################################
#############   2. MMDS  - Ma et al 2020, 0-25 based on quartiles        #########
##################################################################################


pheno_fhs$mmds_wgrain <- with(pheno_fhs,ifelse(wholegrain<=q1_wholegrain,0,
                                                 ifelse(wholegrain<=med_wholegrain,1,
                                                        ifelse(wholegrain<=q3_wholegrain,2,3))),na.rm=T)
table(pheno_fhs$mmds_wgrain, useNA = "always")
pheno_fhs$mmds_fish <- with(pheno_fhs,ifelse(fish<=q1_fish,0,
                                               ifelse(fish<=med_fish,1,
                                                      ifelse(fish<=q3_fish,2,3))),na.rm=T)
table(pheno_fhs$mmds_fish, useNA = "always")

pheno_fhs$mmds_meat <- with(pheno_fhs,ifelse(redmeat<q1_redmeat,3, #???inverse
                                               ifelse(redmeat<med_redmeat,2,
                                                      ifelse(redmeat<q3_redmeat,1,0))),na.rm=T)
pheno_fhs$mmds_veg <- with(pheno_fhs,ifelse(veg<=q1_veg,0,
                                              ifelse(veg<=med_veg,1,
                                                     ifelse(veg<=q3_veg,2,3))),na.rm=T)
pheno_fhs$mmds_fruit <- with(pheno_fhs,ifelse(fruit<=q1_fruit,0,
                                                ifelse(fruit<=med_fruit,1,
                                                       ifelse(fruit<=q3_fruit,2,3))),na.rm=T)
pheno_fhs$mmds_nut <- with(pheno_fhs,ifelse(nut<=q1_nut,0,
                                              ifelse(nut<=med_nut,1,
                                                     ifelse(nut<=q3_nut,2,3))),na.rm=T)
pheno_fhs$mmds_legume <- with(pheno_fhs,ifelse(legumes<=q1_legumes,0,
                                                 ifelse(legumes<=med_legumes,1,
                                                        ifelse(legumes<=q3_legumes,2,3))),na.rm=T)
pheno_fhs$mmds_mufasfa <- with(pheno_fhs,ifelse(mufasfa<=q1_mufasfa,0,
                                                  ifelse(mufasfa<=med_mufasfa,1,
                                                         ifelse(mufasfa<=q3_mufasfa,2,3))),na.rm=T)
table(pheno_fhs$mmds_meat, useNA = "always")
table(pheno_fhs$mmds_veg, useNA = "always")
table(pheno_fhs$mmds_fruit, useNA = "always")
table(pheno_fhs$mmds_nut, useNA = "always")
table(pheno_fhs$mmds_legume, useNA = "always")
table(pheno_fhs$mmds_mufasfa, useNA = "always")

pheno_fhs %>% 
  group_by(sex,mmds_wgrain) %>% 
  summarise(min=min(wholegrain, na.rm=T), 
            max=max(wholegrain, na.rm=T))

pheno_fhs %>% 
  group_by(sex,mmds_legume) %>% 
  summarise(min=min(legumes, na.rm=T), 
            max=max(legumes, na.rm=T))

pheno_fhs %>% 
  group_by(sex,mmds_meat) %>% 
  summarise(min=min(redmeat, na.rm=T), 
            max=max(redmeat, na.rm=T))


# For the alcohol item, there are pre-defined thresholds
pheno_fhs$mmds_alcohol <- with(pheno_fhs,ifelse(pheno_fhs$sex==1,
                                                  ifelse((pheno_fhs$ethanol<=25 & pheno_fhs$ethanol>=10),1,0),
                                                  ifelse((pheno_fhs$ethanol<=15 & pheno_fhs$ethanol>=5),1,0)))
table(pheno_fhs$mmds_alcohol, useNA = "always")

# We check that it was done correctly
# summary by sex and mds_alcohol
pheno_fhs %>%   group_by(sex,mmds_alcohol) %>%  summarise(minalc=min(ethanol, na.rm=T), maxalc=max(ethanol, na.rm=T))

################################
# Sum total score MMDS 0 to 25 #
################################

vars04<-c("mmds_wgrain","mmds_fish","mmds_meat","mmds_veg","mmds_fruit","mmds_nut","mmds_legume","mmds_mufasfa","mmds_alcohol")
pheno_fhs$mmds <- apply(pheno_fhs[,vars04],1,sum,na.rm=F) 

#Description
table(pheno_fhs$mmds, useNA = "always")
histogram(pheno_fhs$mmds)
mean(pheno_fhs$mmds,na.rm=T)



# Description by sex
# Create factor variables for use in CreateTableOne
pheno_fhs$mmds_wgrainf <- as.factor(pheno_fhs$mmds_wgrain)
pheno_fhs$mmds_fishf <- as.factor(pheno_fhs$mmds_fish)
pheno_fhs$mmds_meatf <- as.factor(pheno_fhs$mmds_meat)
pheno_fhs$mmds_vegf <- as.factor(pheno_fhs$mmds_veg)
pheno_fhs$mmds_fruitf <- as.factor(pheno_fhs$mmds_fruit)
pheno_fhs$mmds_nutf <- as.factor(pheno_fhs$mmds_nut)
pheno_fhs$mmds_legumef <- as.factor(pheno_fhs$mmds_legume)
pheno_fhs$mmds_mufasfaf <- as.factor(pheno_fhs$mmds_mufasfa)
pheno_fhs$mmds_alcoholf <- as.factor(pheno_fhs$mmds_alcohol)

vars05<-c("mmds_wgrainf","mmds_fishf","mmds_meatf","mmds_vegf","mmds_fruitf","mmds_nutf","mmds_legumef","mmds_mufasfaf","mmds_alcoholf","mmds")
tab <-CreateTableOne(vars05,strata="sex",data=pheno_fhs)
try<-print(tab,  noSpaces = TRUE)



######################################################################################################
#############   3. rMED (Buckland et al 2010), 0-18 based on tertiles energy density        #########
######################################################################################################

# Energy density in grams per 1000kcal
# = Intake in grams per 1000 kcal
pheno_fhs$cerealse <-with(pheno_fhs,cereals*1000/NUT_CALOR)
pheno_fhs$ffishe <-with(pheno_fhs,ffish*1000/NUT_CALOR) # only fresh and frozen fish, not preserved
pheno_fhs$meate <-with(pheno_fhs,meat*1000/NUT_CALOR) # !! all meat !!, not only red and processed meat
pheno_fhs$vege <-with(pheno_fhs,veg*1000/NUT_CALOR)
pheno_fhs$fruitnute <-with(pheno_fhs,fruitnut*1000/NUT_CALOR) # nuts, seeds and fruit
pheno_fhs$legumese <-with(pheno_fhs,legumes*1000/NUT_CALOR)
pheno_fhs$dairye <-with(pheno_fhs,dairy*1000/NUT_CALOR)
# We cannot calculate the quantity of olive oil so we will just have 
# a component with a score of 0 if no consumption, and of 2 if consumption
# pheno_fhs$oliveoile <-with(pheno_fhs,oliveoil*1000/NUT_CALOR)
summary(pheno_fhs$cereals)
summary(pheno_fhs$cerealse)
summary(pheno_fhs$ffishe)
summary(pheno_fhs$meate)
summary(pheno_fhs$vege)
summary(pheno_fhs$fruitnute)
summary(pheno_fhs$legumese)
summary(pheno_fhs$dairye)

tertiles<-ddply(pheno_fhs, .(sex), summarise, 
                t1_cerealse=quantile(cerealse,0.333, na.rm=T), t2_cerealse=quantile(cerealse,0.667, na.rm=T),
                t1_ffishe=quantile(ffishe,0.333, na.rm=T), t2_ffishe=quantile(ffishe,0.667, na.rm=T),
                t1_vege=quantile(vege,0.333, na.rm=T), t2_vege=quantile(vege,0.667, na.rm=T),
                t1_meate=quantile(meate,0.333, na.rm=T), t2_meate=quantile(meate,0.667, na.rm=T),
                t1_fruitnute=quantile(fruitnute,0.333, na.rm=T), t2_fruitnute=quantile(fruitnute,0.667, na.rm=T),
                t1_dairye=quantile(dairye,0.333, na.rm=T), t2_dairye=quantile(dairye,0.667, na.rm=T),
                t1_legumese=quantile(legumese,0.333, na.rm=T), t2_legumese=quantile(legumese,0.667, na.rm=T))
                

# Merge the dataset according to sex
pheno_fhs<-merge(pheno_fhs,tertiles,by="sex",all.x=TRUE,sort=FALSE)

# Creation of the 8 items according to the tertiles
pheno_fhs$rmed_cereals <- with(pheno_fhs,ifelse(cerealse<=t1_cerealse,0,
                                                  ifelse(cerealse<=t2_cerealse,1,2)),na.rm=T)
table(pheno_fhs$rmed_cereals, useNA = "always")
pheno_fhs$rmed_fish <- with(pheno_fhs,ifelse(ffishe<=t1_ffishe,0,
                                               ifelse(ffishe<=t2_ffishe,1,2)),na.rm=T)
# Meat is total meat (not only red meat)
pheno_fhs$rmed_meat <- with(pheno_fhs,ifelse(meate<=t1_meate,2, #inverse
                                               ifelse(meate<=t2_meate,1,0)),na.rm=T)
pheno_fhs$rmed_dairy <- with(pheno_fhs,ifelse(dairye<=t1_dairye,2, #inverse
                                                ifelse(dairye<=t2_dairye,1,0)),na.rm=T)
pheno_fhs$rmed_fruit <- with(pheno_fhs,ifelse(fruitnute<=t1_fruitnute,0,
                                                ifelse(fruitnute<=t2_fruitnute,1,2)),na.rm=T)
pheno_fhs$rmed_veg <- with(pheno_fhs,ifelse(vege<=t1_vege,0,
                                              ifelse(vege<=t2_vege,1,2)),na.rm=T)
pheno_fhs$rmed_legumes <- with(pheno_fhs,ifelse(legumese<=t1_legumese,0,
                                                  ifelse(legumese<=t2_legumese,1,2)),na.rm=T)
# Component 0 if no use, 2 if use of olive oil
pheno_fhs$rmed_oliveoil <- with(pheno_fhs,ifelse(oliveoiluse==1,2,0),na.rm=T)
table(pheno_fhs$rmed_oliveoil, useNA="always")

# For the alcohol item, same pre-defined thresholds as MDS, score of 2 if inside the range, 0 if not
pheno_fhs$rmed_alcohol <- with(pheno_fhs,ifelse(pheno_fhs$sex==1,
                                                  ifelse((pheno_fhs$ethanol<50 & pheno_fhs$ethanol>10),2,0),
                                                  ifelse((pheno_fhs$ethanol<25 & pheno_fhs$ethanol>5),2,0)))
table(pheno_fhs$rmed_alcohol, useNA = "always")


################################
# Sum total score rMED 0 to 18 #
################################

vars05<-c("rmed_cereals","rmed_fish","rmed_meat","rmed_dairy","rmed_veg","rmed_fruit","rmed_legumes","rmed_oliveoil","rmed_alcohol")
pheno_fhs$rmed <- apply(pheno_fhs[,vars05],1,sum,na.rm=F) 

#Description
table(pheno_fhs$rmed, useNA = "always")
histogram(pheno_fhs$rmed)
mean(pheno_fhs$rmed,na.rm=T)

# Description by sex
# Create factor variables for use in CreateTableOne
pheno_fhs$rmed_cerealsf <- as.factor(pheno_fhs$rmed_cereals)
pheno_fhs$rmed_fishf <- as.factor(pheno_fhs$rmed_fish)
pheno_fhs$rmed_meatf <- as.factor(pheno_fhs$rmed_meat)
pheno_fhs$rmed_vegf <- as.factor(pheno_fhs$rmed_veg)
pheno_fhs$rmed_fruitf <- as.factor(pheno_fhs$rmed_fruit)
pheno_fhs$rmed_dairyf <- as.factor(pheno_fhs$rmed_dairy)
pheno_fhs$rmed_legumesf <- as.factor(pheno_fhs$rmed_legumes)
pheno_fhs$rmed_oliveoilf <- as.factor(pheno_fhs$rmed_oliveoil)
pheno_fhs$rmed_alcoholf <- as.factor(pheno_fhs$rmed_alcohol)

vars06<-c("rmed_cerealsf","rmed_fishf","rmed_meatf","rmed_dairyf","rmed_vegf","rmed_fruitf","rmed_legumesf","rmed_oliveoilf","rmed_alcoholf","rmed")
tab <-CreateTableOne(vars06,strata="sex",data=pheno_fhs)
try<-print(tab,  noSpaces = TRUE)


######################################################################################################
#############   4. WHO HDI 2015      #########
######################################################################################################
# Kanauchi M, Kanauchi K. Prev Med Rep. 2018;12:198-202. doi:10.1016/j.pmedr.2018.09.011

# Total fat
pheno_fhs$NUT_FAT<-pheno_fhs$NUT_AFAT+pheno_fhs$NUT_VFAT

pheno_fhs$NUT_FAT2<-pheno_fhs$NUT_SATFAT+pheno_fhs$NUT_MONFAT+pheno_fhs$NUT_POLY
# We keep this one

pheno_fhs$NUT_FAT3<-pheno_fhs$NUT_FATEAT+pheno_fhs$NUT_VFAT

summary(pheno_fhs$NUT_FAT)
summary(pheno_fhs$NUT_FAT2) # we keep this definition of fat: saturated + poly + mono unsaturated
summary(pheno_fhs$NUT_FAT3)
pheno_fhs$kcal_exalc <-with(pheno_fhs,NUT_CALOR-ethanol*7) #Energy excluding alcohol
pheno_fhs$p_sfa <-with(pheno_fhs,900*NUT_MONFAT/kcal_exalc)
pheno_fhs$p_pufa <-with(pheno_fhs,900*NUT_POLY/kcal_exalc)
pheno_fhs$p_prot <-with(pheno_fhs,400*NUT_PROT/kcal_exalc)
pheno_fhs$p_carb <-with(pheno_fhs,400*NUT_CARBO/kcal_exalc)
pheno_fhs$p_fat <-with(pheno_fhs,900*NUT_FAT2/kcal_exalc)
pheno_fhs$sugar <-with(pheno_fhs,NUT_FRUCT+NUT_SUCR +NUT_LACT) #sucrose, fructose and lactose
pheno_fhs$p_sug <-with(pheno_fhs,400*sugar/kcal_exalc) 
pheno_fhs$fruitveg <-with(pheno_fhs,fruit+veg)

summary(pheno_fhs$p_fat)
summary(pheno_fhs$p_prot)
summary(pheno_fhs$p_carb)

# Components
pheno_fhs$hdi2015_sfa <-with(pheno_fhs,ifelse(p_sfa<10,1,0),na.rm=T)
pheno_fhs$hdi2015_sugar<-with(pheno_fhs,ifelse(p_sug<10,1,0),na.rm=T)
pheno_fhs$hdi2015_pufa <-with(pheno_fhs,ifelse((p_pufa<=11 & p_pufa>=6),1,0),na.rm=T)
pheno_fhs$hdi2015_fat <-with(pheno_fhs,ifelse((p_fat<30),1,0),na.rm=T)
pheno_fhs$hdi2015_k <-with(pheno_fhs,ifelse(NUT_K>=3500,1,0),na.rm=T)
pheno_fhs$hdi2015_fv <-with(pheno_fhs,ifelse(fruitveg>=400,1,0),na.rm=T)
pheno_fhs$hdi2015_fib <-with(pheno_fhs,ifelse(NUT_AOFIB>=25,1,0),na.rm=T)

# We check that it was done correctly
pheno_fhs %>%   group_by(hdi2015_sfa) %>% 
  summarise(min=min(p_sfa, na.rm=T), 
            max=max(p_sfa, na.rm=T))
pheno_fhs %>%   group_by(hdi2015_pufa) %>% 
  summarise(min=min(p_pufa, na.rm=T), 
            max=max(p_pufa, na.rm=T))
pheno_fhs %>%   group_by(hdi2015_fat) %>% 
  summarise(min=min(p_fat, na.rm=T), 
            max=max(p_fat, na.rm=T))
pheno_fhs %>%   group_by(hdi2015_k) %>% 
  summarise(min=min(NUT_K, na.rm=T), 
            max=max(NUT_K, na.rm=T))

# Score HDI total
pheno_fhs$hdi2015 <-with(pheno_fhs,hdi2015_sfa+hdi2015_pufa+hdi2015_sugar+hdi2015_fat+hdi2015_k+hdi2015_fv+hdi2015_fib)


table(pheno_fhs$hdi2015, useNA = "always")
histogram(pheno_fhs$hdi2015)
mean(pheno_fhs$hdi2015,na.rm=T)

# Convert in factor for table one
vars07<-c("hdi2015_sfa","hdi2015_pufa","hdi2015_sugar","hdi2015_fat","hdi2015_k","hdi2015_fv","hdi2015_fib")
vars07f<-c("hdi2015_sfaf","hdi2015_pufaf","hdi2015_sugarf","hdi2015_fatf","hdi2015_kf","hdi2015_fvf","hdi2015_fibf")
for(i in 1:length(vars07))
  
{
  pheno_fhs[,vars07f[i]]<-as.factor(pheno_fhs[,vars07[i]])
}
vars07<-c("hdi2015_sfaf","hdi2015_pufaf","hdi2015_sugarf","hdi2015_fatf","hdi2015_kf","hdi2015_fvf","hdi2015_fibf","hdi2015")

tab <-CreateTableOne(vars07,strata="sex",data=pheno_fhs)
try<-print(tab,  noSpaces = TRUE)

######################################################################################################
#############   5. DASH (Fung)       #########
######################################################################################################


#Values of 1 to 5 for quintiles

setDT(pheno_fhs)[,dash_fruit := cut(fruitdash, quantile(fruitdash, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE), by = sex]
setDT(pheno_fhs)[,dash_veg := cut(veg, quantile(veg, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE), by = sex]
setDT(pheno_fhs)[,dash_legnut := cut(legumenut, quantile(legumenut, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE), by = sex]
setDT(pheno_fhs)[,dash_sweetbev := 5-cut(ssbnojuice, quantile(ssbnojuice, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE), by = sex]

setDT(pheno_fhs)[,dash_meat := 6-cut(meat, quantile(meat, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE), by = sex]
setDT(pheno_fhs)[,dash_wholegrain := cut(wholegrain, quantile(wholegrain, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE), by = sex]
setDT(pheno_fhs)[,dash_lfdairy := cut(lfdairy, quantile(lfdairy, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE), by = sex]
setDT(pheno_fhs)[,dash_na := 6-cut(NUT_SODIUM, quantile(NUT_SODIUM, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE), by = sex]


# This function does not work for sweet beverages because of too many zeros,
# we do it "by hand"
quintiles <-ddply(pheno_fhs, .(sex), summarise, 
                  qi1_sb_b=quantile(ssbnojuice,0.20, na.rm=T), qi2_sb_b=quantile(ssbnojuice,0.40, na.rm=T),
                  qi3_sb_b=quantile(ssbnojuice,0.60, na.rm=T), qi4_sb_b=quantile(ssbnojuice,0.80, na.rm=T))

# Merge the dataset according to sex
pheno_fhs<-merge(pheno_fhs,quintiles,by="sex",all.x=TRUE,sort=FALSE)

pheno_fhs$dash_sweetbev <- with(pheno_fhs,ifelse(ssbnojuice<=qi1_sb_b,5,
                                             ifelse(ssbnojuice<=qi2_sb_b,4,
                                                    ifelse(ssbnojuice<=qi3_sb_b,3,
                                                           ifelse(ssbnojuice<=qi4_sb_b,2,1)))),na.rm=T)

# We check that it was done correctly
pheno_fhs %>%   group_by(sex,dash_sweetbev) %>% 
  summarise(min=min(ssbnojuice, na.rm=T), 
            max=max(ssbnojuice, na.rm=T))
table(pheno_fhs$dash_sweetbev, useNA = "always")
pheno_fhs %>%   group_by(sex,dash_lfdairy) %>% 
  summarise(min=min(lfdairy, na.rm=T), 
            max=max(lfdairy, na.rm=T))
pheno_fhs %>%   group_by(sex,dash_meat) %>% 
  summarise(min=min(meat, na.rm=T), 
            max=max(meat, na.rm=T))
pheno_fhs %>%   group_by(sex,dash_na) %>% 
  summarise(min=min(NUT_SODIUM, na.rm=T), 
            max=max(NUT_SODIUM, na.rm=T))

table(pheno_fhs$dash_wholegrain, useNA="always")
table(pheno_fhs$dash_sweetbev, useNA="always")
table(pheno_fhs$dash_lfdairy, useNA="always")
table(pheno_fhs$dash_fruit, useNA="always")
table(pheno_fhs$dash_veg, useNA="always")
table(pheno_fhs$dash_legnut, useNA="always")
table(pheno_fhs$dash_meat, useNA="always")
table(pheno_fhs$dash_na, useNA="always")

# Sum total

pheno_fhs$dashf <- with(pheno_fhs,dash_wholegrain+dash_sweetbev+dash_lfdairy+dash_fruit+dash_veg+dash_legnut
                          +dash_meat+dash_na,na.rm=T) 
table(pheno_fhs$dashf, useNA = "always")
histogram(pheno_fhs$dashf)
mean(pheno_fhs$dashf,na.rm=T)


# Convert in factor for table one
pheno_fhs$dash_wgf<-as.factor(pheno_fhs$dash_wholegrain)
pheno_fhs$dash_sbf<-as.factor(pheno_fhs$dash_sweetbev)
pheno_fhs$dash_lfdf<-as.factor(pheno_fhs$dash_lfdairy)
pheno_fhs$dash_fruitf<-as.factor(pheno_fhs$dash_fruit)
pheno_fhs$dash_vegf<-as.factor(pheno_fhs$dash_veg)
pheno_fhs$dash_legnutf<-as.factor(pheno_fhs$dash_legnut)
pheno_fhs$dash_meatf<-as.factor(pheno_fhs$dash_meat)
pheno_fhs$dash_naf<-as.factor(pheno_fhs$dash_na)

table(pheno_fhs$dash_naf, useNA="always")
vars08<-c("dash_wgf","dash_sbf","dash_lfdf","dash_fruitf","dash_vegf","dash_legnutf","dash_meatf","dash_naf","dashf")

tab <-CreateTableOne(vars08,strata="sex",data=pheno_fhs)
try<-print(tab,  noSpaces = TRUE)


######################################################################################################
#############   6. Healthful Plant based Diet Index   range 17 - 85    #########
######################################################################################################

#Values of 1 to 5 for quintiles
# The original score has 18 components but this one will have only 17
# because we don't have the miscellaneous animal  component
# The original score ranges 18 - 90, but ours ranges 17 - 85

#setDT(pheno_fhs)[,dash_wholegrain := cut(wholegrain, quantile(wholegrain, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE), by = sex]
setDT(pheno_fhs)[,hpdi_fruit := cut(fruitdash, quantile(fruitdash, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE), by = sex]
setDT(pheno_fhs)[,hpdi_veg := cut(veg, quantile(veg, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE), by = sex]
setDT(pheno_fhs)[,hpdi_nut := cut(nut, quantile(nut, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE), by = sex]
setDT(pheno_fhs)[,hpdi_legume := cut(legumes, quantile(legumes, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE), by = sex]
setDT(pheno_fhs)[,hpdi_oil := cut(vegfat, quantile(vegfat, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE), by = sex]
setDT(pheno_fhs)[,hpdi_coft := cut(coffeetea, quantile(coffeetea, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE), by = sex]

setDT(pheno_fhs)[,hpdi_fruitjuice := 6-cut(fruitjuice, quantile(fruitjuice, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE), by = sex]
setDT(pheno_fhs)[,hpdi_refgrain := 6-cut(refgrain, quantile(refgrain, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE), by = sex]
setDT(pheno_fhs)[,hpdi_potato := 6-cut(potato, quantile(potato, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE), by = sex]
#setDT(pheno_fhs)[,dash_sweetbev := 6-cut(bebidas, quantile(bebidas, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE), by = sex]
setDT(pheno_fhs)[,hpdi_sweet := 6-cut(sweet, quantile(sweet, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE), by = sex]

setDT(pheno_fhs)[,hpdi_anifat := 6-cut(anifat, quantile(anifat, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE), by = sex]
setDT(pheno_fhs)[,hpdi_dairy := 6-cut(dairy, quantile(dairy, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE), by = sex]
#setDT(pheno_fhs)[,hpdi_egg := 6-cut(EGGS, quantile(EGGS, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE), by = sex]
setDT(pheno_fhs)[,hpdi_fish := 6-cut(fish, quantile(fish, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE), by = sex]
setDT(pheno_fhs)[,hpdi_meat := 6-cut(meat, quantile(meat, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE), by = sex]
# There is no miscellaneous animal
#setDT(pheno_fhs)[,hpdi_animal := 6-cut(animal, quantile(animal, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE), by = sex]

## Do by hand eggs, anifat, fruitjuice. Sweet beverages is already made so we will use dash_sb
quintiles2 <-ddply(pheno_fhs, .(sex), summarise, 
                   qi1_egg=quantile(eggs,0.20, na.rm=T), qi2_egg=quantile(eggs,0.40, na.rm=T),
                   qi3_egg=quantile(eggs,0.60, na.rm=T), qi4_egg=quantile(eggs,0.80, na.rm=T))

# Merge the dataset according to sex
pheno_fhs<-merge(pheno_fhs,quintiles2,by="sex",all.x=TRUE,sort=FALSE)

pheno_fhs$hpdi_egg <- with(pheno_fhs,ifelse(eggs<=qi1_egg,5,
                                              ifelse(eggs<=qi2_egg,4,
                                                     ifelse(eggs<=qi3_egg,3,
                                                            ifelse(eggs<=qi4_egg,2,1)))),na.rm=T)

# We check that it was done correctly
pheno_fhs %>%   group_by(sex,hpdi_egg) %>% 
  summarise(min=min(eggs, na.rm=T), 
            max=max(eggs, na.rm=T))
pheno_fhs %>%   group_by(sex,hpdi_anifat) %>% 
  summarise(min=min(anifat, na.rm=T), 
            max=max(anifat, na.rm=T))
pheno_fhs %>%   group_by(sex,hpdi_fruitjuice) %>% 
  summarise(min=min(fruitjuice, na.rm=T), 
            max=max(fruitjuice, na.rm=T))
pheno_fhs %>%   group_by(sex,hpdi_nut) %>% 
  summarise(min=min(nut, na.rm=T), 
            max=max(nut, na.rm=T))

#### Sum total
# we have one variable less "miscellaneous animal"
setDT(pheno_fhs)
vars09<-c("dash_wholegrain","hpdi_fruit","hpdi_veg","hpdi_nut","hpdi_legume","hpdi_oil","hpdi_coft",
          "hpdi_fruitjuice","hpdi_refgrain","hpdi_potato","dash_sweetbev","hpdi_sweet",
          "hpdi_anifat","hpdi_dairy","hpdi_egg","hpdi_fish","hpdi_meat")
pheno_fhs$hpdi <-apply(pheno_fhs[,..vars09],1,sum,na.rm=F)

table(pheno_fhs$hpdi, useNA = "always")

histogram(pheno_fhs$hpdi)
mean(pheno_fhs$hpdi,na.rm=T)



vars10<-c("dash_wholegrain","hpdi_fruit","hpdi_veg","hpdi_nut","hpdi_legume","hpdi_oil","hpdi_coft",
          "hpdi_fruitjuice","hpdi_refgrain","hpdi_potato","dash_sweetbev","hpdi_sweet",
          "hpdi_anifat","hpdi_dairy","hpdi_egg","hpdi_fish","hpdi_meat","hpdi")

tab <-CreateTableOne(vars10,strata="sex",data=pheno_fhs)
try<-print(tab,  noSpaces = TRUE)



#### SAVE THE DATASET WITH THE SCORES ####
vars10<-c("sex","shareid","slide","hpdi_nut","hpdi_legume","hpdi_oil","hpdi_coft",
          "hpdi_fruitjuice","hpdi_refgrain","hpdi_potato","dash_sweetbev","hpdi_sweet",
          "hpdi_anifat","hpdi_dairy","hpdi_egg","hpdi_fish","hpdi_meat","hpdi")

foodvar <- c(names(pheno_fhs)[1:38])
foodvar2<-c(foodvar,"NUT_CALOR","mds_cereal","mds_fish","mds_meat","mds_veg","mds_fruit","mds_dairy",
                                      "mds_legume","mds_mufasfa","mds_alcohol","mds",
                                      "mmds_wgrain","mmds_fish","mmds_meat","mmds_veg","mmds_fruit","mmds_nut",
                                      "mmds_legume","mmds_mufasfa","mmds_alcohol","mmds",
                                      "rmed_cereals","rmed_fish","rmed_meat","rmed_dairy","rmed_veg","rmed_fruit",
                                      "rmed_legumes","rmed_oliveoil","rmed_alcohol","rmed",
                                      "hdi2015_sfa","hdi2015_pufa","hdi2015_sugar","hdi2015_fat",
                                      "hdi2015_k","hdi2015_fv","hdi2015_fib","hdi2015",
                                      "dash_wholegrain","dash_sweetbev","dash_lfdairy","dash_fruit","dash_veg",
                                      "dash_legnut","dash_meat","dash_na","dashf",
                                      "hpdi_fruit","hpdi_veg","hpdi_nut","hpdi_legume","hpdi_oil","hpdi_coft",
                                      "hpdi_fruitjuice","hpdi_refgrain","hpdi_potato","hpdi_sweet",
                                      "hpdi_anifat","hpdi_dairy","hpdi_egg","hpdi_fish","hpdi_meat","hpdi")
phenofood_fhs<-pheno_fhs[,..foodvar2]

save(phenofood_fhs,file="U:/Estudis/B64_DIAMETR/Dades/FHS/phenofood_fhs.RData")

