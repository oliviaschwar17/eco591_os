#!/bin/bash
##
## example-array.slurm.sh: submit an array of jobs with a varying parameter
##
## Lines starting with #SBATCH are read by Slurm. Lines starting with ## are comments.
## All other lines are read by the shell.
##
#SBATCH --account=priority-bioe-591-genomics        #specify the account to use
#SBATCH --job-name=fastp_os                             # job name
#SBATCH --partition=priority              # queue partition to run the job in
#SBATCH --nodes=1                       # number of nodes to allocate
#SBATCH --ntasks-per-node=1             # number of descrete tasks - keep at one except for MPI
#SBATCH --cpus-per-task=1              # number of cores to allocate
#SBATCH --time=0-00:30:00                 # Maximum job run time
#SBATCH --output=fastp_os-%j.out
#SBATCH --error=fastp_os-%j.err

source ~/.bashrc

# activate your fastp environment
conda activate fastp

# run fastp
fastp -i ~/bioe-591-genomics/course-materials/data/raw_reads/Diglossa_lafresnayii/Diglossa_lafresnayii_218845_R1_001.fastq.gz \
-o ~/bioe-591-genomics/students/liv-schwartz/trimmed_reads/Diglossa_lafresnayii_218845_R1_001_trim.fastqz \
-I ~/bioe-591-genomics/course-materials/data/raw_reads/Diglossa_lafresnayii/Diglossa_lafresnayii_218845_R2_001.fastq.gz \
-O ~/bioe-591-genomics/students/liv-schwartz/trimmed_reads/Diglossa_lafresnayii_218845_R2_001_trim.fastq.gz \
-h ~/bioe-591-genomics/students/liv-schwartz/trimmed_reads/hw4_os.fastp.html \
-j ~/bioe-591-genomics/students/liv-schwartz/trimmed_reads/hw4_os.fastp.json

