# Exploratory Data Analysis of variables in regicor diet score data set
# November 2021 - Jorge Dominguez Barragan
##########################################################################


load("/home/jdominguez1/B64_DIAMETR/Dades/regicor_dietScoring_final.RData")

library(ggplot2)
library(ggpubr)
library(gridExtra)
library(grid)

# age and sex distribution
hist(regicor_dietScoring$edat_b)
plot(as.factor(regicor_dietScoring$sexe))

# mds
g1 <- ggplot(regicor_dietScoring, aes(mds_b, fill = as.factor(sexe))) +
  geom_histogram(binwidth = 0.4, show.legend = F) + 
  theme_minimal() +
  labs(x="Score", y="Count") +
  theme(title = element_text(face = "bold"), plot.subtitle =element_text(face="italic")) +
  theme(plot.title = element_text(size=20)) +
  scale_fill_manual(name = "Sex", labels = c("Men", "Women"), values = c("#d8b365", "#5ab4ac"))

# mmds
g2 <- ggplot(regicor_dietScoring, aes(mmds_b, fill = as.factor(sexe))) +
  geom_histogram(binwidth = 0.4, show.legend = F) + 
  theme_minimal() +
  labs(x="Score", y="Count") +
  theme(title = element_text(face = "bold"), plot.subtitle =element_text(face="italic")) +
  theme(plot.title = element_text(size=20)) +
  scale_fill_manual(name = "Sex", labels = c("Men", "Women"), values = c("#d8b365", "#5ab4ac"))

# rmed
g3 <- ggplot(regicor_dietScoring, aes(rmed_b, fill = as.factor(sexe))) +
  geom_histogram(binwidth = 0.4) + 
  theme_minimal() +
  labs(x="Score", y="Count") +
  theme(title = element_text(face = "bold"), plot.subtitle =element_text(face="italic")) +
  theme(plot.title = element_text(size=20)) +
  scale_fill_manual(name = "Sex", labels = c("Men", "Women"), values = c("#d8b365", "#5ab4ac"))

# hdi
g4 <- ggplot(regicor_dietScoring, aes(hdi_b, fill = as.factor(sexe))) +
  geom_histogram(binwidth = 0.4, show.legend = F) + 
  theme_minimal() +
  labs(x="Score", y="Count") +
  theme(title = element_text(face = "bold"), plot.subtitle =element_text(face="italic")) +
  theme(plot.title = element_text(size=20)) +
  scale_fill_manual(name = "Sex", labels = c("Men", "Women"), values = c("#d8b365", "#5ab4ac"))

# dashf
g5 <- ggplot(regicor_dietScoring, aes(dashf_b, fill = as.factor(sexe))) +
  geom_histogram(binwidth = 0.4, show.legend = F) + 
  labs(x="Score", y="Count") +
  theme_minimal() +
  theme(title = element_text(face = "bold"), plot.subtitle =element_text(face="italic")) +
  theme(plot.title = element_text(size=20)) +
  scale_fill_manual(name = "Sex", labels = c("Men", "Women"), values = c("#d8b365", "#5ab4ac"))

# hpdi
g6 <- ggplot(regicor_dietScoring, aes(hpdi_b, fill = as.factor(sexe))) +
  geom_histogram(binwidth = 0.4) + 
  theme_minimal() +
  labs(x="Score", y="Count") +
  theme(title = element_text(face = "bold"), plot.subtitle =element_text(face="italic")) +
  theme(plot.title = element_text(size=20)) +
  scale_fill_manual(name = "Sex", labels = c("Men", "Women"), values = c("#d8b365", "#5ab4ac"))

figure <- ggarrange(g1 + rremove("xlab") + rremove("ylab"), 
                    g2 + rremove("xlab") + rremove("ylab"),
                    g3 + rremove("xlab") + rremove("ylab"),
                    g4 + rremove("xlab") + rremove("ylab"), 
                    g5 + rremove("xlab") + rremove("ylab"),
                    g6 + rremove("xlab") + rremove("ylab"),
                    labels = c("MDS", "MMDS", "RMED","HDI","DASHF","HPDI"),
                    font.label = list(size=13, color="black", face = "bold", family = NULL),
                    hjust=-5,
                    ncol = 3, nrow = 2,
                    common.legend = T,
                    legend = "right")
annotate_figure(figure, left = textGrob("Count", rot = 90, vjust = 1, gp = gpar(cex = 1.3)),
                bottom = textGrob("Scores", gp = gpar(cex = 1.3)))
