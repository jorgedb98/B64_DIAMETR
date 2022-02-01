#!/bin/bash

#SBATCH -J mixed_rmed
#SBATCH -o logs/rmed_fhs_model_mixed.out
#SBATCH -e logs/rmed_fhs_model_mixed.err
#SBATCH -p fast

for i in {9..12}
do
singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/rmed/model_rmed_mixed.R /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/rmed/pheno_sva_2.csv /home/jdominguez1/meth/fhs/mt_$i/mt_val_$i.RData rmed /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/rmed/num_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/rmed/chr_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/rmed/results_mixed model_2sva_rmed_$i
done
