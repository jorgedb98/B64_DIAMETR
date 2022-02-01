#!/bin/bash

#SBATCH -J mixed_dashf
#SBATCH -o logs/dashf_fhs_model_mixed.out
#SBATCH -e logs/dashf_fhs_model_mixed.err
#SBATCH -p fast

for i in {28..28}
do
singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/dashf/model_dashf_mixed.R /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/dashf/pheno_sva_2.csv /home/jdominguez1/meth/fhs/mt_$i/mt_val_$i.RData dashf /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/dashf/num_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/dashf/chr_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/dashf/results_mixed model_2sva_dashf_$i
done
