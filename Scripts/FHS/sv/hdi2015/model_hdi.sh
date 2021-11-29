#!/bin/bash

#SBATCH -J hdi_fhs_model
#SBATCH -o hdi_fhs_model.out
#SBATCH -e hdi_fhs_model.err
#SBATCH -p long

singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/hdi2015/model_hdi.R /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/hdi2015/pheno_sva_2.csv /home/jdominguez1/meth/mt_value_n_no_extrem_value_analysis.RData hdi2015 /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/hdi2015/num_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/hdi2015/chr_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/hdi2015 model_2sva_hdi
