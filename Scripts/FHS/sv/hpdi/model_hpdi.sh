#!/bin/bash

#SBATCH -J model_fhs_hpdi
#SBATCH -o model_fhs_hpdi.out
#SBATCH -e model_fhs_hpdi.err
#SBATCH -p long


singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/hpdi/model_hpdi.R /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/hpdi/pheno_sva_2.csv /home/jdominguez1/meth/mt_value_n_no_extrem_value_analysis.RData hpdi /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/hpdi/num_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/hpdi/chr_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/hpdi model_2sva_hpdi
