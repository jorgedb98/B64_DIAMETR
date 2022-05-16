rm(list = ls())
# Load the library
library(qqman)
library(ggrepel)
library(ggplot2)
library(dplyr)

mani<-read.csv("/home/jdominguez1/manifest450k.csv", 
                 skip=7, 
                 stringsAsFactors=F, 
                 header=T, 
                 sep=",",
                 quote="")

rownames(mani) <- mani$IlmnID

res1 = get(load("/home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/dashf/results_mixed/bacon.RData"))

#Lista de CpGs analizados
cpg <- rownames(res1)

mani1 <- mani[cpg,]

#DB para el Manhattan plot
SNP <- cpg
CHR <- as.character(mani1$CHR)
BP <- mani1$MAPINFO
P <- res1$`Corrected Pvalue`
Coefficient <- res1$Coefficient
SE <- res1$SE
manh1 <- as.data.frame(cbind(SNP,CHR,BP,Coefficient,SE,P))

#Cromosomas sexuales
manh1 <- manh1[-which(manh1$CHR=="X"),]
manh1 <- manh1[-which(manh1$CHR=="Y"),]


#Convertir variables a numéricas (SNP-cpg y cromosoma a carácter)
manh1$CHR <- as.character(manh1$CHR)
manh1$SNP <- as.character(manh1$SNP)
manh1$CHR <- as.numeric(manh1$CHR)  
manh1$BP <- as.numeric(as.character(manh1$BP))
manh1$P <- as.numeric(as.character(manh1$P))
manh1$Coefficient <- as.numeric(as.character(manh1$Coefficient))
manh1$SE <- as.numeric(as.character(manh1$SE))

# First of all, we need to compute the cumulative position of SNP.

don <- manh1 %>% 
  
  # Compute chromosome size
  group_by(CHR) %>% 
  summarise(chr_len=max(BP)) %>% 
  
  # Calculate cumulative position of each chromosome
  mutate(tot=cumsum(chr_len)-chr_len) %>%
  select(-chr_len) %>%
  
  # Add this info to the initial dataset
  left_join(manh1, ., by=c("CHR"="CHR")) %>%
  
  # Add a cumulative position of each SNP
  arrange(CHR, BP) %>%
  mutate( BPcum=BP+tot) %>%

  # Add highlight and annotation information
  mutate( is_highlight=ifelse(SNP %in% snpsOfInterest, "yes", "no")) %>%
  mutate( is_annotate=ifelse(-log10(P)>4, "yes", "no")) 

# Then we need to prepare the X axis. Indeed we do not want to display the cumulative position of SNP in bp, but just show the chromosome name instead.

axisdf = don %>% group_by(CHR) %>% summarize(center=( max(BPcum) + min(BPcum) ) / 2 )

# Ready to make the plot using ggplot2:
  
p <- ggplot(don, aes(x=BPcum, y=-log10(P))) +
  geom_hline(yintercept=5, color = "red") +
  geom_hline(yintercept=7, linetype="dashed", color = "#696969") +
  
  # Show all points
  geom_point( aes(color=as.factor(CHR)), alpha=0.8, size=1.3) +
  scale_color_manual(values = rep(c("grey", "black"), 22 )) +
  
  # custom X axis:
  scale_x_continuous( label = axisdf$CHR, breaks= axisdf$center ) +
  scale_y_continuous( label = c(2,4,6,8,10), breaks= c(2,4,6,8,10), expand = c(0,0) ) +     # remove space between plot area and x axis
  
  # Add highlighted points
  # geom_point(data=subset(don, P<0.00001), size=1, scale_color_manual(values = rep(c("grey", "black"), 22 ))) +
  
  # Add label using ggrepel to avoid overlapping
  geom_label_repel( data=subset(don, P<0.00001), aes(label=SNP), size=3,min.segment.length = 0,
                    fill = alpha(c("white"),0.5)) +
  
  # Custom the theme:
  theme_minimal() +
  theme( 
    legend.position="none",
    panel.border = element_blank(),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    axis.text.x=element_text(angle = 90,vjust = 0.2) 
  ) +
   ylab(bquote(-log[10](PValue))) + 
   xlab("Chromosome") +
   labs(title = "Manhattan Plot FHS dashf", subtitle = "Corrected") +
   theme(plot.title = element_text(hjust = 0.5, face = "bold"), plot.subtitle = element_text(hjust = 0.5, face = "italic"))

 ggsave(plot = p, filename = "/home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/dashf/results_mixed/manhattanplot_bacon.png")  
 save(manh1, file="/home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/dashf/results_mixed/bacon_noxy.RData")
 