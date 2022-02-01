#!/bin/bash

#SBATCH -J rmed_whi_model
#SBATCH -o logs/rmed_whi_model.out
#SBATCH -e logs/rmed_whi_model.err
#SBATCH -p long

for i in {1..48}
do
  singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv/rmed/model_rmed.R /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv/rmed/pheno_sva_2.csv /home/jdominguez1/meth/whi/mt_$i/mt_val_$i.RData rmed /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv/rmed/num_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv/rmed/chr_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv/rmed/results model_2sva_rmed_$i
done