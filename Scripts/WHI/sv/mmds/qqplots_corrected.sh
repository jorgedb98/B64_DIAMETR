#!/bin/bash

#SBATCH -J qq_whi_mmds
#SBATCH -o logs/qq_whi_mmds_correct.out
#SBATCH -e logs/qq_whi_mmds_correct.err
#SBATCH -p long


singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv/mmds/qqplots_corrected.R mmds /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv/mmds/bacon.RData


