#!/bin/bash

#SBATCH -J betas
#SBATCH -o betas.out
#SBATCH -e betas.err
#SBATCH -p fast

singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/betas_regicor/betas.R

