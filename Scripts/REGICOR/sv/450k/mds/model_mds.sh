#!/bin/bash

#SBATCH -J mds_reg450k_model
#SBATCH -o mds_reg450k_model.out
#SBATCH -e mds_reg450k_model.err
#SBATCH -p long


singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/450k/mds/model_mds.R /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/450k/mds/pheno_sva_2.csv /home/jdominguez1/meth/mt_regicor_450.RData mds_b /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/450k/mds/num_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/450k/mds/chr_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/450k/mds model_2sva_mds
