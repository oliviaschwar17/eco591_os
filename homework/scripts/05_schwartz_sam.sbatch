#!/bin/bash
##
#SBATCH --account=priority-bioe-591-genomics    #specify the account to use
#SBATCH --job-name=os_sam                   	# job name
#SBATCH --partition=priority              		# queue partition to run the job in
#SBATCH --nodes=1                     			# number of nodes to allocate
#SBATCH --ntasks-per-node=1             		# number of descrete tasks - keep at one except for MPI
#SBATCH --cpus-per-task=1              			# number of cores to allocate
#SBATCH --time=0-00:30:00                 		# Maximum job run time
#SBATCH --output=os_sam-%j.out
#SBATCH --error=os_sam-%j.err

# load mamba and environment
source ~/.bashrc
conda activate align

# samtools(open, convert, pipe into sort, name new output and index)
samtools faidx hemoglobin_references.fasta

samtools view -b 218845.sam | samtools sort -o 218845.sorted.bam
samtools index 218845.sorted.bam

samtools view -b 219529.sam | samtools sort -o 219529.sorted.bam
samtools index 219529.sorted.bam
