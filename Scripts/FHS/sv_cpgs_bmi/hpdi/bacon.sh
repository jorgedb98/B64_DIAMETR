#!/bin/bash


#SBATCH -J bacon_hpdi
#SBATCH -o logs/bacon_hpdi.out
#SBATCH -e logs/bacon_hpdi.err
#SBATCH -p long


singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv_cpgs_bmi/hpdi/bacon.R /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv_cpgs_bmi/hpdi/model_hpdi_cpgs_bmi.RData
