process BIAFLOWS_OBJSEG {
    tag "$meta.id"
    label 'process_single'

    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'quay.io/cellgeni/biaflows-utilities:0.9.3':
        'quay.io/cellgeni/biaflows-utilities:0.9.3' }"

    input:
    tuple val(meta), path(pred_image), path(ground_truth)

    output:
    tuple val(meta), path("*.csv"), emit: metrics
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    objseg_qc_wrapper.py run \\
        -prediction ${pred_image} \\
        -ground_truth ${ground_truth} \\
        -o ${prefix}.csv \\
        -T $prefix \\
        $args \\

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        biaflows: \$(compute_metrics.py version)
    END_VERSIONS
    """

    stub:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    touch ${prefix}.csv

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        biaflows: \$(compute_metrics.py version)
    END_VERSIONS
    """
}
