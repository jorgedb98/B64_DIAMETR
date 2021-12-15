#!/bin/bash


#SBATCH -J hdi_sva
#SBATCH -o hdi_sva.out
#SBATCH -e hdi_sva.err
#SBATCH -p fast

singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv/pheno_2svas.R /home/jdominguez1/B64_DIAMETR/Dades/WHI/phenofood_whi.RData /home/jdominguez1/meth/mvals_z_4sd.RData hdi /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv/num_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv/chr_covar.sh /home/jdominguez1/B64_DIAMETR/WHI/FHS/sv/hdi2015 pheno_sva_