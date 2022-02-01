#!/bin/bash

#SBATCH -J dashf_450k_model
#SBATCH -o logs/dashf_450k_model.out
#SBATCH -e logs/dashf_450k_model.err
#SBATCH -p long

for i in {1..42}
do
  singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/450k/dashf/model_dashf.R /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/450k/dashf/pheno_sva_2.csv /home/jdominguez1/meth/450k/mt_$i/mt_val_$i.RData dashf_b /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/450k/dashf/num_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/450k/dashf/chr_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/450k/dashf/results model_2sva_dashf_$i
done