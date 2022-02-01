#!/bin/bash

#SBATCH -J qq_reg450_hpdi
#SBATCH -o logs/qq_reg450_hpdi.out
#SBATCH -e logs/qq_reg450_hpdi.err
#SBATCH -p fast


singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/450k/hpdi/qqplots.R hpdi /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/450k/hpdi/model_2sva_hpdi.RData

