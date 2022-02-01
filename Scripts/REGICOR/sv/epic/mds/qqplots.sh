#!/bin/bash

#SBATCH -J qq_regepic_mds
#SBATCH -o logs/qq_regepic_mds.out
#SBATCH -e logs/qq_regepic_mds.err
#SBATCH -p long


singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/epic/mds/qqplots.R mds /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/epic/mds/model_7sva_mds.RData

