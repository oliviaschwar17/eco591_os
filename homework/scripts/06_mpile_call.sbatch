#!/bin/bash
##
#SBATCH --account=priority-bioe-591-genomics    #specify the account to use
#SBATCH --job-name=bcf_pileup                  	# job name
#SBATCH --partition=priority              		# queue partition to run the job in
#SBATCH --nodes=1                     			# number of nodes to allocate
#SBATCH --ntasks-per-node=1             		# number of descrete tasks - keep at one except for MPI
#SBATCH --cpus-per-task=1              			# number of cores to allocate
#SBATCH --time=0-00:30:00                 		# Maximum job run time
#SBATCH --output=bcf_pileup-%j.out
#SBATCH --error=bcf_pileup-%j.err

# load mamba and environment
source ~/.bashrc
conda activate bcftools

bcftools mpileup -f hemoglobin_references.fasta 218845.sorted.bam 219529.sorted.bam | bcftools call -mv -Ov -o d_lay.vcf 
