#!/bin/bash

#SBATCH -J mmds_450k_model
#SBATCH -o logs/mmds_450k_model.out
#SBATCH -e logs/mmds_450k_model.err
#SBATCH -p fast

for i in {1..42}
do
  singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/450k/mmds/model_mmds.R /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/450k/mmds/pheno_sva_2.csv /home/jdominguez1/meth/450k/mt_$i/mt_val_$i.RData mmds_b /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/450k/mmds/num_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/450k/mmds/chr_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/450k/mmds/results model_2sva_mmds_$i
done