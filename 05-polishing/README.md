# 05-polishing

This directory contains scripts for polishing the draft assembly using first Nanopore long reads with Medaka, followed by Illumina short reads with Pilon. Following each polishing step, assembly QC should be conducted to assess the extent of improvements (or lack thereof) in the assembly.

1-2 rounds of polishing with each of the datasets should be sufficient. 

Following polishing with Medaka, the Illumina short reads need to be mapped to the polished assembly using the `03-pilon-preprocessing.sl` script. 
