#!/bin/bash


#SBATCH -J mmds_sva
#SBATCH -o logs/mmds_sva.out
#SBATCH -e logs/mmds_sva.err
#SBATCH -p long

singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/pheno_2svas.R /home/jdominguez1/B64_DIAMETR/Dades/FHS/phenofood_fhs_23022022.RData /home/jdominguez1/meth/mt_value_n_no_extrem_value_analysis.RData mmds /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/num_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/chr_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/mmds pheno_sva_
