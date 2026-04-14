#!/bin/bash
##
#SBATCH --account=priority-bioe-591-genomics    #specify the account to use
#SBATCH --job-name=new_snp                   	# job name
#SBATCH --partition=priority              		# queue partition to run the job in
#SBATCH --nodes=1                     			# number of nodes to allocate
#SBATCH --ntasks-per-node=1             		# number of descrete tasks - keep at one except for MPI
#SBATCH --cpus-per-task=1              			# number of cores to allocate
#SBATCH --time=0-00:30:00                 		# Maximum job run time
#SBATCH --output=new_snp-%j.out
#SBATCH --error=new_snp-%j.err

# load mamba and environment
source ~/.bashrc
conda activate vcftools

echo -e "file\tsnp_count" > new_snp.tsv
for f in *recode.vcf; do
    count=$(bcftools view -H -v snps "$f" | wc -l)
    echo -e "${f}\t${count}" >> new_snp.tsv
done
