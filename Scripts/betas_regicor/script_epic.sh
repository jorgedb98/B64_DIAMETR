#!/bin/bash

#SBATCH -J betas_epic
#SBATCH -o betas_epic.out
#SBATCH -e betas_epic.err
#SBATCH -p fast

singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/betas_regicor/betas_epic.R

