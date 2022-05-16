#!/bin/bash


#SBATCH -J dashf_sva
#SBATCH -o logs/dashf_sva.out
#SBATCH -e logs/dashf_sva.err
#SBATCH -p long

singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv_bmi/pheno_2svas.R /home/jdominguez1/B64_DIAMETR/Dades/WHI/phenofood_whi22022022.RData /home/jdominguez1/meth/mvals_z_4sd.RData dashf /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv_bmi/num_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv_bmi/chr_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv_bmi/dashf pheno_sva_ 6
