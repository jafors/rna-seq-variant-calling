rule star:
    input:
        # use a list for multiple fastq files for one sample
        # usually technical replicates across lanes/flowcells
        fq1 = ["reads/{sample}_R1.1.fastq", "reads/{sample}_R1.2.fastq"],
        # paired end reads needs to be ordered so each item in the two lists match
        fq2 = ["reads/{sample}_R2.1.fastq", "reads/{sample}_R2.2.fastq"] #optional
    output:
        # see STAR manual for additional output files
        "star/{sample}/Aligned.out.bam"
    log:
        "logs/star/{sample}.log"
    params:
        # path to STAR reference genome index
        index="index",
        # optional parameters
        extra="--outSAMmapqUnique 60"
    threads: 8
    wrapper:
        "0.32.0/bio/star/align"
