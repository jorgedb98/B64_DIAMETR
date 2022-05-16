rm(list=ls())

print("Loading libraries")
library(bacon)

print("Loading files")
res = commandArgs()[6]

res <- get(load(res))
set.seed(123)
bc <- bacon(teststatistics = NULL, effectsizes = res$Coefficient, standarderrors = res$SE)
bc
lambda <- inflation(bc)
# sigma.0 
# 1.037314
save(lambda, file="/home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv_bmi/hpdi/lambda_bacon.RData")

png("/home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv_bmi/hpdi/qqplot_bacon.png")
plot(bc, type="qq")
###Para añadir la lambda
# text(4, 1, paste0("lambda = ", round(inflation(bc), 3)))
dev.off()

png("/home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv_bmi/hpdi/hist_bacon.png")
plot(bc, type="hist")
dev.off()

coef <- es(bc, corrected = T)
pvals <- pval(bc, corrected = T)
se <- se(bc, corrected = T)

mod <- as.data.frame(cbind(coef, se, pvals), stringsAsFactors=T)
names(mod) <- c("Corrected coefficient", "Corrected SE", "Corrected Pvalue")
mod <- cbind(res, mod)

save(mod, file="/home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv_bmi/hpdi/bacon.RData")
