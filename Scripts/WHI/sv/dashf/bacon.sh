#!/bin/bash


#SBATCH -J bacon_dashf
#SBATCH -o logs/bacon_dashf.out
#SBATCH -e logs/bacon_dashf.err
#SBATCH -p long


singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv/dashf/bacon.R /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv/dashf/model_6sva_dashf.RData
