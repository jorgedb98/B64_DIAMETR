#!/bin/bash


#SBATCH -J dashf_sva
#SBATCH -o logs/dashf_sva.out
#SBATCH -e logs/dashf_sva.err
#SBATCH -p long

singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv/pheno_2svas.R /home/jdominguez1/B64_DIAMETR/Dades/WHI/phenofood_whi.RData /home/jdominguez1/meth/mvals_z_4sd.RData dashf /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv/num_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv/chr_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv/dashf pheno_sva_
