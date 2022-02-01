#!/bin/bash

#SBATCH -J qq_reg450_dashf
#SBATCH -o logs/qq_reg450_dashf_correct.out
#SBATCH -e logs/qq_reg450_dashf_correct.err
#SBATCH -p long


singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/450k/dashf/qqplots_corrected.R dashf /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/450k/dashf/bacon.RData


