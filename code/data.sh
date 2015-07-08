#!/bin/bash -l								

#SBATCH --partition=fichtner_compute
#SBATCH --job-name=data
#SBATCH --output=logs/matlab_%j.out
#SBATCH --error=logs/matlab_%j.err
#SBATCH --time=02:00:00
#SBATCH --ntasks=1
#SBATCH --mem=1024


######################
# Begin work section #
######################

module load matlab/r2015a
matlab -nodisplay -singleCompThread -r calculate_data

