#!/bin/bash

#SBATCH -J merge_mmds
#SBATCH -o logs/merge_mmds.out
#SBATCH -e logs/merge_mmds.err
#SBATCH -p fast

singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/epic/mmds/merge_results.R model_7sva_mmds_00 /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/epic/mmds/results
