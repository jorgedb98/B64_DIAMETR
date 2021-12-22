#!/bin/bash

#SBATCH -J hpdi_reg450k_model
#SBATCH -o hpdi_reg450k_model.out
#SBATCH -e hpdi_reg450k_model.err
#SBATCH -p long


singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/450k/hpdi/model_hpdi.R /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/450k/hpdi/pheno_sva_2.csv /home/jdominguez1/meth/mt_regicor_450.RData hpdi_b /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/450k/hpdi/num_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/450k/hpdi/chr_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/REGICOR/sv/450k/hpdi model_2sva_hpdi
