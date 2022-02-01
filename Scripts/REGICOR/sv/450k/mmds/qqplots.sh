#!/bin/bash

#SBATCH -J qq_reg450_mmds
#SBATCH -o logs/qq_reg450_mmds.out
#SBATCH -e logs/qq_reg450_mmds.err
#SBATCH -p fast


singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/450k/mmds/qqplots.R mmds /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/450k/mmds/model_2sva_mmds.RData

