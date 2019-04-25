rule haplotype_caller:
    threads: 5
    input:
        ref=config["ref"]["genome"],
        bam="dedup/{sample}.recal.bam"
        # known="dbsnp.vcf"  # optional
    output:
        gvcf="calls/{sample}.g.vcf",
    log:
        "logs/gatk/haplotypecaller/{sample}.log"
    params:
        extra="--dont-use-soft-clipped-bases true -stand-call-conf 20.0",  # optional
        java_opts="", # optional
    wrapper:
        "0.32.0/bio/gatk/haplotypecaller"

rule combine_gvcfs:
    input:
        gvcfs=expand("calls/{sample}.g.vcf", sample=wildcards.sample),
        ref=config["ref"]["genome"]
    output:
        gvcf="calls/all.g.vcf",
    log:
        "logs/gatk/combinegvcfs.log"
    params:
        extra="",  # optional
        java_opts="",  # optional
    wrapper:
        "0.32.0/bio/gatk/combinegvcfs"

rule genotype_gvcfs:
    input:
        gvcf="calls/all.g.vcf",  # combined gvcf over multiple samples
        ref=config["ref"]["genome"]
    output:
        vcf="calls/all.vcf",
    log:
        "logs/gatk/genotypegvcfs.log"
    params:
        extra="",  # optional
        java_opts="", # optional
    wrapper:
        "0.32.0/bio/gatk/genotypegvcfs"

