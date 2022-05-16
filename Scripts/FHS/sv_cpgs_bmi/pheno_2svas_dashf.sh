#!/bin/bash


#SBATCH -J dashf_sva
#SBATCH -o logs/dashf_sva.out
#SBATCH -e logs/dashf_sva.err
#SBATCH -p fast

singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv_cpgs_bmi/pheno_2svas.R /home/jdominguez1/B64_DIAMETR/Dades/FHS/phenofood_fhs_23022022.RData /home/jdominguez1/meth/mt_value_n_no_extrem_value_analysis.RData dashf /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv_cpgs_bmi/num_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv_cpgs_bmi/chr_covar.sh /home/jdominguez1/B64_DIAMETR/Scripts/FHS/sv_cpgs_bmi/dashf pheno_sva_ 2
