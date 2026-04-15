#!/bin/bash
##
#SBATCH --account=priority-bioe-591-genomics        
#SBATCH --job-name=ngsrelate                            
#SBATCH --partition=priority              
#SBATCH --nodes=1                       
#SBATCH --ntasks-per-node=1             
#SBATCH --cpus-per-task=1              
#SBATCH --time=0-10:00:00                 
#SBATCH --output=ngsrelate-%j.out
#SBATCH --error=ngsrelate-%j.err

source ~/.bashrc
conda activate ngsrelate

# gzip the vcf
bcftools view -Oz -o Addax_MaxMissing10.recode.vcf.gz Addax_MaxMissing10.recode.vcf

# index the vcf
tabix -p vcf Addax_MaxMissing10.recode.vcf.gz

# generate a sample ID file 
bcftools query -l Addax_MaxMissing10.recode.vcf.gz > Addax_MaxMissing10_ids.txt

# call ngsRelate
ngsRelate -h Addax_MaxMissing10.recode.vcf.gz -T GT -c 1 -O Addax_MaxMissing10.ngsrelate.out -z Addax_MaxMissing10_ids.txt
