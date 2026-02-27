#!/bin/bash
##
#SBATCH --account=priority-bioe-591-genomics    #specify the account to use
#SBATCH --job-name=map_stats                   	# job name
#SBATCH --partition=priority              		# queue partition to run the job in
#SBATCH --nodes=1                    			# number of nodes to allocate
#SBATCH --ntasks-per-node=1             		# number of descrete tasks - keep at one except for MPI
#SBATCH --cpus-per-task=1              			# number of cores to allocate
#SBATCH --time=0-00:30:00                 		# Maximum job run time
#SBATCH --output=map_stats-%j.out
#SBATCH --error=map_stats-%j.err

# load mamba and environment
source ~/.bashrc
conda activate align

samtools flagstat 218845.sorted.bam > alignment_stats_218.txt
samtools depth 218845.sorted.bam | awk '{sum+=$3} END {print sum/NR}' > depth_218.txt

samtools flagstat 219529.sorted.bam > alignment_stats_219.txt
samtools depth 219529.sorted.bam | awk '{sum+=$3} END {print sum/NR}' > depth_219.txt
