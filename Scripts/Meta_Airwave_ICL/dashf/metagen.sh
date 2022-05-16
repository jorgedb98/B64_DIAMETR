#!/bin/bash

#SBATCH -J metagen
#SBATCH -o logs/metagen.out
#SBATCH -e logs/metagen.err
#SBATCH -p long

for i in {1..24}
do
singularity exec -B /projects/regicor:/projects/regicor /home/jdominguez1/imgs/RGsetChannel.sif Rscript /home/jdominguez1/B64_DIAMETR/Scripts/Meta_Airwave_ICL/dashf/mini_longs/metagen.R /home/jdominguez1/B64_DIAMETR/Scripts/Meta_Airwave_ICL/dashf/mini_longs/mini_longs$i/long_$i.RData /home/jdominguez1/B64_DIAMETR/Scripts/Meta_Airwave_ICL/dashf/mini_longs/mini_longs$i metagen_$i
done
