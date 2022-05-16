#!/bin/bash

#SBATCH -J meta_mmds
#SBATCH -o logs/meta_mmds.out
#SBATCH -e logs/meta_mmds.err
#SBATCH -p long

singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/Meta_Airwave_ICL/mmds/meta.R /home/jdominguez1/B64_DIAMETR/Scripts/Meta_Airwave_ICL/mmds/model_whole.RData /home/jdominguez1/B64_DIAMETR/Scripts/Meta_Airwave_ICL/mmds mmds_long