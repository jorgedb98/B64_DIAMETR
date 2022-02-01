#!/bin/bash

#SBATCH -J qq_fhs_dashf
#SBATCH -o logs/qq_fhs_dashf_correct.out
#SBATCH -e logs/qq_fhs_dashf_correct.err
#SBATCH -p long


singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/dashf/results_linear/qqplots_corrected.R dashf /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/dashf/results_linear/bacon.RData


