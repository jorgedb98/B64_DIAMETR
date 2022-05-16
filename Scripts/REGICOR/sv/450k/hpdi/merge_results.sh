#!/bin/bash

#SBATCH -J merge_hpdi
#SBATCH -o logs/merge_hpdi.out
#SBATCH -e logs/merge_hpdi.err
#SBATCH -p fast

singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/450k/hpdi/merge_results.R model_2sva_hpdi_00 /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/450k/hpdi/results
