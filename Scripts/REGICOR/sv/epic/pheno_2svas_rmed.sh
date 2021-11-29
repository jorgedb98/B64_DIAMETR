#!/bin/bash


#SBATCH -J rmed_sva
#SBATCH -o rmed_sva.out
#SBATCH -e rmed_sva.err
#SBATCH -p fast

singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/epic/pheno_2svas.R /home/jdominguez1/B64_DIAMETR/Dades/REGICOR/metildiet_with_cells_and_rightVars.RData /home/jdominguez1/meth/epic_total_mtval.RData rmed_b /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/epic/num_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/epic/chr_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/epic/rmed pheno_sva_
