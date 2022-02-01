#!/bin/bash

#SBATCH -J qq_reg450_rmed
#SBATCH -o logs/qq_reg450_rmed_correct.out
#SBATCH -e logs/qq_reg450_rmed_correct.err
#SBATCH -p long


singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/450k/rmed/qqplots_corrected.R rmed /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/450k/rmed/bacon.RData


