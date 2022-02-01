#!/bin/bash

#SBATCH -J qq_whi_mds
#SBATCH -o logs/qq_whi_mds.out
#SBATCH -e logs/qq_whi_mds.err
#SBATCH -p long


singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv/mds/qqplots.R mds /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv/mds/model_2sva_mds.RData

