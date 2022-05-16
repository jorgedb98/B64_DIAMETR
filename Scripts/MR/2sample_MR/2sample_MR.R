##########################################################################################################################################
# Assessing the causal association between diet-related methylation and BMI
##########################################################################################################################################
# install.packages("devtools")
library(devtools)
# devtools::install_github("MRCIEU/TwoSampleMR") 
devtools::install_github("MRCIEU/MRInstruments") 


library(calibrate)
library(ggrepel)
library(ggthemes)
library(TwoSampleMR)
library(MRInstruments)
library(plyr) 
library(ggplot2)
library(png)

rm(list=ls())
setwd("/home/jdominguez1/B64_DIAMETR/Scripts/MR")
######################################
#1 . SELECT SNP-EXPOSURE SUMMARY DATA#
######################################

cpg_exp_data <- get(load("./find_snps/exposure_data.RData"))
head(cpg_exp_data)

# 1. a. How many CpG sites?
unique(cpg_exp_data$CpG)
# 1. b. How many SNPs?
dim(cpg_exp_data)
# 1. c. How many SNPs per CpG?
table(cpg_exp_data$CpG)

########################################################
#2. SELECT SNP-OUTCOME SUMMARY DATA                    #
########################################################
bmi_out_data <- read.table("./BMI/my_BMI_SNPS.csv", header = T, sep=",")
head(bmi_out_data)
#2. a. How many of these SNPs are extracted from the lung cancer data? 
dim(bmi_out_data)

########################################################
#3.  HARMONIZE DATASETS                                #
########################################################

# Harmonise the CpG and bmi cancer datasets so that the effect alleles are the same (and reflect the CpG methylation increasing allele) 
# This syntax will flip the log odds ratio and effect alleles in the bmi dataset where the effect alleles are different between bmi and CpG sites
dat <- harmonise_data(cpg_exp_data, bmi_out_data, action = 2)
# 3. a. Are there any palindromic SNPs?
dim(dat)

palindromic_at<-subset(dat,effect_allele.exposure %in% "A"&other_allele.exposure %in% "T")
palindromic_ta<-subset(dat,effect_allele.exposure %in% "T"&other_allele.exposure %in% "A")
palindromic_gc<-subset(dat,effect_allele.exposure %in% "G"&other_allele.exposure %in% "C")
palindromic_cg<-subset(dat,effect_allele.exposure %in% "C"&other_allele.exposure %in% "G")
dim(palindromic_at)
dim(palindromic_ta)
dim(palindromic_gc)
dim(palindromic_cg)

# If you explore the dataset you'll notice that effect alleles and log odds ratios have been flipped in the ILCCO dataset where the effect allele in the ILCCO dataset was different from the effect allele in the CpG dataset
head(dat)
dim(dat)

######################################################################
#4. ESTIMATE THE CAUSAL EFFECT OF CpG SITE METHYLATION ON LUNG CANCER#
######################################################################
# Let's use the MR-Base R package to estimate the effects using the Wald ratio (for those exposures with 1 SNP), IVW, MR-Egger, weighted median and weighted mode methods
# Have a look at the mr_method_list() function 
mr_results <- mr(dat, method_list=c("mr_wald_ratio","mr_ivw","mr_egger_regression","mr_weighted_median", "mr_weighted_mode"))
mr_results
results<-cbind.data.frame(mr_results$exposure,mr_results$outcome,mr_results$nsnp,mr_results$method,mr_results$b,mr_results$se,mr_results$pval)
write.csv(results,"./CpG_lung_cancer_results.csv")

# 4.a Is there evidence of a causal effect of methylation at any of the CpG sites on lung cancer? 
results

# Estimate odds ratio and 95% confidence interval for an example CpG site (cg23387569)
exp(mr_results$b[1])
exp(mr_results$b[1]-1.96*mr_results$se[1])
exp(mr_results$b[1]+1.96*mr_results$se[1])

# Estimate odds ratio and 95% confidence interval for the CpG site that showed evidence of a relationship with lung cancer (cg23771366)
exp(mr_results$b[8])
exp(mr_results$b[8]-1.96*mr_results$se[8])
exp(mr_results$b[8]+1.96*mr_results$se[8])

# Run some sensitivity analyses
mr_heterogeneity(dat)
mr_pleiotropy_test(dat)
res_single <- mr_singlesnp(dat)
# 4. b. Is there evidence of heterogeneity in the genetic effects? 
res_single

####################################################################
#VISUALIZE THE CAUSAL EFFECT OF CpG SITE METHYLATION ON LUNG CANCER#
####################################################################
# Generate a scatter plot comparing the different methods
# Note that there are multiple exposures so experiment with visualising different CpG sites
# Here we have used one of the CpG sites with the greatest number of SNPs (cg25305703) as an example.
dat2 <- dat[dat$exposure=="cg25305703",]
mr_results2 <- mr(dat2, method_list=c("mr_ivw","mr_egger_regression","mr_weighted_median", "mr_weighted_mode"))
mr_results2
res_single2 <- mr_singlesnp(dat2)
res_single2

png("./cg25305703_lung_cancer_scatter.png")
mr_scatter_plot(mr_results2, dat2)
dev.off()

# 4. c. Is there evidecne of horizontal pleiotropy?
# Generate a forest plot of each of the SNP effects, which are then meta-analysed using the IVW and MR-Egger methods
png("./cg25305703_lung_cancer_forest.png")
mr_forest_plot(res_single2)
dev.off()

# Generate a funnel plot to check asymmetry
png("./cg25305703_lung_cancer_funnel.png")
mr_funnel_plot(res_single2)
dev.off()

# Run a leave-one-out analysis and generate a plot to test whether any one SNP is driving any pleiotropy or asymmetry in the estimates
res_loo2 <- mr_leaveoneout(dat2)
png("./cg25305703_lung_cancer_loo.png")
mr_leaveoneout_plot(res_loo2)
dev.off()

# We can also create a volcano plot for multiple MR results 

# We can then us ggplot2 to generate a volcano plot
# First, we can add an Bonferroni correction onto the results (to impose a strict correction for multiple testing)
# In MR-Base, you can use the "format_mr_results()" command but this requires you to log onto MR-Base (try outside of the course!)
fres <- mr_results
fres <- fres[(fres$method=="Wald ratio" | fres$method=="Inverse variance weighted"),]
fres$effect <- exp(fres$b)
fres$up_ci <- exp(fres$b+(1.96*fres$se))
fres$lo_ci <- exp(fres$b-(1.96*fres$se))
fres$sample_size <- 27209
fres<-fres[!is.na(fres$effect),]
fres$bon <- p.adjust(fres$pval, method="bonferroni")
fres$sig <- fres$bon < 0.05
fres$category <-"<0.05"


ggplot(fres, aes(x=effect, y=-log10(pval))) +
  geom_vline(xintercept=1, linetype="dotted") +
  geom_point(data=subset(fres, !sig)) +
  geom_point(data=subset(fres, sig), aes(colour=category, size=bon < 0.05)) +
  facet_grid(. ~ outcome, scale="free") +
  geom_label_repel(data=subset(fres, bon<0.05), aes(label=exposure, fill=category), colour="white", segment.colour="black", point.padding = unit(0.7, "lines"), box.padding = unit(0.7, "lines"), segment.size=0.5, force=2, max.iter=3e3) +
  theme_bw() + 
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        strip.text.x=element_text(size=20)
  ) +
  scale_colour_brewer(type="qual", palette="Dark2") +
  scale_fill_brewer(type="qual", palette="Dark2") +
  labs(x="OR for lung cancer per SD increase in CpG methylation", size="Bonferroni",y="P value (-log10)") +
  xlim(c(0.8, 1.1))+
  theme(axis.title.y=element_text(size=18),axis.title.x=element_text(size=18),axis.text.y=element_text(size=15),axis.text.x=element_text(size=15),legend.position="none")
ggsave("./volcanoplot_cpg_lung_cancer.png", width=8, height=8)
