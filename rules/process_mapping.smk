rule deduplicate:
    input:
        "star/{sample}/Aligned.out.sorted.bam"
    output:
        bam="dedup/{sample}.bam",
        bai="dedup/{sample}.bam.bai",
        metrics="dedup/{sample}.metrics.txt"
    log:
        "logs/picard/dedup/{sample}.log"
    params:
        "REMOVE_DUPLICATES=true CREATE_INDEX=true"
    wrapper:
        "0.32.0/bio/picard/markduplicates"

rule addreadgroups:
    input:
        "dedup/{sample}.bam"
    output:
        "dedup/{sample}.rg.bam"
    log:
        "logs/picard/add_rg/{sample}.log"
    params:
        "RGLB=lib1 RGPL=illumina RGPU={sample} RGSM={sample}"
    wrapper:
        "0.32.0/bio/picard/addorreplacereadgroups"

rule splitncigarreads:
    input:
        bam="dedup/{sample}.rg.bam",
        ref=config["ref"]["genome"]
    output:
        "dedup/{sample}.split.bam"
    log:
        "logs/gatk/splitNCIGARreads/{sample}.log"
    params:
        extra=""
    wrapper:
        "bio/gatk/splitncigarreads"

rule gatk_bqsr:
    input:
        bam="dedup/{sample}.split.bam",
        ref=config["ref"]["genome"],
        known=config["ref"]["dbsnp"]
    output:
        bam="dedup/{sample}.recal.bam"
    log:
        "logs/gatk/bqsr/{sample}.log"
    params:
        extra="",
        java_opts=""
    wrapper:
        "0.32.0/bio/gatk/baserecalibrator"





