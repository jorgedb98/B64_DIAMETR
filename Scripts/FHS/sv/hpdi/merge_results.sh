#!/bin/bash

#SBATCH -J merge_hpdi
#SBATCH -o merge_hpdi.out
#SBATCH -e merge_hpdi.err
#SBATCH -p long

singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/hpdi/merge_results.R model_2sva_hpdi_00 /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/hpdi/results
