#!/usr/bin/zsh

# homework 01
## change into raw directory

cd ~/Users/olivia/eco591/test/week_1/;

## create subdirectories

mkdir fastq/;
mkdir fasta/;
mkdir metadata/;

## move files into directories based on file extension

mv *.fastq.gz fastq/;
mv *.fasta fasta/;
mv *.csv metadata/;

## count how many files are in each new directory and print to screen

ls fastq/*fastq.gz | wc -l;
ls fasta/*.fasta | wc -l;
ls metadata/*.csv | wc -l

echo "all done!"
