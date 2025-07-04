process configuration {
    label 'config'
    publishDir "${params.output_path}", pattern : "config/*.yaml", mode : "copy"
    input: tuple val(model), val(expname), val(batch_size), val(patch_size), val(num_epochs), val(data_type),val(axis_train)

    output:
    path "config/*.yaml", emit: config
    script:
    """
    mkdir -p config
    config.py --model $model --exp_name $expname --batch_size $batch_size --patch_size $patch_size --num_epochs $num_epochs --data_type  $data_type --axis_train $axis_train  --output_path ./config
    """
}
