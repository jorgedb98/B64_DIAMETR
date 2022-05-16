#!/bin/bash

#SBATCH -J meta_hpdi
#SBATCH -o logs/meta_hpdi.out
#SBATCH -e logs/meta_hpdi.err
#SBATCH -p long

singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/Meta_Airwave_ICL/hpdi/meta.R /home/jdominguez1/B64_DIAMETR/Scripts/Meta_Airwave_ICL/hpdi/model_whole.RData /home/jdominguez1/B64_DIAMETR/Scripts/Meta_Airwave_ICL/hpdi hpdi_long