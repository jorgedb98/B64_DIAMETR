#!/bin/bash


#SBATCH -J mmds_sva
#SBATCH -o logs/mmds_sva.out
#SBATCH -e logs/mmds_sva.err
#SBATCH -p fast

singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv_cpgs_bmi_MRS/pheno_2svas.R /home/jdominguez1/B64_DIAMETR/Dades/FHS/phenofood_fhs_05052022.RData /home/jdominguez1/meth/mt_value_n_no_extrem_value_analysis.RData mmds_mrs /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv_cpgs_bmi_MRS/num_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv_cpgs_bmi_MRS/chr_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv_cpgs_bmi_MRS/mmds pheno_sva_ 6
