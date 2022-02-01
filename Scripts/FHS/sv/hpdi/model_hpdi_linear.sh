#!/bin/bash

#SBATCH -J hpdiL_fhs_model
#SBATCH -o logs/hpdi_fhs_model_linear.out
#SBATCH -e logs/hpdiL_fhs_model_linear.err
#SBATCH -p long

for i in {1..49}
do
singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/hpdi/model_hpdi_linear.R /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/hpdi/pheno_sva_2.csv /home/jdominguez1/meth/fhs/mt_$i/mt_val_$i.RData hpdi /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/hpdi/num_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/hpdi/chr_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/hpdi/results_linear model_2sva_hpdi_$i
done
