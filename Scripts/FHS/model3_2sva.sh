#!/bin/bash

#SBATCH -n 1 
#SBATCH --cpus-per-task=12
#SBATCH -p fast
#SBATCH -N 1
#SBATCH --mem=100000

singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/FHS/dmp_fhs_2.R /home/jdominguez1/B64_DIAMETR/Dades/FHS/fhs_diet_cellsVarsFam.RData /home/jdominguez1/meth/b_meth_dasen_fhs_no_xy.RData mds /home/jdominguez1/B64_DIAMETR/Scripts/FHS/mds/numCovar.sh /home/jdominguez1/B64_DIAMETR/Scripts/FHS/mds/chrCovar.sh /home/jdominguez1/B64_DIAMETR/Scripts/FHS/mds model3_2sva_mds
