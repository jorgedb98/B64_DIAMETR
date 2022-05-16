#!/bin/bash


#SBATCH -J bacon_mmds
#SBATCH -o logs/bacon_mmds.out
#SBATCH -e logs/bacon_mmds.err
#SBATCH -p long


singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv_cpgs_bmi/mmds/bacon.R /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv_cpgs_bmi/mmds/model_mmds_cpgs_bmi.RData
