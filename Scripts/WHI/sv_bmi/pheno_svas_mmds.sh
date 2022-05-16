#!/bin/bash


#SBATCH -J mmds_sva
#SBATCH -o logs/mmds_sva.out
#SBATCH -e logs/mmds_sva.err
#SBATCH -p fast

singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv_bmi/pheno_2svas.R /home/jdominguez1/B64_DIAMETR/Dades/WHI/phenofood_whi22022022.RData /home/jdominguez1/meth/mvals_z_4sd.RData mmds /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv_bmi/num_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv_bmi/chr_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv_bmi/mmds pheno_sva_ 2
