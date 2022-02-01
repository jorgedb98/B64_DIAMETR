#!/bin/bash

#SBATCH -J qq_reg450_rmed
#SBATCH -o logs/qq_reg450_rmed.out
#SBATCH -e logs/qq_reg450_rmed.err
#SBATCH -p fast


singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/450k/rmed/qqplots.R rmed /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/450k/rmed/model_2sva_rmed.RData

