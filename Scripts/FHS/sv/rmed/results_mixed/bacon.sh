#!/bin/bash


#SBATCH -J bacon_rmed
#SBATCH -o logs/bacon_rmed.out
#SBATCH -e logs/bacon_rmed.err
#SBATCH -p long


singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/rmed/results_mixed/bacon.R /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/rmed/results_mixed/model_2sva_rmed.RData
