#!/bin/bash


#SBATCH -J rmed_sva
#SBATCH -o rmed_sva.out
#SBATCH -e rmed_sva.err
#SBATCH -p fast

singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/450k/pheno_svas.R /home/jdominguez1/B64_DIAMETR/Dades/REGICOR/metildiet_with_cells_and_rightVars_450.RData /home/jdominguez1/meth/mt_regicor_450.RData rmed_b /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/450k/num_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/450k/chr_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/450k/rmed pheno_sva_
