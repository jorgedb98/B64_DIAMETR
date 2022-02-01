#!/bin/bash

#SBATCH -J mmds_epic_model
#SBATCH -o logs/mmds_epic_model.out
#SBATCH -e logs/mmds_epic_model.err
#SBATCH -p long

for i in {1..82}
do
  singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/epic/mmds/model_mmds.R /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/epic/mmds/pheno_sva_7.csv /home/jdominguez1/meth/epic/mt_$i/mt_val_$i.RData mmds_b /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/epic/mmds/num_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/epic/mmds/chr_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/epic/mmds/results model_7sva_mmds_$i
done
