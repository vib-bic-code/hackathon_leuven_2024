process configuration {
    label 'config'
    publishDir "${params.output_path}", pattern : "*.yaml", mode : "copy"
    input: tuple val(model), val(expname), val(batch_size), val(patch_size), val(num_epochs),val(axes)

    output:
    path "*.yaml", emit: config
    script:
    """
    careamics conf $model --experiment-name $expname --batch-size $batch_size --patch-size $patch_size --num-epochs $num_epochs --axes $axes  
    """
}
