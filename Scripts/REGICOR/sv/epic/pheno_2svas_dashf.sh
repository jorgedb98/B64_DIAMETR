#!/bin/bash


#SBATCH -J dashf_sva
#SBATCH -o dashf_sva.out
#SBATCH -e dashf_sva.err
#SBATCH -p fast

singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/epic/pheno_2svas.R /home/jdominguez1/B64_DIAMETR/Dades/REGICOR/metildiet_with_cells_and_rightVars_epic.RData /home/jdominguez1/meth/epic_total_mtval.RData dashf_b /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/epic/num_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/epic/chr_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/epic/hdi2015 pheno_sva_
