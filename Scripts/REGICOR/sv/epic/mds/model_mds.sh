#!/bin/bash

#SBATCH -J mds_epic_model
#SBATCH -o mds_epic_model.out
#SBATCH -e mds_epic_model.err
#SBATCH -p roadruner


singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/epic/mds/model_mds.R /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/epic/mds/pheno_sva_3.csv /home/jdominguez1/meth/epic_total_mtval.RData mds_b /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/epic/mds/num_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/epic/mds/chr_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/epic/mds model_2sva_mds
