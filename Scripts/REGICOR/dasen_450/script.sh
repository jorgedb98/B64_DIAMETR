#!/bin/bash

#SBATCH -J 450
#SBATCH -o 450.out
#SBATCH -e 450.err
#SBATCH -p fast

singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/dasen_450/regicor_450_getting.R
