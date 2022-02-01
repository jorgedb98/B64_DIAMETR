#!/bin/bash

#SBATCH -J merge_dashf
#SBATCH -o logs/merge_dashf.out
#SBATCH -e logs/merge_dashf.err
#SBATCH -p long

singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/dashf/results_mixed/merge_results.R model_2sva_dashf_00 /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/dashf/results_mixed/small
