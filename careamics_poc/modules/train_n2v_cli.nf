process TRAIN_N2V_CLI {
    label 'process_gpu_medium'
    
    input: 
    tuple   val(meta), path(train), path(val), val(model)

    output:
    path("*.yaml"), emit: config
    path("checkpoints/last.ckpt"), emit: model

    script:
    def args = task.ext.args ?: ''
    """
    train_n2v.py   --train_data $train --val_data $val --model $model   --output_path . $args 
    """
}
