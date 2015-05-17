
bsub -o "logs/matlab_%J.out" -e "logs/matlab_%J.err" -n 1 matlab -singleCompThread -r start_inversion
