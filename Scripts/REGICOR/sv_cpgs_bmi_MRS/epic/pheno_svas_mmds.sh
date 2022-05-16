#!/bin/bash


#SBATCH -J mmds_sva
#SBATCH -o logs/mmds_sva.out
#SBATCH -e logs/mmds_sva.err
#SBATCH -p long

singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv_cpgs_bmi_MRS/epic/pheno_svas.R /home/jdominguez1/B64_DIAMETR/Dades/REGICOR/metildiet_with_cells_and_rightVars_epic_16052022.RData /home/jdominguez1/meth/epic_total_mtval.RData mmds_mrs /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv_cpgs_bmi_MRS/epic/num_covar_mmds.sh /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv_cpgs_bmi_MRS/epic/chr_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv_cpgs_bmi_MRS/epic/mmds pheno_sva_ 7
