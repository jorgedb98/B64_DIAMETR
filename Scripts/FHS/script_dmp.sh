#!/bin/bash

#SBATCH -J dmp_fhs
#SBATCH -o dmp_fhs.out
#SBATCH -e dmp_fhs.err
#SBATCH -p fast

singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/FHS/dmp_fhs.R


