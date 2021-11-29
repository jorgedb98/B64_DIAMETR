#!/bin/bash

#SBATCH -J rmed_fhs_model
#SBATCH -o rmed_fhs_model.out
#SBATCH -e rmed_fhs_model.err
#SBATCH -p long


singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/rmed/model_rmed.R /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/rmed/pheno_sva_2.csv /home/jdominguez1/meth/mt_value_n_no_extrem_value_analysis.RData rmed /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/rmed/num_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/rmed/chr_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/rmed model_2sva_rmed
