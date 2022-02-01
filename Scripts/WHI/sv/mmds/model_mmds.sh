#!/bin/bash

#SBATCH -J mmds_whi_model
#SBATCH -o logs/mmds_whi_model.out
#SBATCH -e logs/mmds_whi_model.err
#SBATCH -p long

for i in {1..48}
do
  singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv/mmds/model_mmds.R /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv/mmds/pheno_sva_2.csv /home/jdominguez1/meth/whi/mt_$i/mt_val_$i.RData mmds /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv/mmds/num_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv/mmds/chr_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv/mmds/results model_2sva_mmds_$i
done