#!/bin/bash


#SBATCH -J hpdi_sva
#SBATCH -o logs/hpdi_sva.out
#SBATCH -e logs/hpdi_sva.err
#SBATCH -p long

singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv_cpgs_bmi_MRS/450k/pheno_svas.R /home/jdominguez1/B64_DIAMETR/Dades/REGICOR/metildiet_with_cells_and_rightVars_450_16052022.RData /home/jdominguez1/meth/mt_regicor_450.RData hpdi_mrs /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv_cpgs_bmi_MRS/450k/num_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv_cpgs_bmi_MRS/450k/chr_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv_cpgs_bmi_MRS/450k/hpdi pheno_sva_ 7
