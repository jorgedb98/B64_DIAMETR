#!/bin/bash

#SBATCH -J qq_whi_hpdi
#SBATCH -o logs/qq_whi_hpdi.out
#SBATCH -e logs/qq_whi_hpdi.err
#SBATCH -p long


singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv/hpdi/qqplots.R hpdi /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv/hpdi/model_2sva_hpdi.RData

