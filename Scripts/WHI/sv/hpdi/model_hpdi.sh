#!/bin/bash

#SBATCH -J hpdi_whi_model
#SBATCH -o logs/hpdi_whi_model.out
#SBATCH -e logs/hpdi_whi_model.err
#SBATCH -p long

for i in {1..48}
do
  singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv/hpdi/model_hpdi.R /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv/hpdi/pheno_sva_2.csv /home/jdominguez1/meth/whi/mt_$i/mt_val_$i.RData hpdi /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv/hpdi/num_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv/hpdi/chr_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv/hpdi/results model_2sva_hpdi_$i
done