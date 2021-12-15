#!/bin/bash

#SBATCH -J mmds_reg450k_model
#SBATCH -o mmds_reg450k_model.out
#SBATCH -e mmds_reg450k_model.err
#SBATCH -p fast


singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/450k/mmds/model_mmds.R /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/450k/mmds/pheno_sva_2.csv /home/jdominguez1/meth/mt_regicor_450.RData mmds_b /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/450k/mmds/num_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/450k/mmds/chr_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/450k/mmds model_2sva_mmds
