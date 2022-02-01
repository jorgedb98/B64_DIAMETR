#!/bin/bash

#SBATCH -J hpdi_epic_model
#SBATCH -o logs/hpdi_epic_model.out
#SBATCH -e logs/hpdi_epic_model.err
#SBATCH -p fast

for i in {1..82}
do
  singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/epic/hpdi/model_hpdi.R /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/epic/hpdi/pheno_sva_7.csv /home/jdominguez1/meth/epic/mt_$i/mt_val_$i.RData hpdi_b /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/epic/hpdi/num_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/epic/hpdi/chr_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/epic/hpdi/results model_7sva_hpdi_$i
done