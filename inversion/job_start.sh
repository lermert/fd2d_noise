#!/bin/bash


while true; do
    read -p "Do conversion to mex-functions? " yn
    case $yn in
        [Yy]* ) cd ../code/mex_functions; rm -f run_*; matlab -nodisplay < compile.m; cd ../../inversion; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done


nf=`ls -l ../output/interferometry/G_2_* 2>/dev/null | grep -v ^l | wc -l`

if [ $nf -gt 0 ]; then
	while true; do
	    read -p "Move Green functions in output/interferometry? " yn
	    case $yn in
	        [Yy]* ) var=$(date '+%Y_%m_%d_%H_%M_%S'); mkdir ../../backup/$var; mv ../output/interferometry/G_2_*.mat ../../backup/$var/; break;;
	        [Nn]* ) break;;
	        * ) echo "Please answer yes or no.";;
	    esac
	done
fi

# bsub -W "12:00" -R "rusage[mem=3072]" -o "logs/matlab_%J.out" -e "logs/matlab_%J.err" -n 1 matlab -nodisplay -singleCompThread -r start_inversion

sbatch inversion.sh
