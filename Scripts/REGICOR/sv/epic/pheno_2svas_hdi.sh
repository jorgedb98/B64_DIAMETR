#!/bin/bash


#SBATCH -J hdi_sva
#SBATCH -o hdi_sva.out
#SBATCH -e hdi_sva.err
#SBATCH -p long

singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/pheno_2svas.R /home/jdominguez1/B64_DIAMETR/Dades/FHS/fhs_diet_cellsVarsFam.RData /home/jdominguez1/meth/mt_value_n_no_extrem_value_analysis.RData hdi2015 /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/num_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/chr_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/hdi2015 pheno_sva_
