#!/bin/bash

#SBATCH -J linear_mmds
#SBATCH -o logs/mmds_fhs_model_linear.out
#SBATCH -e logs/mmds_fhs_model_linear.err
#SBATCH -p long

for i in {1..49}
do
singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/mmds/model_mmds_linear.R /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/mmds/pheno_sva_2.csv /home/jdominguez1/meth/fhs/mt_$i/mt_val_$i.RData mmds /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/mmds/num_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/mmds/chr_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/mmds/results_linear model_2sva_mmds_$i
done