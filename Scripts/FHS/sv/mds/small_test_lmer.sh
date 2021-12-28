#!/bin/bash

#SBATCH -J small_lmer
#SBATCH -o small_lmer.out
#SBATCH -e small_lmer.err
#SBATCH -p fast


singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/mds/small_test_lmer.R /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/mds/pheno_sva_2.csv /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/mds/small_mt.RData mds /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/mds/num_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/mds/chr_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/mds model_2sva_mds


