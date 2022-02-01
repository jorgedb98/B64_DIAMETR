#!/bin/bash

#SBATCH -J qq_fhs_mmds
#SBATCH -o logs/qq_fhs_mmds_correct.out
#SBATCH -e logs/qq_fhs_mmds_correct.err
#SBATCH -p long


singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/mmds/results_mixed/qqplots_corrected.R mmds /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/mmds/results_mixed/bacon.RData


