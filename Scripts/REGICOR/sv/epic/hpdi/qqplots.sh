#!/bin/bash

#SBATCH -J qq_regepic_hpdi
#SBATCH -o logs/qq_regepic_hpdi.out
#SBATCH -e logs/qq_regepic_hpdi.err
#SBATCH -p long


singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/epic/hpdi/qqplots.R hpdi /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/epic/hpdi/model_6sva_hpdi.RData

