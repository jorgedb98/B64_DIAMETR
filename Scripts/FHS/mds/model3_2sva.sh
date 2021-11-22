#!/bin/bash

#SBATCH -J mds_fhs
#SBATCH -o mds_fhs.out
#SBATCH -e mds_fhs.err
#SBATCH -p fast


singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/FHS/dmp_fhs_2.R /home/jdominguez1/B64_DIAMETR/Dades/FHS/fhs_diet_cellsVarsFam.RData /home/jdominguez1/meth/b_meth_dasen_fhs_no_xy.RData mds /home/jdominguez1/B64_DIAMETR/Scripts/FHS/mds/numCovar.sh /home/jdominguez1/B64_DIAMETR/Scripts/FHS/mds/chrCovar.sh /home/jdominguez1/B64_DIAMETR/Scripts/FHS/mds model3_2sva_mds
