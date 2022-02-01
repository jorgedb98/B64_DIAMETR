#!/bin/bash

#SBATCH -J qq_whi_mmds
#SBATCH -o logs/qq_whi_mmds.out
#SBATCH -e logs/qq_whi_mmds.err
#SBATCH -p long


singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv/mmds/qqplots.R mmds /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv/mmds/model_2sva_mmds.RData

