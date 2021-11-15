#!/bin/bash

#SBATCH -J betas_analysis_450
#SBATCH -o betas_analysis_450.out
#SBATCH -e betas_analysis_450.err
#SBATCH -p fast

singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/betas_regicor/analyis_betas_450.R



