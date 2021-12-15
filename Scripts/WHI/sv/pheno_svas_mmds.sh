#!/bin/bash


#SBATCH -J mmds_sva
#SBATCH -o mmds_sva.out
#SBATCH -e mmds_sva.err
#SBATCH -p fast

singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv/pheno_2svas.R /home/jdominguez1/B64_DIAMETR/Dades/WHI/phenofood_whi.RData /home/jdominguez1/meth/mvals_z_4sd.RData mmds /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv/num_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv/chr_covar.sh /home/jdominguez1/B64_DIAMETR/WHI/FHS/sv/mmds pheno_sva_
