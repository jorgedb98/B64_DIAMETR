#!/bin/bash

#SBATCH -J qq_regepic_dashf
#SBATCH -o logs/qq_regepic_dashf.out
#SBATCH -e logs/qq_regepic_dashf.err
#SBATCH -p fast


singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/epic/dashf/qqplots.R dashf /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/epic/dashf/model_3sva_dashf.RData

