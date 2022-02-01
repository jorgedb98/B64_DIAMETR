#!/bin/bash

#SBATCH -J dashf_epic_model
#SBATCH -o logs/dashf_epic_model.out
#SBATCH -e logs/dashf_epic_model.err
#SBATCH -p long

for i in {1..82}
do
  singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/epic/dashf/model_dashf.R /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/epic/dashf/pheno_sva_3.csv /home/jdominguez1/meth/epic/mt_$i/mt_val_$i.RData dashf_b /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/epic/dashf/num_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/epic/dashf/chr_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/epic/dashf/results model_3sva_dashf_$i
done