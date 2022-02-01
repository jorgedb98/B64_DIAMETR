#!/bin/bash

#SBATCH -J qq_whi_mds
#SBATCH -o logs/qq_whi_mds_correct.out
#SBATCH -e logs/qq_whi_mds_correct.err
#SBATCH -p long


singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv/mds/qqplots_corrected.R mds /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv/mds/bacon.RData


