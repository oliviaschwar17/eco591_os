#!/bin/bash
##
#SBATCH --account=priority-bioe-591-genomics    #specify the account to use
#SBATCH --job-name=os_bwa                   	# job name
#SBATCH --partition=priority              		# queue partition to run the job in
#SBATCH --nodes=1                     			# number of nodes to allocate
#SBATCH --ntasks-per-node=1             		# number of descrete tasks - keep at one except for MPI
#SBATCH --cpus-per-task=1              			# number of cores to allocate
#SBATCH --time=0-00:30:00                 		# Maximum job run time
#SBATCH --output=os_bwa-%j.out
#SBATCH --error=os_bwa-%j.err

# load mamba and environment
source ~/.bashrc
conda activate align

# bwa local alignment
bwa index hemoglobin_references.fasta

bwa mem -t 4 hemoglobin_references.fasta trimmed_reads/Diglossa_lafresnayii_218845_R1_001_trim.fastqz trimmed_reads/Diglossa_lafresnayii_218845_R2_001_trim.fastq.gz > 218845.sam
bwa mem -t 4 hemoglobin_references.fasta trimmed_reads/Diglossa_lafresnayii_219529_R1_001_trim.fastqz trimmed_reads/Diglossa_lafresnayii_219529_R2_001_trim.fastq.gz > 219529.sam

