#!/bin/bash -l								

#SBATCH --partition=fichtner_compute
#SBATCH --job-name=inversion
#SBATCH --output=logs/matlab_%j.out
#SBATCH --error=logs/matlab_%j.err
#SBATCH --time=01:00:00
#SBATCH --ntasks=1
#SBATCH --mem=3072

######################
# Begin work section #
######################

module load matlab/r2015a
matlab -nodisplay -singleCompThread -r start_inversion

