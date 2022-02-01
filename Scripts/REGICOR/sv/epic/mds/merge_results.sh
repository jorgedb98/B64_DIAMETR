#!/bin/bash

#SBATCH -J merge_mds
#SBATCH -o logs/merge_mds.out
#SBATCH -e logs/merge_mds.err
#SBATCH -p long

singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/epic/mds/merge_results.R model_7sva_mds_00 /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/epic/mds/results
