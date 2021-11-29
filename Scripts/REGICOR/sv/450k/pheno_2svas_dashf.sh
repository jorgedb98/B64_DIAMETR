#!/bin/bash


#SBATCH -J dashf_sva
#SBATCH -o dashf_sva.out
#SBATCH -e dashf_sva.err
#SBATCH -p long

singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/pheno_2svas.R /home/jdominguez1/B64_DIAMETR/Dades/FHS/fhs_diet_cellsVarsFam.RData /home/jdominguez1/meth/mt_value_n_no_extrem_value_analysis.RData dashf /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/num_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/chr_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv/dashf pheno_sva_
