#!/bin/bash

#SBATCH -J betas_analysis_epic
#SBATCH -o betas_analysis_epic.out
#SBATCH -e betas_analysis_epic.err
#SBATCH -p long

singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/betas_regicor/analysis_betas_epic.R




