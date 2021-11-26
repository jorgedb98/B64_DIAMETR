#!/bin/bash

#SBATCH -J model_fhs_dashf
#SBATCH -o model_fhs_dashf.out
#SBATCH -e model_fhs_dashf.err
#SBATCH -p long


singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/dashf/model_dashf.R /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/dashf/pheno_sva_2.csv /home/jdominguez1/meth/mt_value_n_no_extrem_value_analysis.RData dashf /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/dashf/num_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/dashf/chr_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/dashf model_2sva_dashf