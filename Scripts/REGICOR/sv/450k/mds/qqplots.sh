#!/bin/bash

#SBATCH -J qq_reg450_mds
#SBATCH -o logs/qq_reg450_mds.out
#SBATCH -e logs/qq_reg450_mds.err
#SBATCH -p fast


singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/450k/mds/qqplots.R mds /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/450k/mds/model_2sva_mds.RData

