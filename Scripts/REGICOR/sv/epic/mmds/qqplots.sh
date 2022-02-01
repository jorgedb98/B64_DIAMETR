#!/bin/bash

#SBATCH -J qq_regepic_mmds
#SBATCH -o logs/qq_regepic_mmds.out
#SBATCH -e logs/qq_regepic_mmds.err
#SBATCH -p long


singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/epic/mmds/qqplots.R mmds /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/epic/mmds/model_7sva_mmds.RData

