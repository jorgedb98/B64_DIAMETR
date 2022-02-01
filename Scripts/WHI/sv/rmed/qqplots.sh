#!/bin/bash

#SBATCH -J qq_whi_rmed
#SBATCH -o logs/qq_whi_rmed.out
#SBATCH -e logs/qq_whi_rmed.err
#SBATCH -p long


singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv/rmed/qqplots.R rmed /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv/rmed/model_2sva_rmed.RData

