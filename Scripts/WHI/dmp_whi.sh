#!/bin/bash

#SBATCH -J dmp_whi
#SBATCH -o dmp_whi.out
#SBATCH -e dmp_whi.err
#SBATCH -p long

singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/WHI/dmp_whi.R
