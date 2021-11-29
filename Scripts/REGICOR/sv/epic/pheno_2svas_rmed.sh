#!/bin/bash


#SBATCH -J rmed_sva
#SBATCH -o rmed_sva.out
#SBATCH -e rmed_sva.err
#SBATCH -p long

singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/pheno_2svas.R /home/jdominguez1/B64_DIAMETR/Dades/REGICOR/metildiet_with_cells_and_rightVars.RData /home/jdominguez1/meth/mt_value_n_no_extrem_value_analysis.RData rmed /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/num_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/chr_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/rmed pheno_sva_
