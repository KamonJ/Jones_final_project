# Jones_final_project

Purpose:

The purpose of this script is to create a list of spider gene sequences in the order of species. 
Then use these sequences to map reads to a reference genome and create a consensus from the
mapped reads.

Prerequisites:

You must download the spider sequences and reference genome to your OS.



The easiest way to download the spider sequences is to install and configure the program SRA toolkit from
the SRA page on ncbi.nlm.nih.gov:

	
	1) Once install and configured, you can download the sequences with- 
	   
	   $prefetch SRR...(one run) 
		
					OR
	   
	   $prefetch --option-file SraAcclist.txt (list of runs)

	
	2) Next, you must convert your compressed .sra file to a .fastq file. Use this to convert-
	   
	   fasterq-dump --split-files SRR...


Download the reference genome:

	1)  Since the reference genome is a FASTA file, simply download the sequences from the SRA page 
	    on ncbi.nlm.nih.gov

