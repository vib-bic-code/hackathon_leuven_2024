process configuration {
    label 'process_single'
     //container "community.wave.seqera.io/library/careamics:0.0.16--973e324f2f759ff5" //docker
    //container "oras://community.wave.seqera.io/library/careamics:0.0.16--2d14874a14adc1ce" //apptainer
    //container "careamics_0.0.16--2d14874a14adc1ce.sif" //local apptainer
    container "careamics:0.0.16" //local docker

    input:
    tuple val(model), val(expname), val(batch_size), val(patch_size), val(num_epochs), val(axes)

    output:
    path "*.yaml", emit: config

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    """
    careamics conf $model --experiment-name $expname --batch-size $batch_size --patch-size $patch_size --num-epochs $num_epochs --axes $axes  $args
    """
}
