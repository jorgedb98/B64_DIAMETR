#!/bin/bash

#SBATCH -J qq_fhs_hpdi
#SBATCH -o logs/qq_fhs_hpdi_correct.out
#SBATCH -e logs/qq_fhs_hpdi_correct.err
#SBATCH -p long


singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/hpdi/results_linear/qqplots_corrected.R hpdi /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/hpdi/results_linear/bacon.RData


