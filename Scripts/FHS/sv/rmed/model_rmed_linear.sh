#!/bin/bash

#SBATCH -J rmedL_fhs_model
#SBATCH -o logs/rmed_fhs_model_linear.out
#SBATCH -e logs/rmedL_fhs_model_linear.err
#SBATCH -p long

for i in {1..49}
do
singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/rmed/model_rmed_linear.R /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/rmed/pheno_sva_2.csv /home/jdominguez1/meth/fhs/mt_$i/mt_val_$i.RData rmed /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/rmed/num_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/rmed/chr_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/rmed/results_linear model_2sva_rmed_$i
done
