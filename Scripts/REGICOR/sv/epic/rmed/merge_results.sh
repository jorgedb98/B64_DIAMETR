#!/bin/bash

#SBATCH -J merge_rmed
#SBATCH -o logs/merge_rmed.out
#SBATCH -e logs/merge_rmed.err
#SBATCH -p long

singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/epic/rmed/merge_results.R model_7sva_rmed_00 /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/epic/rmed/results
