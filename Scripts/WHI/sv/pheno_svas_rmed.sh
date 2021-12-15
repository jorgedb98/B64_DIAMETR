#!/bin/bash


#SBATCH -J rmed_sva
#SBATCH -o rmed_sva.out
#SBATCH -e rmed_sva.err
#SBATCH -p fast

singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv/pheno_2svas.R /home/jdominguez1/B64_DIAMETR/Dades/WHI/phenofood_whi.RData /home/jdominguez1/meth/mvals_z_4sd.RData rmed /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv/num_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv/chr_covar.sh /home/jdominguez1/B64_DIAMETR/WHI/FHS/sv/rmed pheno_sva_
