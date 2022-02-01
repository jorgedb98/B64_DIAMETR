#!/bin/bash

#SBATCH -J dashfL_fhs_model
#SBATCH -o logs/dashf_fhs_model_linear.out
#SBATCH -e logs/dashfL_fhs_model_linear.err
#SBATCH -p long

for i in {1..49}
do
singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/dashf/model_dashf_linear.R /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/dashf/pheno_sva_2.csv /home/jdominguez1/meth/fhs/mt_$i/mt_val_$i.RData dashf /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/dashf/num_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/dashf/chr_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/dashf/results_linear model_2sva_dashf_$i
done
