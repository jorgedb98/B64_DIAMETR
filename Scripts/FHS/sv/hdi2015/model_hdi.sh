#!/bin/bash

#SBATCH -J model_fhs_hdi
#SBATCH -o model_fhs_hdi.out
#SBATCH -e model_fhs_hdi.err
#SBATCH -p long


singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/hdi/model_hdi.R /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/hdi/pheno_sva_2.csv /home/jdominguez1/meth/mt_value_n_no_extrem_value_analysis.RData hdi2015 /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/hdi/num_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/hdi/chr_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/hdi model_2sva_hdi
