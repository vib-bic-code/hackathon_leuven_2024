process configuration {
    label 'config'
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