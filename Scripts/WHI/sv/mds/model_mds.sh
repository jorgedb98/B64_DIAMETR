#!/bin/bash

#SBATCH -J mds_whi_model
#SBATCH -o logs/mds_whi_model.out
#SBATCH -e logs/mds_whi_model.err
#SBATCH -p long

for i in {1..48}
do
  singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv/mds/model_mds.R /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv/mds/pheno_sva_2.csv /home/jdominguez1/meth/whi/mt_$i/mt_val_$i.RData mds /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv/mds/num_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv/mds/chr_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv/mds/results model_2sva_mds_$i
done