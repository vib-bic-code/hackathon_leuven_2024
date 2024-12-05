process PALOM {
    tag   "$meta.id"
    label 'process_single'

    container "docker.io/kbestak/palom:2024.10.2"

    input:
    tuple val(meta), path(images)

    output:
    tuple val(meta), path("*.ome.tif"), emit: registered_image
    path "versions.yml"               , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    if (workflow.profile.tokenize(',').intersect(['conda', 'mamba']).size() >= 1) {
        error "Conda not yet supported. Please use Docker / Singularity instead."
    }
    def args   = task.ext.args   ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    alignment_multichannel_tif.py \\
        --img_list ${images} \\
        --out_dir . \\
        --out_name ${prefix}.ome.tif \\
        $args

    sed -i -E 's/UUID="urn:uuid:[[:xdigit:]]{8}-[[:xdigit:]]{4}-[[:xdigit:]]{4}-[[:xdigit:]]{4}-[[:xdigit:]]{12}"/                                                    /g' ${prefix}.ome.tif

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        palom: \$( python -m pip show --version palom | grep "Version" | sed -e "s/Version: //g" )
        python: \$( python --version | sed -e "s/Python //g" )
    END_VERSIONS
    """

    stub:
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    touch ${prefix}.ome.tif

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        palom: \$( python -m pip show --version palom | grep "Version" | sed -e "s/Version: //g" )
        python: \$( python --version | sed -e "s/Python //g" )
    END_VERSIONS
    """
}
