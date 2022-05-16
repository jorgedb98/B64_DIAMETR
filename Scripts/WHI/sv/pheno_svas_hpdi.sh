#!/bin/bash


#SBATCH -J hpdi_sva
#SBATCH -o logs/hpdi_sva.out
#SBATCH -e logs/hpdi_sva.err
#SBATCH -p fast

singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv/pheno_2svas.R /home/jdominguez1/B64_DIAMETR/Dades/WHI/phenofood_whi22022022.RData /home/jdominguez1/meth/mvals_z_4sd.RData hpdi /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv/num_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv/chr_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv/hpdi pheno_sva_
