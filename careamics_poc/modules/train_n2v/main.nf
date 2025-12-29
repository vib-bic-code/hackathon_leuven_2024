process TRAIN_N2V {
    label 'process_gpu_medium'
    conda 'careamics'    

    input: tuple val(meta), path(train), val(model)

    output:
    path("*.yaml"), emit: config
    path("checkpoints/last.ckpt"), emit: model

    when:

    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    """
    train_n2v.py   --train_data $train  --model $model   --output_path . $args 
    """
    stub:
    """
    touch "config.yaml"
    mkdir checkpoints
    cd checkpoints
    touch "last.ckpt"
    """
}
