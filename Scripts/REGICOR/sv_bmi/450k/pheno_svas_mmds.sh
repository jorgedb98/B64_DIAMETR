#!/bin/bash


#SBATCH -J mmds_sva
#SBATCH -o logs/mmds_sva.out
#SBATCH -e logs/mmds_sva.err
#SBATCH -p long

singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv_bmi/450k/pheno_svas.R /home/jdominguez1/B64_DIAMETR/Dades/REGICOR/metildiet_with_cells_and_rightVars_450.RData /home/jdominguez1/meth/mt_regicor_450.RData mmds_b /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv_bmi/450k/num_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv_bmi/450k/chr_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv_bmi/450k/mmds pheno_sva_ 7
