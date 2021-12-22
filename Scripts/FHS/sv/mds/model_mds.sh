#!/bin/bash

#SBATCH -J mds_fhs_model
#SBATCH -o mds_fhs_model.out
#SBATCH -e mds_fhs_model.err
#SBATCH -p long


singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/mds/model_mds.R /home/jdominguez1/B64_DIAMETR/Dades/FHS/sv/mds/pheno_sva_2.csv /home/jdominguez1/meth/mt_value_n_no_extrem_value_analysis.RData mds /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/mds/num_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/mds/chr_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/mds model_2sva_mds
