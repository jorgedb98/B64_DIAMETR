#!/bin/bash


#SBATCH -J hpdi_sva
#SBATCH -o logs/hpdi_sva.out
#SBATCH -e logs/hpdi_sva.err
#SBATCH -p long

singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv_cpgs_bmi_MRS/pheno_2svas.R /home/jdominguez1/B64_DIAMETR/Dades/FHS/phenofood_fhs_05052022.RData /home/jdominguez1/meth/mt_value_n_no_extrem_value_analysis.RData hpdi_mrs /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv_cpgs_bmi_MRS/num_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv_cpgs_bmi_MRS/chr_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv_cpgs_bmi_MRS/hpdi pheno_sva_ 6
