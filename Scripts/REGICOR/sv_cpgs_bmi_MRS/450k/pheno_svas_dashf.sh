#!/bin/bash


#SBATCH -J dashf_sva
#SBATCH -o logs/dashf_sva.out
#SBATCH -e logs/dashf_sva.err
#SBATCH -p fast

singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv_cpgs_bmi_MRS/450k/pheno_svas.R /home/jdominguez1/B64_DIAMETR/Dades/REGICOR/metildiet_with_cells_and_rightVars_450_16052022.RData /home/jdominguez1/meth/mt_regicor_450.RData dashf_mrs /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv_cpgs_bmi_MRS/450k/num_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv_cpgs_bmi_MRS/450k/chr_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv_cpgs_bmi_MRS/450k/dashf pheno_sva_ 3
