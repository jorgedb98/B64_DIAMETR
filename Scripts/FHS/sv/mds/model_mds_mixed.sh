#!/bin/bash

#SBATCH -J mixed_mds
#SBATCH -o logs/mds_fhs_model_mixed.out
#SBATCH -e logs/mds_fhs_model_mixed.err
#SBATCH -p long

for i in {11..11}
do
singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/mds/model_mds_mixed.R /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/mds/pheno_sva_2.csv /home/jdominguez1/meth/fhs/mt_$i/mt_val_$i.RData mds /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/mds/num_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/mds/chr_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/mds/results_mixed model_2sva_mds_$i
done
