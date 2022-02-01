#!/bin/bash

#SBATCH -J qq_reg450_mmds
#SBATCH -o logs/qq_reg450_mmds_correct.out
#SBATCH -e logs/qq_reg450_mmds_correct.err
#SBATCH -p long


singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/450k/mmds/qqplots_corrected.R mmds /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/450k/mmds/bacon.RData


