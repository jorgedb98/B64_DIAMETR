#!/bin/bash

#SBATCH -J RGSet_analysis
#SBATCH -o RGSet_analysis.out
#SBATCH -e RGSet_analysis.err
#SBATCH -p long

singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/RGSet_analysis/RGset_analysis.R
