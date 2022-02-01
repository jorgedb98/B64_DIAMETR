#!/bin/bash

#SBATCH -J qq_reg450_dashf
#SBATCH -o logs/qq_reg450_dashf.out
#SBATCH -e logs/qq_reg450_dashf.err
#SBATCH -p fast


singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/450k/dashf/qqplots.R dashf /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/450k/dashf/model_2sva_dashf.RData

