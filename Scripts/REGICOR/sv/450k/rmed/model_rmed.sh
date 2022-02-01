#!/bin/bash

#SBATCH -J rmed_450k_model
#SBATCH -o rmed_450k_model.out
#SBATCH -e rmed_450k_model.err
#SBATCH -p long

for i in {1..42}
do
  singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/450k/rmed/model_rmed.R /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/450k/rmed/pheno_sva_2.csv /home/jdominguez1/meth/450k/mt_$i/mt_val_$i.RData rmed_b /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/450k/rmed/num_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/450k/rmed/chr_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/450k/rmed/results model_2sva_rmed_$i
done
