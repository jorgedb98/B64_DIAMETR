#!/bin/bash

#SBATCH -J hpdi_450k_model
#SBATCH -o logs/hpdi_450k_model.out
#SBATCH -e logs/hpdi_450k_model.err
#SBATCH -p long

for i in {1..42}
do
  singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/450k/hpdi/model_hpdi.R /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/450k/hpdi/pheno_sva_2.csv /home/jdominguez1/meth/450k/mt_$i/mt_val_$i.RData hpdi /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/450k/hpdi/num_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/450k/hpdi/chr_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/450k/hpdi/results model_2sva_hpdi_$i
done