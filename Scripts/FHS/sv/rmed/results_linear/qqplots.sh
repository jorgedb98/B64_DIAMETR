#!/bin/bash

#SBATCH -J qq_fhs_rmed
#SBATCH -o logs/qq_fhs_rmed.out
#SBATCH -e logs/qq_fhs_rmed.err
#SBATCH -p long


singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/rmed/results_linear/qqplots.R rmed /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/rmed/results_linear/model_2sva_rmed.RData

