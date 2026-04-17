#!/bin/bash
##
#SBATCH --account=priority-bioe-591-genomics        
#SBATCH --job-name=admixture                  
#SBATCH --partition=priority              
#SBATCH --nodes=1                       
#SBATCH --ntasks-per-node=1             
#SBATCH --cpus-per-task=1              
#SBATCH --time=0-10:00:00                 
#SBATCH --output=admixture-%j.out
#SBATCH --error=admixture-%j.err

source ~/.bashrc
conda activate admixture

for K in {2..5}; do
  admixture --cv species.int.bed $K | tee log${K}.out
done
