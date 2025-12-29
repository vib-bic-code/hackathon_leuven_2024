process TRAIN_CARE {
    label 'process_gpu_medium'
    conda 'careamics'    

    input: tuple val(meta), path(train), path(target, name: "target/*"), val(model)

    output:
    path("*.yaml"), emit: config
    path("checkpoints/last.ckpt"), emit: model
    // how to select the ckpt with lowest mae?
    when:

    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    """
    train_care.py   --train_data $train --train_target $target --model $model   --output_path . $args 
    """
    stub:
    """
    touch "config.yaml"
    mkdir checkpoints
    cd checkpoints
    touch "last.ckpt"
    """
}