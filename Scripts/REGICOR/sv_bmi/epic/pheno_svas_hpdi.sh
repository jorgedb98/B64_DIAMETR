#!/bin/bash


#SBATCH -J hpdi_sva
#SBATCH -o logs/hpdi_sva.out
#SBATCH -e logs/hpdi_sva.err
#SBATCH -p long

singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv_bmi/epic/pheno_svas.R /home/jdominguez1/B64_DIAMETR/Dades/REGICOR/metildiet_with_cells_and_rightVars_epic.RData /home/jdominguez1/meth/epic_total_mtval.RData hpdi_b /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv_bmi/epic/num_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv_bmi/epic/chr_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv_bmi/epic/hpdi pheno_sva_ 7
