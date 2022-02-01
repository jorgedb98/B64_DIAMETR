#!/bin/bash


#SBATCH -J bacon_mds
#SBATCH -o logs/bacon_mds.out
#SBATCH -e logs/bacon_mds.err
#SBATCH -p long


singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/mds/results_linear/bacon.R /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/mds/results_linear/model_2sva_mds.RData
