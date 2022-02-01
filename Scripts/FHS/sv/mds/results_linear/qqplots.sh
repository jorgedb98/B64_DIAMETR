#!/bin/bash

#SBATCH -J qq_fhs_mds
#SBATCH -o logs/qq_fhs_mds.out
#SBATCH -e logs/qq_fhs_mds.err
#SBATCH -p long


singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/mds/results_linear/qqplots.R mds /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/mds/results_linear/model_2sva_mds.RData

