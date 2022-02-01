#!/bin/bash

#SBATCH -J mds_epic_model
#SBATCH -o logs/mds_epic_model.out
#SBATCH -e logs/mds_epic_model.err
#SBATCH -p long

for i in {1..82}
do
  singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/epic/mds/model_mds.R /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/epic/mds/pheno_sva_7.csv /home/jdominguez1/meth/epic/mt_$i/mt_val_$i.RData mds_b /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/epic/mds/num_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/epic/mds/chr_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/epic/mds/results model_7sva_mds_$i
done
