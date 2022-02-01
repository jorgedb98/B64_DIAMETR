#!/bin/bash

#SBATCH -J mdsL_fhs_model
#SBATCH -o logs/mds_fhs_model_linear.out
#SBATCH -e logs/mdsL_fhs_model_linear.err
#SBATCH -p long

for i in {1..49}
do
singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/mds/model_mds_linear.R /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/mds/pheno_sva_2.csv /home/jdominguez1/meth/fhs/mt_$i/mt_val_$i.RData mds /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/mds/num_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/mds/chr_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/mds/results_linear model_2sva_mds_$i
done
