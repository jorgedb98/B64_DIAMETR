######################################
###   Camille Lassale 04/11/2021
###################################### 

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

###############################################################################################
### We have to download again the FFQ dataset from dbgap 
### It is split in two: the nutrient dataset, and the food item dataset
### !! It contains repeated measuresat different years of visit so the IDs are repeated several times
################### ############################################################################
rm(list=ls())
setwd("C:/Users/classale/OneDrive/DIAMETR")

# load the food item dataset !!It takes a bit of time to load because it is BIG: 292 200 observations because of the repeated measurements
item<-read.table("./data/WHI/phs000200.v12.pht001517.v6.p3.c1.f60_item_rel1.HMB-IRB.txt",header=T,sep="\t",quote="",stringsAsFactors=F)
## we create a subset with only the baseline visit (F60VY==0) to reduce the size of the dataset, 
# and because that is when the DNA methylation assessment was also performed
item<-subset(item, F60VY==0) #N=117469

# load the nutrient dataset
nutr<-read.table("./data/WHI/phs000200.v12.pht002125.v5.p3.c1.f60_nutr_rel1.HMB-IRB.txt",header=T,sep="\t",quote="",stringsAsFactors=F)
# select baseline data
nutr<-subset(nutr, F60VY==0) 
length(unique(nutr$dbGaP_Subject_ID)) #N=117469

# combine the food and nutrient database
try<-merge(item,nutr,by="dbGaP_Subject_ID")

# We load the phenotype dataset found on the cluster in projects/regicor/data/WHI/phenotype/pheno
# load("U:/Estudis/B64_DIAMETR/Dades/WHI/pheno_f2_cellcount.RData")
load("./data/WHI/pheno_f2_cellcount.RData")
# 1863

# Camille 11/11/2021: This dataset has the same number of people as in Fernández-Sanlés et al. Clin Epigenet (2021) 13:86
# BUT it does NOT contain information on BMI, smoking, physical activity, clinical markers
### --> Need to find it!

small_try<-as.data.frame(c(try[,1]))
small_pheno<-as.data.frame(c(pheno[,12]))
names(small_try)<-"id"
names(small_pheno)<-"id"
setdiff(small_pheno,small_try)
#     id
# 1 213640
# 2 219179
# 3 211881
# 4 214045
# 5 397298
# 6 408453
# 7 396194


# We combine the phenotype dataset of the subset with DNA methylation, with the food and nutrient data 
try<-merge(pheno,try,by="dbGaP_Subject_ID")
length(unique(try$dbGaP_Subject_ID))
#1856 participants

###############################################################################################

#############################  DIETARY DATA MANAGEMENT ########################################

###############################################################################################

######### 1. Exclude under and over reporters

# The variable STATUS gives us this information directly
# 1=Energy < 600 kcal consider excluding from analyses
# 2=Energy > 5000 kcal consider excluding from analyses
# 3=600 kcal <= Energy <= 5000 kcal

table(try$STATUS.x,useNA="always")
table(try$STATUS.y,useNA="always") 
# the same, they are called .x and .y because they were repeated in the food and the nutrient databases

# We keep the 1777 participants with plausible energy intake
try<-subset(try,STATUS.x==3)
length(unique(try$dbGaP_Subject_ID))

# We apply Framingham's validity criteria 600 - 4000 kcal for women
# i.e. we further exclude energy intake >= 4000 kcal
summary(try$F60ENRGY)
try$F60ENRGY<-as.numeric(with(try,ifelse(F60ENRGY>=4000,NA,try$F60ENRGY)))
boxplot.stats(try$F60ENRGY)$out
summary(try$F60ENRGY)

# We exclude further 17 participants with intake >= 4000
#    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
#   603.3  1160.1  1535.1  1628.9  1970.0  3950.2      17 
try<-subset(try,!is.na(F60ENRGY))
length(unique(try$dbGaP_Subject_ID)) #1760 

############# 2. FOOD GROUPS

############# ############# ############# ############# ############# 
# In the WHI dataset, there are already derived variables for total
# Fruit,  Vegetables, Fish, Red meat, poultry, soy, nuts, grains, wholegrains, milk, dairy
# They are expressed in medium servings per day. We decide not to convert it into grams
# As this is not necessary for the computation of most dietary scores
############# ############# ############# ############# ############# 

# We check if the sum of individual fruit items (servings/day) aligns with the derived variables FRUITS
vars01<-c("APPLE","BANANA","PEACH","CANTALOP","WATERMEL","OTHMELON","APRICOT","DRYFRUIT","ORANGE","STRAWBER","OTHFRUIT")
try$fruitsum <- apply(try[,vars01],1,sum,na.rm=F) 
#without dry fruit
vars02<-c("APPLE","BANANA","PEACH","CANTALOP","WATERMEL","OTHMELON","APRICOT","ORANGE","STRAWBER","OTHFRUIT")
try$fruitsum2 <- apply(try[,vars02],1,sum,na.rm=F) 

summary(try$fruitsum)
summary(try$fruitsum2)
summary(try$FRUITS)
# Not exactly the same --> we use the derived variable


table(try$TOFU,useNA="always")
table(try$SOY,useNA="always")
summary(try$GRNPEAS)
summary(try$REFRIED)
summary(try$BEANS)


vars03<-c("GRNBEAN","GRNPEAS","REFRIED","BEANS","TOFU","AVOCADO","CORN","TOMATO","TOMATOC","GRNPEPP","REDPEPP",
          "BROCCOLI","GREENS","CARROT","SUMSQASH","WINSQASH","COLESLAW","CAULIF","ONION","LETTUCE","SALAD")
try$vegsum <- apply(try[,vars03],1,sum,na.rm=F) 
# without the legumes GRNPEAS, REGRIED BEANS, BEANS, TOFU, and Corn
vars04<-c("GRNBEAN","AVOCADO","TOMATO","TOMATOC","GRNPEPP","REDPEPP",
          "BROCCOLI","GREENS","CARROT","SUMSQASH","WINSQASH","COLESLAW","CAULIF","ONION","LETTUCE","SALAD")
try$vegsum2 <- apply(try[,vars04],1,sum,na.rm=F) 

summary(try$vegsum)
summary(try$vegsum2)
summary(try$VEGTABLS)
# It doesn't match, so we take the VEGTABLS variable


############# We need to compute some more food groups variables ###############

### Fruit and vegetables

# This one we express it in grams for the WHO HDI
# we assume one medium serving is 80g
summary(try$FRUVEG)
try$fvgram<- with(try,80*FRUVEG)
summary(try$fvgram)
#    Min.  1st Qu.   Median     Mean  3rd Qu.     Max. 
#    7.89  171.18    268.16   302.20   400.71  1479.45  

### Fruit and nuts

try$fruitnut <- with(try,FRUITS+NUTS)
summary(try$fruitnut)


### Legumes

vars05<-c("GRNPEAS","REFRIED","BEANS","TOFU","BEANSOUP")
try$legumes <- apply(try[,vars05],1,sum,na.rm=F)
try$legumes <- try$legumes + 0.15*try$BURRITO
summary(try$legumes)

# Ratio MUFA to SFA

try$mufasfa    <- with(try,F60MFA/F60SFA)
summary(try$mufasfa)

# Fresh and frozen fish for rMED (exclude canned)
# We remove the item TUNA which is Canned tuna, tuna salad or tuna casserole

try$ffish<-with(try,FISH-TUNA)
summary(try$FISH)
summary(try$ffish)


# Total meat

try$meat <- try$REDMEAT+try$POULTRY
summary(try$meat)
summary(try$REDMEAT)
summary(try$POULTRY)

# Vegetable oil
# 1=Less that one per week
# 2=1-2 per week
# 3=3-4 per week
# 4=5-6 per week
# 5=1 per day
# 6=2 per day
# 7=3 per day
# 8=4 per day
# 9=5+ per day
# Let's assume 1 portion = 14g (1 tablespoon)

# Quantity of frying fat
try$fatqty1<-with(try,ifelse(FRYFREQ==1,14*0.9/7,
                             ifelse(FRYFREQ==2,14*1.5/7,
                                    ifelse(FRYFREQ==3,14*3.5/7,
                                           ifelse(FRYFREQ==4,14*5.5/7,
                                                  ifelse(FRYFREQ==5,14,
                                                         ifelse(FRYFREQ==6,14*2,
                                                                ifelse(FRYFREQ==7,14*3,
                                                                       ifelse(FRYFREQ==8,14*4,
                                                                              ifelse(FRYFREQ==9,14*5,NA))))))))))
table(try$fatqty1)
table(try$FRYFREQ)
# Quantity of added fat to cooking
try$fatqty2<-with(try,ifelse(FATFREQ==1,14*0.495/7,
                             ifelse(FATFREQ==2,14*1.5/7,
                                    ifelse(FATFREQ==3,14*3.5/7,
                                           ifelse(FATFREQ==4,14*5.5/7,
                                                  ifelse(FATFREQ==5,14,
                                                         ifelse(FATFREQ==6,14*2,
                                                                ifelse(FATFREQ==7,14*3,
                                                                       ifelse(FATFREQ==8,14*4,
                                                                              ifelse(FATFREQ==9,14*5,NA))))))))))
table(try$fatqty2)
table(try$FATFREQ)
try$vegfatqty1<-with(try,ifelse(FRYOLIV==1|FRYSMARG==1|FRYTMARG==1|FRYOIL==1|FRYPAM==1,fatqty1,0))
try$vegfatqty2<-with(try,ifelse(LMARGC==1|SMARGC==1|TMARGC==1|OLIVC==1|OILC==1|PAMC==1|
                                  LMARGA==1|SMARGA==1|TMARGA==1|OLIVA==1|OILA==1,fatqty2,0))
summary(try$vegfatqty1)
summary(try$vegfatqty2)
table(try$OLIVA,try$BUTTA)

try$vegfatqty<-with(try,vegfatqty1+vegfatqty2)

# OLIVE OIL
# There is one question on the type of oil usually used for cooking 
# So we just create a qualitative yes/no variable on use of olive oil

try$oliveoiluse <- with(try,ifelse(FRYOLIV==1|OLIVC==1|OLIVA==1|OLIVS==1,1,0))
table(try$oliveoiluse,try$FRYOLIV, useNA="always")


try$oliveoilqty1<-with(try,ifelse(FRYOLIV==1,fatqty1,0))
try$oliveoilqty2<-with(try,ifelse(OLIVC==1|OLIVA==1,fatqty2,0))
summary(try$oliveoilqty1)
summary(try$oliveoilqty2)
try$oliveoilqty<-with(try,oliveoilqty1+oliveoilqty2)
summary(try$oliveoilqty)
table(try$oliveoilqty,useNA="always")

# Vegetable oil
try$vegoilqty1<-with(try,ifelse(FRYOLIV==1|FRYOIL==1,fatqty1,0))
try$vegoilqty2<-with(try,ifelse(OLIVC==1|OLIVA==1|OILC==1|OILA==1,fatqty2,0))
summary(try$vegoilqty1)
summary(try$vegoilqty2)
try$vegoilqty<-with(try,vegoilqty1+vegoilqty2)

# Animal fat
try$anifatqty1<-with(try,ifelse(FRYBUTT==1|FRYSHORT==1,fatqty1,0))
try$anifatqty2<-with(try,ifelse(BUTTC==1|SHORTC==1|BUTTA==1|SOURCRMA==1,fatqty2,0))
summary(try$anifatqty1)
summary(try$anifatqty2)
try$anifatqty<-with(try,anifatqty1+anifatqty2)
summary(try$anifatqty)


########## For the DASH diet score

# DASH Variable Fruit + Fruit juice
try$fruitdash <- try$FRUITS + try$OJ + try$FRTJUICE

summary(try$FRUITS)
summary(try$fruitdash )

# Legumes and nuts combined
try$legumenut <- with(try,legumes+NUTS)
summary(try$legumenut)

# Sugar sweetened beverages, excluding fruit juices
try$ssbnojuice <- with(try,KOOLAID+POP)
summary(try$ssbnojuice)

# Low fait dairy
# low fat milk is the derived variable MILKS only if the participants reported 1%fat or non-fat milk at the MILKFAT variable
try$lfmilk<-as.numeric(with(try,ifelse(MILKFAT==3|MILKFAT==4,try$MILKS,0)))
try$lfmilk<-ifelse(is.na(try$lfmilk),0,try$lfmilk)
# 1=Whole milk
# 2=2% milk
# 3=1% milk or buttermilk
# 4=Non-fat or skim milk
# 5=Evaporated or condensed milk
# 6=Soy milk
# 7=Don't know
summary(try$lfmilk)
summary(try$MILKS)
try$lfdairy <- with(try,LFDESST+NFYOGUR+NFCHEES+LFCHEES+LFCOTCH+lfmilk)
summary(try$lfdairy)

#### For the Healthful plant based diet index HPDI

# Fruit juices
try$juice <- try$OJ + try$FRTJUICE


# Miscellaneous animal food
# We ASSUME they are with meat, although the title says "with or without" meat sometimes

try$animalfood <- with(try,SPAGMEAT+LOWPIZZA+PIZZA+TAMALE+QUESAS+QUESAC+TACOSFT+FLAUTA+BURRITO+TACO+HOTDOG)

summary(try$animalfood)

# Refined grains: Total grains minus wholegrains
try$refgrain <- with(try,GRAINS-WHLGRNS)

# Potatoes
try$potato<- with(try,FRIES+YAM+POTATO+PSALAD)

# Sweet products
try$sweet<- with(try,DOUGHNT+COOKIES+PUMPPIE+OTHPIE+CHOCOLT+CANDY+PANCAKE+BISCUIT)

############################################################################

#############     Calculation of the DIET SCORES     ###################

############################################################################


##################################################################################
#############   1. MDS  - Trichopoulou 0-9, based on median of intake   ##########
##################################################################################

# Sex-specific medians and quartiles
# NOT sex specific because there are only women in the study
medians<-ddply(try, .(),summarise, 
               med_cereals=median(GRAINS, na.rm = T), q1_cereals=quantile(GRAINS,0.25, na.rm=T), q3_cereals=quantile(GRAINS,0.75, na.rm=T),
               med_fish=median(FISH, na.rm = T), q1_fish=quantile(FISH,0.25, na.rm=T), q3_fish=quantile(FISH,0.75, na.rm=T),
               med_redmeat=median(REDMEAT, na.rm = T), q1_redmeat=quantile(REDMEAT,0.25, na.rm=T), q3_redmeat=quantile(REDMEAT,0.75, na.rm=T),
               med_veg=median(VEGTABLS, na.rm = T), q1_veg=quantile(VEGTABLS,0.25, na.rm=T), q3_veg=quantile(VEGTABLS,0.75, na.rm=T),
               med_fruitnut=median(fruitnut, na.rm = T), q1_fruitnut=quantile(fruitnut,0.25, na.rm=T), q3_fruitnut=quantile(fruitnut,0.75, na.rm=T),
               med_fruit=median(FRUITS, na.rm = T), q1_fruit=quantile(FRUITS,0.25, na.rm=T), q3_fruit=quantile(FRUITS,0.75, na.rm=T),
               med_nut=median(NUTS, na.rm = T), q1_nut=quantile(NUTS,0.25, na.rm=T), q3_nut=quantile(NUTS,0.75, na.rm=T),
               med_dairy=median(DAIRY, na.rm = T), q1_dairy=quantile(DAIRY,0.25, na.rm=T), q3_dairy=quantile(DAIRY,0.75, na.rm=T),
               med_legumes=median(legumes, na.rm = T), q1_legumes=quantile(legumes,0.25, na.rm=T), q3_legumes=quantile(legumes,0.75, na.rm=T),
               med_mufasfa=median(mufasfa, na.rm = T), q1_mufasfa=quantile(mufasfa,0.25, na.rm=T), q3_mufasfa=quantile(mufasfa,0.75, na.rm=T),
               med_wholegrain=median(WHLGRNS, na.rm = T), q1_wholegrain=quantile(WHLGRNS,0.25, na.rm=T), q3_wholegrain=quantile(WHLGRNS,0.75, na.rm=T))

medians



# Creation of the 8 items according to the median
try$mds_cereal <- with(try,ifelse(GRAINS<medians$med_cereals,0,1),na.rm=T)
try$mds_fish <- with(try,ifelse(FISH<medians$med_fish,0,1),na.rm=T)
try$mds_meat <- with(try,ifelse(REDMEAT>=medians$med_redmeat,0,1),na.rm=T) #inverse
try$mds_veg <- with(try,ifelse(VEGTABLS<medians$med_veg,0,1),na.rm=T)
try$mds_fruit <- with(try,ifelse(fruitnut<medians$med_fruitnut,0,1),na.rm=T) # Fruit and nuts in the score by Trichopoulou
try$mds_dairy <- with(try,ifelse(DAIRY>=medians$med_dairy,0,1),na.rm=T)  #inverse
try$mds_legume <- with(try,ifelse(legumes<medians$med_legumes,0,1),na.rm=T)
try$mds_mufasfa <- with(try,ifelse(mufasfa<medians$med_mufasfa,0,1),na.rm=T)


# For the alcohol item, there are pre-defined thresholds
try$mds_alcohol <- with(try, ifelse((try$F60ALC<25 & try$F60ALC>5),1,0))
table(try$mds_alcohol, useNA = "always")

# We check that it was done correctly

# Another way of describing by sex and item
ddply(try, .(mds_alcohol), summarise, meanalc=mean(F60ALC,na.rm=T), minalc=min(F60ALC,na.rm=T), maxalc=max(F60ALC,na.rm=T))
# OK #

try %>%   group_by(mds_cereal) %>%  summarise(minalc=min(GRAINS, na.rm=T), maxalc=max(GRAINS, na.rm=T))
try %>%   group_by(mds_fish) %>%  summarise(minalc=min(FISH, na.rm=T), maxalc=max(FISH, na.rm=T))
try %>%   group_by(mds_meat) %>%  summarise(minalc=min(REDMEAT, na.rm=T), maxalc=max(REDMEAT, na.rm=T))
try %>%   group_by(mds_veg) %>%  summarise(minalc=min(VEGTABLS, na.rm=T), maxalc=max(VEGTABLS, na.rm=T))
try %>%   group_by(mds_fruit) %>%  summarise(minalc=min(fruitnut, na.rm=T), maxalc=max(fruitnut, na.rm=T))
try %>%   group_by(mds_dairy) %>%  summarise(minalc=min(DAIRY, na.rm=T), maxalc=max(DAIRY, na.rm=T))
try %>%   group_by(mds_legume) %>%  summarise(minalc=min(legumes, na.rm=T), maxalc=max(legumes, na.rm=T))
try %>%   group_by(mds_mufasfa) %>%  summarise(minalc=min(mufasfa, na.rm=T), maxalc=max(mufasfa, na.rm=T))

table(try$mds_cereal, useNA = "always")
table(try$mds_fish, useNA = "always")
table(try$mds_meat, useNA = "always")
table(try$mds_veg, useNA = "always")
table(try$mds_fruit, useNA = "always")
table(try$mds_dairy, useNA = "always")
table(try$mds_legume, useNA = "always")
table(try$mds_mufasfa, useNA = "always") 
table(try$mds_alcohol, useNA = "always")

##############################
# Sum total score MDS 0 to 9 #
##############################

vars02<-c("mds_cereal","mds_fish","mds_meat","mds_veg","mds_fruit","mds_dairy","mds_legume","mds_mufasfa","mds_alcohol")
try$mds <- apply(try[,vars02],1,sum,na.rm=F) 

table(try$mds, useNA = "always")
histogram(try$mds)
mean(try$mds,na.rm=T)
# 4.179545

##################################################################################
#############   2. MMDS  - Ma et al 2020, 0-25 based on quartiles        #########
##################################################################################


try$mmds_wgrain <- with(try,ifelse(WHLGRNS<=medians$q1_wholegrain,0,
                                               ifelse(WHLGRNS<=medians$med_wholegrain,1,
                                                      ifelse(WHLGRNS<=medians$q3_wholegrain,2,3))),na.rm=T)
table(try$mmds_wgrain, useNA = "always")
try$mmds_fish <- with(try,ifelse(FISH<=medians$q1_fish,0,
                                             ifelse(FISH<=medians$med_fish,1,
                                                    ifelse(FISH<=medians$q3_fish,2,3))),na.rm=T)
table(try$mmds_fish, useNA = "always")

try$mmds_meat <- with(try,ifelse(REDMEAT<medians$q1_redmeat,3, #???inverse
                                             ifelse(REDMEAT<medians$med_redmeat,2,
                                                    ifelse(REDMEAT<medians$q3_redmeat,1,0))),na.rm=T)
try$mmds_veg <- with(try,ifelse(VEGTABLS<=medians$q1_veg,0,
                                            ifelse(VEGTABLS<=medians$med_veg,1,
                                                   ifelse(VEGTABLS<=medians$q3_veg,2,3))),na.rm=T)
try$mmds_fruit <- with(try,ifelse(FRUITS<=medians$q1_fruit,0,
                                              ifelse(FRUITS<=medians$med_fruit,1,
                                                     ifelse(FRUITS<=medians$q3_fruit,2,3))),na.rm=T)
try$mmds_nut <- with(try,ifelse(NUTS<=medians$q1_nut,0,
                                            ifelse(NUTS<=medians$med_nut,1,
                                                   ifelse(NUTS<=medians$q3_nut,2,3))),na.rm=T)
try$mmds_legume <- with(try,ifelse(legumes<=medians$q1_legumes,0,
                                               ifelse(legumes<=medians$med_legumes,1,
                                                      ifelse(legumes<=medians$q3_legumes,2,3))),na.rm=T)
try$mmds_mufasfa <- with(try,ifelse(mufasfa<=medians$q1_mufasfa,0,
                                                ifelse(mufasfa<=medians$med_mufasfa,1,
                                                       ifelse(mufasfa<=medians$q3_mufasfa,2,3))),na.rm=T)
table(try$mmds_meat, useNA = "always")
table(try$mmds_veg, useNA = "always")
table(try$mmds_fruit, useNA = "always")
table(try$mmds_nut, useNA = "always")
table(try$mmds_legume, useNA = "always")
table(try$mmds_mufasfa, useNA = "always")

try %>% 
  group_by(mmds_wgrain) %>% 
  summarise(min=min(WHLGRNS, na.rm=T), 
            max=max(WHLGRNS, na.rm=T))

try %>% 
  group_by(mmds_legume) %>% 
  summarise(min=min(legumes, na.rm=T), 
            max=max(legumes, na.rm=T))

try %>% 
  group_by(mmds_meat) %>% 
  summarise(min=min(REDMEAT, na.rm=T), 
            max=max(REDMEAT, na.rm=T))


# For the alcohol item, there are pre-defined thresholds
try$mmds_alcohol <- with(try, ifelse((try$F60ALC<=15 & try$F60ALC>=5),1,0))
table(try$mmds_alcohol, useNA = "always")

# We check that it was done correctly
# summary by sex and mds_alcohol
try %>%   group_by(mmds_alcohol) %>%  summarise(minalc=min(F60ALC, na.rm=T), maxalc=max(F60ALC, na.rm=T))

################################
# Sum total score MMDS 0 to 25 #
################################

vars04<-c("mmds_wgrain","mmds_fish","mmds_meat","mmds_veg","mmds_fruit","mmds_nut","mmds_legume","mmds_mufasfa","mmds_alcohol")
try$mmds <- apply(try[,vars04],1,sum,na.rm=F) 

#Description
table(try$mmds, useNA = "always")
histogram(try$mmds)
mean(try$mmds,na.rm=T)
# 12.02443


######################################################################################################
#############   3. rMED (Buckland et al 2010), 0-18 based on tertiles energy density        #########
######################################################################################################

# Energy density in grams per 1000kcal
# = Intake in grams per 1000 kcal
try$cerealse <-with(try,GRAINS*1000/F60ENRGY)
try$ffishe <-with(try,ffish*1000/F60ENRGY) # only fresh and frozen fish, not preserved
try$meate <-with(try,meat*1000/F60ENRGY) # !! all meat !!, not only red and processed meat
try$vege <-with(try,VEGTABLS*1000/F60ENRGY)
try$fruitnute <-with(try,fruitnut*1000/F60ENRGY) # nuts, seeds and fruit
try$legumese <-with(try,legumes*1000/F60ENRGY)
try$dairye <-with(try,DAIRY*1000/F60ENRGY)
# We cannot calculate the quantity of olive oil so we will just have 
# a component with a score of 0 if no consumption, and of 2 if consumption
try$oliveoilqtye <-with(try,oliveoilqty*1000/F60ENRGY)

summary(try$cerealse)
summary(try$ffishe)
summary(try$meate)
summary(try$vege)
summary(try$fruitnute)
summary(try$legumese)
summary(try$dairye)
summary(try$oliveoilqtye)

tertiles<-ddply(try, .(), summarise, 
                t1_cerealse=quantile(cerealse,0.333, na.rm=T), t2_cerealse=quantile(cerealse,0.667, na.rm=T),
                t1_ffishe=quantile(ffishe,0.333, na.rm=T), t2_ffishe=quantile(ffishe,0.667, na.rm=T),
                t1_vege=quantile(vege,0.333, na.rm=T), t2_vege=quantile(vege,0.667, na.rm=T),
                t1_meate=quantile(meate,0.333, na.rm=T), t2_meate=quantile(meate,0.667, na.rm=T),
                t1_fruitnute=quantile(fruitnute,0.333, na.rm=T), t2_fruitnute=quantile(fruitnute,0.667, na.rm=T),
                t1_dairye=quantile(dairye,0.333, na.rm=T), t2_dairye=quantile(dairye,0.667, na.rm=T),
                t1_legumese=quantile(legumese,0.333, na.rm=T), t2_legumese=quantile(legumese,0.667, na.rm=T),
                t1_olive=quantile(oliveoilqtye,0.333, na.rm=T), t2_olive=quantile(oliveoilqtye,0.667, na.rm=T),med_olive=median(oliveoilqtye, na.rm = T))
tertiles
# Creation of the 8 items according to the tertiles
try$rmed_cereals <- with(try,ifelse(cerealse<=tertiles$t1_cerealse,0,
                                                ifelse(cerealse<=tertiles$t2_cerealse,1,2)),na.rm=T)
table(try$rmed_cereals, useNA = "always")
try$rmed_fish <- with(try,ifelse(ffishe<=tertiles$t1_ffishe,0,
                                             ifelse(ffishe<=tertiles$t2_ffishe,1,2)),na.rm=T)
# Meat is total meat (not only red meat)
try$rmed_meat <- with(try,ifelse(meate<=tertiles$t1_meate,2, #inverse
                                             ifelse(meate<=tertiles$t2_meate,1,0)),na.rm=T)
try$rmed_dairy <- with(try,ifelse(dairye<=tertiles$t1_dairye,2, #inverse
                                              ifelse(dairye<=tertiles$t2_dairye,1,0)),na.rm=T)
try$rmed_fruit <- with(try,ifelse(fruitnute<=tertiles$t1_fruitnute,0,
                                              ifelse(fruitnute<=tertiles$t2_fruitnute,1,2)),na.rm=T)
try$rmed_veg <- with(try,ifelse(vege<=tertiles$t1_vege,0,
                                            ifelse(vege<=tertiles$t2_vege,1,2)),na.rm=T)
try$rmed_legumes <- with(try,ifelse(legumese<=tertiles$t1_legumese,0,
                                                ifelse(legumese<=tertiles$t2_legumese,1,2)),na.rm=T)
# In the original score the scoring is 0 if no use, 1 if under median, 2 if above
# But here the median is 0, so we use tertiles
try$rmed_oliveoil <- with(try,ifelse(oliveoilqtye<=tertiles$t1_olive,0,
                                    ifelse(oliveoilqtye<=tertiles$t2_olive,1,2)),na.rm=T)

# For the alcohol item, same pre-defined thresholds as MDS, score of 2 if inside the range, 0 if not
try$rmed_alcohol <- with(try,ifelse((try$F60ALC<25 & try$F60ALC>5),2,0))
table(try$rmed_alcohol, useNA = "always")


################################
# Sum total score rMED 0 to 18 #
################################

vars05<-c("rmed_cereals","rmed_fish","rmed_meat","rmed_dairy","rmed_veg","rmed_fruit","rmed_legumes","rmed_oliveoil","rmed_alcohol")
try$rmed <- apply(try[,vars05],1,sum,na.rm=F) 

#Description
table(try$rmed, useNA = "always")
histogram(try$rmed)
mean(try$rmed,na.rm=T)

#  2    6   24   54  102  163  192  208  219  228  197  138  107   55   34   21    7    2    1    0

######################################################################################################
#############   4. WHO HDI 2015      #########
######################################################################################################
# Kanauchi M, Kanauchi K. Prev Med Rep. 2018;12:198-202. doi:10.1016/j.pmedr.2018.09.011

try$p_sfa <-with(try,900*F60SFA/F60ENRGY)
try$p_pufa <-with(try,900*F60PFA/F60ENRGY)
try$p_prot <-with(try,400*F60PROT/F60ENRGY)
try$p_carb <-with(try,400*F60CARB/F60ENRGY)
try$p_fat <-with(try,900*F60FAT/F60ENRGY)
try$p_sug <-with(try,400*F60TSUGR/F60ENRGY) 


summary(try$p_fat)
summary(try$p_prot)
summary(try$p_carb)

# Components
try$hdi2015_sfa <-with(try,ifelse(p_sfa<10,1,0),na.rm=T)
try$hdi2015_sugar<-with(try,ifelse(p_sug<10,1,0),na.rm=T)
try$hdi2015_pufa <-with(try,ifelse((p_pufa<=11 & p_pufa>=6),1,0),na.rm=T)
try$hdi2015_fat <-with(try,ifelse((p_fat<30),1,0),na.rm=T)
try$hdi2015_k <-with(try,ifelse(F60POTAS>=3500,1,0),na.rm=T)
try$hdi2015_fv <-with(try,ifelse(fvgram>=400,1,0),na.rm=T)
try$hdi2015_fib <-with(try,ifelse(F60FIBER>=25,1,0),na.rm=T)

# We check that it was done correctly
try %>%   group_by(hdi2015_sfa) %>% 
  summarise(min=min(p_sfa, na.rm=T), 
            max=max(p_sfa, na.rm=T))
try %>%   group_by(hdi2015_pufa) %>% 
  summarise(min=min(p_pufa, na.rm=T), 
            max=max(p_pufa, na.rm=T))
try %>%   group_by(hdi2015_fat) %>% 
  summarise(min=min(p_fat, na.rm=T), 
            max=max(p_fat, na.rm=T))
try %>%   group_by(hdi2015_k) %>% 
  summarise(min=min(F60POTAS, na.rm=T), 
            max=max(F60POTAS, na.rm=T))
try %>%   group_by(hdi2015_fib) %>% 
  summarise(min=min(F60FIBER, na.rm=T), 
            max=max(F60FIBER, na.rm=T))
try %>%   group_by(hdi2015_fv) %>% 
  summarise(min=min(fvgram, na.rm=T), 
            max=max(fvgram, na.rm=T))
# Score HDI total
try$hdi2015 <-with(try,hdi2015_sfa+hdi2015_pufa+hdi2015_sugar+hdi2015_fat+hdi2015_k+hdi2015_fv+hdi2015_fib)


table(try$hdi2015, useNA = "always")
histogram(try$hdi2015)
mean(try$hdi2015,na.rm=T)

table(try$hdi2015_sfa)
table(try$hdi2015_pufa)
table(try$hdi2015_fat)
table(try$hdi2015_sugar)
table(try$hdi2015_k)
table(try$hdi2015_fv)
table(try$hdi2015_fib)

######################################################################################################
#############   5. DASH (Fung)   8 - 45    #########
######################################################################################################


#Values of 1 to 5 for quintiles

setDT(try)[,dash_fruit := cut(fruitdash, quantile(fruitdash, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE)]
setDT(try)[,dash_veg := cut(VEGTABLS, quantile(VEGTABLS, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE)]
setDT(try)[,dash_legnut := cut(legumenut, quantile(legumenut, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE)]
#setDT(try)[,dash_sweetbev := 5-cut(ssbnojuice, quantile(ssbnojuice, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE)]

setDT(try)[,dash_meat := 6-cut(meat, quantile(meat, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE)] #inverse
setDT(try)[,dash_wholegrain := cut(WHLGRNS, quantile(WHLGRNS, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE)]
setDT(try)[,dash_lfdairy := cut(lfdairy, quantile(lfdairy, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE)]
setDT(try)[,dash_na := 6-cut(F60SODUM, quantile(F60SODUM, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE)] #inverse


# This function does not work for sweet beverages because of too many zeros,
# we do it "by hand"
quintiles <-ddply(try, .(), summarise, 
                  qi1_sb_b=quantile(ssbnojuice,0.20, na.rm=T), qi2_sb_b=quantile(ssbnojuice,0.40, na.rm=T),
                  qi3_sb_b=quantile(ssbnojuice,0.60, na.rm=T), qi4_sb_b=quantile(ssbnojuice,0.80, na.rm=T))

try$dash_sweetbev <- with(try,ifelse(ssbnojuice<=quintiles$qi1_sb_b,5,
                                                 ifelse(ssbnojuice<=quintiles$qi2_sb_b,4,
                                                        ifelse(ssbnojuice<=quintiles$qi3_sb_b,3,
                                                               ifelse(ssbnojuice<=quintiles$qi4_sb_b,2,1)))),na.rm=T)

# We check that it was done correctly
try %>%   group_by(dash_sweetbev) %>% 
  summarise(min=min(ssbnojuice, na.rm=T), 
            max=max(ssbnojuice, na.rm=T))
table(try$dash_sweetbev, useNA = "always")
try %>%   group_by(dash_lfdairy) %>% 
  summarise(min=min(lfdairy, na.rm=T), 
            max=max(lfdairy, na.rm=T))
try %>%   group_by(dash_meat) %>% 
  summarise(min=min(meat, na.rm=T), 
            max=max(meat, na.rm=T))
try %>%   group_by(dash_na) %>% 
  summarise(min=min(F60SODUM, na.rm=T), 
            max=max(F60SODUM, na.rm=T))

table(try$dash_wholegrain, useNA="always")
table(try$dash_sweetbev, useNA="always")
table(try$dash_lfdairy, useNA="always")
table(try$dash_fruit, useNA="always")
table(try$dash_veg, useNA="always")
table(try$dash_legnut, useNA="always")
table(try$dash_meat, useNA="always")
table(try$dash_na, useNA="always")

# Sum total

try$dashf <- with(try,dash_wholegrain+dash_sweetbev+dash_lfdairy+dash_fruit+dash_veg+dash_legnut
                        +dash_meat+dash_na,na.rm=T) 
table(try$dashf, useNA = "always")
histogram(try$dashf)
mean(try$dashf,na.rm=T)
# 24.25625




######################################################################################################
#############   6. Healthful Plant based Diet Index   range 17 - 85    #########
######################################################################################################

# Values of 1 to 5 for quintiles
# The original score ranges 18 - 90

# 7 Healthy plant food
# Wholegrains: we use DASH dash_wholegrain
setDT(try)[,hpdi_fruit := cut(FRUITS, quantile(FRUITS, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE)]
# Vegetables: we use DASH dash_veg 
#setDT(try)[,hpdi_nut := cut(NUTS, quantile(NUTS, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE)]
# --> We do it by hand
setDT(try)[,hpdi_legume := cut(legumes, quantile(legumes, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE)]
#setDT(try)[,hpdi_oil := cut(vegoilqty, quantile(vegoilqty, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE)]
# --> We do it by hand
#setDT(try)[,hpdi_coft := cut(COFFEE, quantile(COFFEE, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE)]
# --> We do it by hand

# 5 Unhealthy plant food
setDT(try)[,hpdi_fruitjuice := 6-cut(juice, quantile(juice, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE)]
setDT(try)[,hpdi_refgrain := 6-cut(refgrain, quantile(refgrain, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE)]
setDT(try)[,hpdi_potato := 6-cut(potato, quantile(potato, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE)]
# Sweetbev: we use DASH dash_sweetbev
setDT(try)[,hpdi_sweet := 6-cut(sweet, quantile(sweet, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE)]

# 6 Unhealthy animal food
#setDT(try)[,hpdi_anifat := 6-cut(anifatqty, quantile(anifatqty, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE)]
# --> We do it by hand
setDT(try)[,hpdi_dairy := 6-cut(DAIRY, quantile(DAIRY, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE)]
setDT(try)[,hpdi_egg := 6-cut(EGGS, quantile(EGGS, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE)]
setDT(try)[,hpdi_fish := 6-cut(FISH, quantile(FISH, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE)]
# meat: we use DASH dash_meat
setDT(try)[,hpdi_animal := 6-cut(animalfood, quantile(animalfood, probs = 0:5/5, na.rm=T), labels = FALSE, include.lowest = TRUE)]

## Do by hand the missing components
quintiles <-ddply(try, .(), summarise, 
                   qi1_oil=quantile(vegoilqty,0.20, na.rm=T), qi2_oil=quantile(vegoilqty,0.40, na.rm=T),
                   qi3_oil=quantile(vegoilqty,0.60, na.rm=T), qi4_oil=quantile(vegoilqty,0.80, na.rm=T),
                   qi1_coft=quantile(COFFEE,0.20, na.rm=T), qi2_coft=quantile(COFFEE,0.40, na.rm=T),
                   qi3_coft=quantile(COFFEE,0.60, na.rm=T), qi4_coft=quantile(COFFEE,0.80, na.rm=T),
                   qi1_anifat=quantile(anifatqty,0.20, na.rm=T), qi2_anifat=quantile(anifatqty,0.40, na.rm=T),
                   qi3_anifat=quantile(anifatqty,0.60, na.rm=T), qi4_anifat=quantile(anifatqty,0.80, na.rm=T),
                   qi1_nut=quantile(NUTS,0.20, na.rm=T), qi2_nut=quantile(NUTS,0.40, na.rm=T),
                   qi3_nut=quantile(NUTS,0.60, na.rm=T), qi4_nut=quantile(NUTS,0.80, na.rm=T))

try$hpdi_coft <- with(try,ifelse(COFFEE<=quintiles$qi1_coft,1,
                                ifelse(COFFEE<=quintiles$qi2_coft,2,
                                       ifelse(COFFEE<=quintiles$qi3_coft,3,
                                              ifelse(COFFEE<=quintiles$qi4_coft,4,5)))),na.rm=T)
try$hpdi_nut <- with(try,ifelse(NUTS<=quintiles$qi1_nut,1,
                                ifelse(NUTS<=quintiles$qi2_nut,2,
                                       ifelse(NUTS<=quintiles$qi3_nut,3,
                                              ifelse(NUTS<=quintiles$qi4_nut,4,5)))),na.rm=T)
try$hpdi_oil <- with(try,ifelse(vegoilqty<=quintiles$qi1_oil,1,
                                ifelse(vegoilqty<=quintiles$qi2_oil,2,
                                       ifelse(vegoilqty<=quintiles$qi3_oil,3,
                                              ifelse(vegoilqty<=quintiles$qi4_oil,4,5)))),na.rm=T)
try$hpdi_anifat <- with(try,ifelse(anifatqty<=quintiles$qi1_anifat,5,
                                ifelse(anifatqty<=quintiles$qi2_anifat,4,
                                       ifelse(anifatqty<=quintiles$qi3_anifat,3,
                                              ifelse(anifatqty<=quintiles$qi4_anifat,2,1)))),na.rm=T)


table(try$hpdi_nut)
# We check that it was done correctly
try %>%   group_by(hpdi_oil) %>% 
  summarise(min=min(vegoilqty, na.rm=T), 
            max=max(vegoilqty, na.rm=T))
try %>%   group_by(hpdi_anifat) %>% 
  summarise(min=min(anifatqty, na.rm=T), 
            max=max(anifatqty, na.rm=T))
try %>%   group_by(hpdi_fruitjuice) %>% 
  summarise(min=min(juice, na.rm=T), 
            max=max(juice, na.rm=T))
try %>%   group_by(hpdi_nut) %>% 
  summarise(min=min(NUTS, na.rm=T), 
            max=max(NUTS, na.rm=T))
try %>%   group_by(hpdi_coft) %>% 
  summarise(min=min(COFFEE, na.rm=T), 
            max=max(COFFEE, na.rm=T))

#### Sum total

setDT(try)
vars09<-c("dash_wholegrain","hpdi_fruit","dash_veg","hpdi_nut","hpdi_legume","hpdi_oil","hpdi_coft",
          "hpdi_fruitjuice","hpdi_refgrain","hpdi_potato","dash_sweetbev","hpdi_sweet",
          "hpdi_anifat","hpdi_dairy","hpdi_egg","hpdi_fish","dash_meat","hpdi_animal")
try$hpdi <-apply(try[, ..vars09],1,sum,na.rm=F)

table(try$hpdi, useNA = "always")

histogram(try$hpdi)
mean(try$hpdi,na.rm=T)




#### SAVE THE DATASET WITH THE SCORES ####


foodvar <- c(names(try)[1:15])
foodvar2<-c(foodvar,"F60VY.x","F60ENRGY","mds","mmds","rmed","hdi2015","dashf","hpdi")
phenofood_whi<-try[,..foodvar2]

save(phenofood_whi,file="./data/WHI/phenofood0_whi.RData")

#### MERGE WITH THE CLINICAL AND QUESTIONNAIRE DATA FOR BMI, PHYSICAL ACTIVITY, SMOKING ####
# load the questionnaire and physical examination datasets downloaded from dbgap 22/11/2021
clinic<-read.table("./data/WHI/phs000200.v12.pht001019.v6.p3.c1.f80_rel1.HMB-IRB.txt",header=T,sep="\t",quote="",stringsAsFactors=F)
clinic<-subset(clinic, F80VY==0)
habits<-read.table("./data/WHI/phs000200.v12.pht001003.v6.p3.c1.f34_rel2.HMB-IRB.txt",header=T,sep="\t",quote="",stringsAsFactors=F)
habitvar<-c("dbGaP_Subject_ID","TEXPWK","SMOKING","ALCOHOL")
habits<-habits[,habitvar]
clinicvar<-c("dbGaP_Subject_ID","WAISTX","HIPX","SYST","DIAS","BMIX","WHRX")
clinic<-clinic[,clinicvar]

# merge the databases
try<-merge(phenofood_whi,habits,by="dbGaP_Subject_ID")
phenofood_whi<-merge(try,clinic,by="dbGaP_Subject_ID")

save(phenofood_whi,file="./data/WHI/phenofood_whi.RData")

# TEXPWK	Total energy expend from recreational phys activity (MET-hours/week)
# SMOKING	Smoking status	0=Never Smoked 1=Past Smoker 2=Current Smoker
# ALCOHOL                     1=Non drinker	2=Past drinker	3=<1 drink per month	4=<1 drink per week	5=1 to <7 drinks per week	6=7+ drinks per week
# WHRX	Waist hip ratio
# SYS   Systolic BP
# DIAS	Diastolic BP
# WAISTX	F80 Waist circumference cm
# HIPX	F80 Hip circumference cm
