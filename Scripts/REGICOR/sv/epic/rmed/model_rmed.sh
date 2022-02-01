#!/bin/bash

#SBATCH -J rmed_epic_model
#SBATCH -o logs/rmed_epic_model.out
#SBATCH -e logs/rmed_epic_model.err
#SBATCH -p fast

for i in {1..82}
do
  singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/epic/rmed/model_rmed.R /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/epic/rmed/pheno_sva_7.csv /home/jdominguez1/meth/epic/mt_$i/mt_val_$i.RData rmed_b /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/epic/rmed/num_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/epic/rmed/chr_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/epic/rmed/results model_7sva_rmed_$i
done
