process TRAIN_N2N_CARE {
    label 'process_gpu_medium'
    conda 'careamics'    

    input: tuple val(meta), path(train), path(target, name: "target/*"), val(model)

    output:
    path("*.yaml"), emit: config
    path("checkpoints/last.ckpt"), emit: model

    when:

    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    """
    train_n2n_care.py   --train_data $train --train_target $target --model $model   --output_path . $args 
    """
    stub:
    """
    touch "config.yaml"
    mkdir checkpoints
    cd checkpoints
    touch "last.ckpt"
    """
}
