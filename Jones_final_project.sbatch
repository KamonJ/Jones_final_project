#!/bin/bash
#
#SBATCH --partition=large_mem
#SBATCH --ntasks=1
#SBATCH --mem=300G
#SBATCH --output=Jones_%J_sdtout.txt
#SBATCH --error=Jones_%J_stderr.txt
#SBATCH --time=20
#SBATCH --job-name=Jones_final_project
#SBATCH --mail-user=kaj5655@utulsa.edu
#SBATCH --mail-type=ALL
#SBATCH --chdir=.
#

#change directory to current directory
cd $sequences_and_refgenome

#Load all the necessary programs: Bowtie2, SAMtools, and BCFtools
module load Bowtie2/2.3.5.1-GCC-8.3.0
module load  SAMtools/1.10-GCC-8.3.0
module load BCFtools/1.10.2-GCC-8.3.0




#Create a file to place species folders into, so they can be used in the Bowtie2 program
touch Spider_seq.fasta

#Create a file for each species. Add both gene sequences from every species to the corresponding species folder. Next, add the species folders to the Spider_seq.fasta folder
touch Habronattus_tarsalis1 | cat sequences_and_refgenome/SRR6381061.sra_1.fastq > Habronattus_tarsalis1 >> Spider_seq.fasta; cat sequences_and_refgenome/SRR6381061.sra_2.fastq >> Habronattus_tarsalis1 >> Spider_seq.fastq
touch Habronattus_virgulatus1 | cat sequences_and_refgenome/SRR6381062.sra_1.fastq > Habronattus_virgulatus1 >> Spider_seq.fasta; cat sequences_and_refgenome/SRR6381062.sra_2.fastq >> Habronattus_virgulatus1 >> Spider_seq.fastq

#Create a file to place both reference gene sequences into and add files to new folder
touch Habronattus_reference_genome.fasta
cat Habronattus_elongation_factor_1_alpha_gene_sequence2.fasta > Habronattus_reference_genome.fasta
cat Habronattus_mitochondrial_sequence.fasta  >> Habronattus_reference_genome.fasta

#Using the Bowtie2 program, index your reference genome
bowtie2-build Habronattus_reference_genome.fasta Habronattus_reference_genome.btindex

#Run the Bowtie2 program. Make sure to include your newest .fastq folder
bowtie2 -x Habronattus_reference_genome.btindex -U Spider_seq.fastq -S reads.sam 

#Convert the SAM file to a BAM file using SAMtools subcommand. This will sort the reads left-to-right on the reference genome
samtools view -bS reads.sam > reads.bam

#Sort reads in the BAM file using SAMtools subcommand
samtools sort reads.bam -o reads-sorted.bam 

#Visualize the reads using an IGV or IGB browser. Load .bam file into browser to view reads
samtools view -uS reads.sam | samtools sort - -o reads-sorted.bam

#Create an index from the BAM file using SAMtool subcommand
samtools index reads-sorted.bam

#To create a consensus sequence:

#Make a pileup format of the read data from the BAM file. Next, feed the output to BCFtools program to convert to VCF file
samtools mpileup -uf Habronattus_reference_genome.fasta reads-sorted.bam | bcftools call -c > Spider.vcf.gz
cat Spider.vcf.gz | bcftools consensus -f Habronattus_mitochondrial_sequence.fasta > Spider.fasta  

#samtools faidx Habronattus_reference_genome.fasta | bcftools consensus Spider.vcf.gz > Spider.fasta

