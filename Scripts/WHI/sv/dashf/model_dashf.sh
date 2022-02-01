#!/bin/bash

#SBATCH -J dashf_whi_model
#SBATCH -o logs/dashf_whi_model.out
#SBATCH -e logs/dashf_whi_model.err
#SBATCH -p long

for i in {1..48}
do
  singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv/dashf/model_dashf.R /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv/dashf/pheno_sva_6.csv /home/jdominguez1/meth/whi/mt_$i/mt_val_$i.RData dashf /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv/dashf/num_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv/dashf/chr_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv/dashf/results model_6sva_dashf_$i
done