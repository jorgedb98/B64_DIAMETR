#!/bin/bash

#SBATCH -J meta_dashf
#SBATCH -o logs/meta_dashf.out
#SBATCH -e logs/meta_dashf.err
#SBATCH -p long

singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/Meta_Airwave_ICL/dashf/meta.R /home/jdominguez1/B64_DIAMETR/Scripts/Meta_Airwave_ICL/dashf/model_whole.RData /home/jdominguez1/B64_DIAMETR/Scripts/Meta_Airwave_ICL/dashf dashf_long