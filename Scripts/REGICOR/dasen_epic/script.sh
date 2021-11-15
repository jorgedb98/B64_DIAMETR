#!/bin/bash

#SBATCH -J epic
#SBATCH -o epic.out
#SBATCH -e epic.err
#SBATCH -p fast

singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/dasen_epic/epic_getting.R
