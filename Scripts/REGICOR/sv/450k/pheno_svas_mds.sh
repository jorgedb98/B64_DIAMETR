#!/bin/bash


#SBATCH -J mds_sva
#SBATCH -o logs/mds_sva.out
#SBATCH -e logs/mds_sva.err
#SBATCH -p fast

singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/450k/pheno_svas.R /home/jdominguez1/B64_DIAMETR/Dades/REGICOR/metildiet_with_cells_and_rightVars_450.RData /home/jdominguez1/meth/mt_regicor_450.RData mds_b /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/450k/num_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/450k/chr_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/450k/mds pheno_sva_
