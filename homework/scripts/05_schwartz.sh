#!/bin/bash
##
#SBATCH --account=priority-bioe-591-genomics    #specify the account to use
#SBATCH --job-name=bwa_sam                   	# job name
#SBATCH --partition=priority              		# queue partition to run the job in
#SBATCH --nodes=1                     			# number of nodes to allocate
#SBATCH --ntasks-per-node=1             		# number of descrete tasks - keep at one except for MPI
#SBATCH --cpus-per-task=1              			# number of cores to allocate
#SBATCH --time=0-00:30:00                 		# Maximum job run time
#SBATCH --output=bwa_sam-%j.out
#SBATCH --error=bwa_sam-%j.err

# load mamba and environment
source ~/.bashrc
conda activate align

# bwa local alignment
bwa index /home/k63q376/bioe-591-genomics/course-materials/data/references/hemoglobin_references.fasta

bwa mem -t 4 hemoglobin_references.fasta Diglossa_lafresnayii_218845_R1_001_trim.fastqz 	Diglossa_lafresnayii_218845_R2_001_trim.fastq.gz > 218845.sam
bwa mem -t 4 hemoglobin_references.fasta Diglossa_lafresnayii_219529_R1_001_trim.fastqz 	Diglossa_lafresnayii_219529_R2_001_trim.fastq.gz > 219529.sam

# samtools(open, convert, pipe into sort, name new output and index)
samtools faidx /home/k63q376/bioe-591-genomics/course-materials/data/references/hemoglobin_references.fasta

samtools view -b 218845.sam | samtools sort -o 218845.sorted.bam
samtools index 218845.sorted.bam

samtools view -b 219529.sam | samtools sort -o 219529.sorted.bam
samtools index 219529.sorted.bam
