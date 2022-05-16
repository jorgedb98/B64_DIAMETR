#!/bin/bash


#SBATCH -J mmds_sva
#SBATCH -o logs/mmds_sva.out
#SBATCH -e logs/mmds_sva.err
#SBATCH -p long

singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv_cpgs_bmi_MRS/pheno_2svas.R /home/jdominguez1/B64_DIAMETR/Dades/WHI/phenofood_whi05052022.RData /home/jdominguez1/meth/mvals_z_4sd.RData mmds_mrs /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv_cpgs_bmi_MRS/num_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv_cpgs_bmi_MRS/chr_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv_cpgs_bmi_MRS/mmds pheno_sva_ 6
