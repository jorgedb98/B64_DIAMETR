#!/bin/bash

#SBATCH -J mmds_fhs_model
#SBATCH -o mmds_fhs_model.out
#SBATCH -e mmds_fhs_model.err
#SBATCH -p long


singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/mmds/model_mmds.R /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/mmds/pheno_sva_2.csv /home/jdominguez1/meth/mt_value_n_no_extrem_value_analysis.RData mmds /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/mmds/num_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/mmds/chr_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/mmds model_2sva_mmds
