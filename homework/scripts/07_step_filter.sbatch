#!/bin/bash
##
#SBATCH --account=priority-bioe-591-genomics    #specify the account to use
#SBATCH --job-name=step_filter                   	# job name
#SBATCH --partition=priority              		# queue partition to run the job in
#SBATCH --nodes=1                     			# number of nodes to allocate
#SBATCH --ntasks-per-node=1             		# number of descrete tasks - keep at one except for MPI
#SBATCH --cpus-per-task=1              			# number of cores to allocate
#SBATCH --time=0-00:30:00                 		# Maximum job run time
#SBATCH --output=steps-%j.out
#SBATCH --error=steps-%j.err

# load mamba and environment
source ~/.bashrc
conda activate vcftools

vcftools --gzvcf d_lay.vcf.gz --remove-indels --recode --out step1
vcftools --vcf step1.recode.vcf --max-missing-count 1 --recode --out step2 
vcftools --vcf step2.recode.vcf --mac 2 --recode --out step3
vcftools --vcf step3.recode.vcf --minQ 40 --recode --out step4
vcftools --vcf step4.recode.vcf --minDP 5 --recode --out step5
vcftools --vcf step5.recode.vcf --thin 2 --recode --out final
# summary stats
vcftools --vcf final.recode.vcf --hardy
