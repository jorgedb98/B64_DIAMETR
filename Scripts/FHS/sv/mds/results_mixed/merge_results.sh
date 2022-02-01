#!/bin/bash

#SBATCH -J merge_mds
#SBATCH -o logs/merge_mds.out
#SBATCH -e logs/merge_mds.err
#SBATCH -p long

singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/mds/results_mixed/merge_results.R model_2sva_mds_00 /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/mds/results_mixed/small
