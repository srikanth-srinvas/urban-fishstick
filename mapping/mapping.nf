// Define parameters
params.index_dir = "/Users/srikanth/data/scripts/nextflow/mapping/reference_genome"
params.ref = "sequence.fasta"
params.fastq = "/Users/srikanth/data/scripts/example_data/fastqs_forQC/*_{R1,R2}.fastq.gz"

// Define the mapping process
process mapping {

    // Input definitions
    input:
    path index_dir          // Path to the directory containing the reference genome index
    val ref                 // Name of the reference genome file
    tuple val(sample_id), path(reads)  // Sample ID and paths to paired-end FASTQ files

    // Output definitions
    output:
    path "*"

    // Command script
    script:
    """
    bwa mem ${index_dir}/${ref} ${reads[0]} ${reads[1]} | samtools view -h -b -o ${sample_id}.bam -
    """
}

// Define the workflow
workflow {

    // Create channels from input parameters
    index_ch = Channel.fromPath(params.index_dir)
    ref_ch = Channel.of(params.ref)
    fastq_ch = Channel.fromFilePairs(params.fastq, flat: true)

    // Run the mapping process
    mapping(index_ch, ref_ch, fastq_ch)

    // View the output of the mapping process
    mapping.out.view()
}
