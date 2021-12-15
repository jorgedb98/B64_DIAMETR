#!/bin/bash

#SBATCH -J mds_whi_model
#SBATCH -o mds_whi_model.out
#SBATCH -e mds_whi_model.err
#SBATCH -p fast


singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv/mds/model_mds.R /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv/mds/pheno_sva_2.csv /home/jdominguez1/meth/mvals_z_4sd.RData mds /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv/mds/num_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv/mds/chr_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/WHI/sv/mds model_2sva_mds
